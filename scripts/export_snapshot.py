"""Export a restored library_portfolio database via psql in one read-only transaction."""
import argparse
import csv
import io
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EXPECTED = {"books": 29, "authors": 29, "genres": 15}
KEYS = {"books": "book_id", "authors": "author_id", "genres": "genre_id"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--psql", default="psql")
    parser.add_argument("--database", default="library_portfolio", help="Database name. Set PGHOST, PGPORT and PGUSER as needed.")
    parser.add_argument("--output", type=Path, default=ROOT / "data")
    args = parser.parse_args()
    queries = re.split(r"^-- Query \d+\s*", (ROOT / "sql/queries.sql").read_text(encoding="utf-8"), flags=re.M)
    tables = {name: f"TABLE public.{name} ORDER BY {key}" for name, key in KEYS.items()}
    statements = tables | {f"queries/q{i}": q.strip().removesuffix(";") for i, q in enumerate(queries[1:], 1)}
    script = ["BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ READ ONLY;"]
    for name, statement in statements.items():
        script += [f"\\echo BOOKLENS_EXPORT:{name}", f"COPY ({statement}) TO STDOUT WITH CSV HEADER;"]
    script.append("COMMIT;")
    result = subprocess.run(
        [args.psql, "-X", "-q", "-v", "ON_ERROR_STOP=1", "--dbname", args.database, "-f", "-"],
        input="\n".join(script), stdout=subprocess.PIPE, check=True, encoding="utf-8",
    )
    exports = dict(zip(*[iter(re.split(r"^BOOKLENS_EXPORT:(.+)\n", result.stdout, flags=re.M)[1:])]*2))
    if exports.keys() != statements.keys():
        raise ValueError("Unexpected PostgreSQL export sections")
    for name, count in EXPECTED.items():
        actual = sum(1 for _ in csv.DictReader(io.StringIO(exports[name])))
        if actual != count:
            raise ValueError(f"{name}: expected {count} historical rows, got {actual}")
    for name, body in exports.items():
        destination = args.output / f"{name}.csv"
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_text(body, encoding="utf-8", newline="\n")
        print(destination)


if __name__ == "__main__":
    main()
