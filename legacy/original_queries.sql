-- Original SELECT statements from the 2023 team project.

-- Query 1
select
    a.name AS "Author Name",
    b.book_title AS "Book Title",
    b.book_rating AS "Book Rating"
from
    public.books b
JOIN
    public.authors a ON b.author_id = a.author_id
where
    b.book_rating > (
        select
            AVG(book_rating)
        from
            public.books
    );

-- Query 2
select
    a.name AS "Author Name",
    b.book_title AS "Book Title",
    b.book_rating AS "Book Rating"
from
    public.books b
JOIN
    public.authors a ON b.author_id = a.author_id
where
    a.birth_date < '1970-01-01';

-- Query 3
select
    a.name AS "Author Name"
from
    public.authors a
where
    exists (
        select 1
        from
            public.books b
        where
            b.author_id = a.author_id AND
            b.book_rating_count > (
                select
                    AVG(book_rating_count)
                from
                    public.books
            )
    );

-- Query 4
select
    b.book_title AS "Book Title",
    b.book_pages AS "Number of Pages"
from
    public.books b
where
    b.book_pages > (
        select
            AVG(book_pages)
        from
            public.books
    );

-- Query 5
select
    a.name AS "Author Name",
    a.genre_speciality AS "Genre Speciality",
    b.book_title AS "Book Title"
from
    public.authors a
JOIN
    public.books b ON a.author_id = b.author_id
JOIN
    public.genres g ON a.genre_id = g.genre_id
where
    g.genre_name LIKE 'A%';
