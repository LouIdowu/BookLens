"""Load the bundled snapshot and derive catalog fields without changing source records."""
import json
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
SORTS = {
    "Highest rating": ("book_rating", False),
    "Most ratings": ("book_rating_count", False),
    "Longest first": ("book_pages", False),
    "Title A–Z": ("book_title", True),
}


def load_catalog():
    books, authors, genres = (pd.read_csv(DATA / f"{name}.csv") for name in ("books", "authors", "genres"))
    catalog = books.merge(authors, on="author_id", how="left", validate="many_to_one")
    catalog = catalog.merge(genres, on="genre_id", how="left", validate="many_to_one")
    catalog["author"] = catalog["name"].fillna(catalog["book_authors"]).fillna("Unknown author")
    catalog["book_genre"] = catalog["genres"].fillna("Unspecified")
    return catalog, authors, genres


def filter_books(catalog, title="", authors=(), genres=(), ratings=None, sort="Highest rating"):
    filtered = catalog.loc[
        catalog["book_title"].fillna("").str.contains(title.strip(), case=False, regex=False)
    ]
    if authors:
        filtered = filtered.loc[filtered["author"].isin(authors)]
    if genres:
        filtered = filtered.loc[filtered["book_genre"].isin(genres)]
    if ratings:
        low, high = ratings
        filtered = filtered.loc[filtered["book_rating"].between(low, high)]
    field, ascending = SORTS[sort]
    return filtered.sort_values([field, "book_id"], ascending=[ascending, True], na_position="last")


def genre_counts(catalog):
    return catalog.groupby("book_genre", as_index=False).size().sort_values(
        ["size", "book_genre"], ascending=[False, True]
    )


def query_results(number):
    return pd.read_csv(DATA / "queries" / f"q{number}.csv")


def provenance():
    return json.loads((DATA / "provenance.json").read_text(encoding="utf-8"))
