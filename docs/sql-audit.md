# SQL audit

The five SELECT statements in the source query text were executed in embedded PostgreSQL 17.5 against the original schema and 73 archive records. All parsed and ran as supplied. The reported alias typo does not appear in the supplied queries. The revised versions keep the original output columns and predicates, standardize aliases and formatting, and add deterministic sort keys. All five original and revised result sets matched. The shipped CSVs capture the PostgreSQL results.

| Query | Original intent and correction | Result | Example |
| --- | --- | ---: | --- |
| 1 | Join books and authors and retain books rated above the catalog mean. Added rating and book ID ordering. | 17 | Tolkien’s boxed set, 4.59 |
| 2 | Join books and authors born before 1970. Made the cutoff an explicit PostgreSQL `DATE` literal and added stable ordering. | 23 | Jane Austen, *Pride and Prejudice*, 4.25 |
| 3 | The original prose said median while SQL used `AVG`. The revised description uses mean to preserve the analytical threshold and the original row set. `EXISTS` returns one row per qualifying author. | 11 | Suzanne Collins |
| 4 | Find titles above the mean page count. Added page-count and book ID ordering. | 9 | Long books are listed first |
| 5 | The original prose said “others.” The query joins books to authors to genres and checks whether the linked genre name begins with uppercase A. The specialty column remains a separate projected value. | 1 | William Golding, Allegorical, *Lord of the Flies* |

Query 1 uses an unweighted mean rating of about 4.137. Query 3 compares each book’s rating count with the mean of about 1.69 million. Query 4 compares page counts with a mean of about 496 pages. A missing value would fail a strict greater-than predicate and is excluded from the corresponding mean.

## Requirements matrix

The historical *Report Requirements* document defines the columns below. Query 3 references both tables through a correlated subquery. Query 4 reads the same table twice and counts as a single-table query.

| Query | A Multiple tables | B Filtering | C Aggregation | D Subquery |
| --- | --- | --- | --- | --- |
| 1 | Yes | Yes | Yes | Yes |
| 2 | Yes | Yes |  |  |
| 3 | Yes | Yes | Yes | Yes |
| 4 |  | Yes | Yes | Yes |
| 5 | Yes | Yes |  |  |
| **Total** | **4** | **5** | **3** | **3** |
| Required | 4 | 3 | 2 | 1 |

The five queries address distinct questions and use explicit projections. The historical SQL file is archived with the original project materials.
