# From PostgreSQL to BookLens

In 2023, a University of Maryland team built a fiction-library database to practice relational design and answer questions about books, authors, genres, and Goodreads-related ratings. In 2026, BookLens brought the same collection into a web interface with searchable records, interactive charts, and query results readers can trace back to PostgreSQL.

| | Original library project · 2023 | BookLens · 2026 |
| --- | --- | --- |
| Data | Three PostgreSQL tables with 29 books, 29 authors, and 15 genres | The same records in a portable CSV snapshot |
| Relationships | Books reference authors, and authors reference genres | The same relationships, documented with an interactive app page and ER diagram |
| SQL | Five SELECT queries for ratings, author birth dates, length, and linked genres | The same five questions, with clarified wording, stable ordering, and verified output tables |
| Presentation | Database archive, query text, and an academic report | Search, filtering, analytics, and a browser-based SQL explorer |
| Runtime | PostgreSQL for exploring the relational database | Streamlit serves the data and verified query outputs from bundled files |

## What changed after the March 2023 proposal

The INST 123 proposal sketched a tracker for one person's fiction and nonfiction collection. It proposed tables for books, authors, genres, and publishers, along with hypothetical purchase records. Those records would have supported questions about spending, purchase dates and locations, and publisher coverage. The team also set aside reading progress, user reviews, and detailed author biographies.

The completed team project narrowed the scope to fiction and focused on discovery. The archived books table stores genre labels, format, page counts, and Goodreads-related ratings and review counts. There is no publisher table or purchase history in the archive. The implemented genre relationship goes through the author record, and the book also carries its own genre label. The five delivered queries reflect that shift. They ask about ratings, author birth dates, book length, and linked genres.

Source document: INST 123 Team Project Proposal, University of Maryland, March 17, 2023.

## Follow the source

1. [Readable historical database](../legacy/original_database.sql) reconstructs the schema, all 73 rows, and sequence positions from the PostgreSQL 15.1 TAR archive. The file is a derived SQL representation.
2. [Original queries](../legacy/original_queries.sql) preserve the five SELECT statements as supplied, including their original formatting.
3. [Modern queries](../sql/queries.sql) preserve the projections and predicates while adding deterministic sort keys and an explicit date literal. [The audit](sql-audit.md) explains why Query 3 still uses a mean and how Query 5 follows the author’s linked genre.
4. [Snapshot files](../data) contain the records and PostgreSQL query outputs displayed in the dashboard.

The original team contributed the schema, records, and analytical questions. The modernization reconstructed and checked the database, documented the SQL, and built the Streamlit interface. Cloud deployment uses the same bundled snapshot as local development.
