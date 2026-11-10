# Historical PostgreSQL project

- [original_database.sql](original_database.sql) is a readable reconstruction derived from the 2023 library TAR archive. It contains the source tables, constraints, defaults, sequence positions, and all 73 sample records. Run it with `psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f legacy/original_database.sql` against a fresh, empty database you created for this purpose.
- [original_queries.sql](original_queries.sql) contains the five historical SELECT statements, copied from the original query text. See [modernized SQL](../sql/queries.sql) and [the comparison](../docs/original-vs-modern.md) for the later work.

The archival records reflect a small historical sample. The project team credited Goodreads for the book metadata.
