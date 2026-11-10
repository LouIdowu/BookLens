-- Query 1
SELECT a.name AS "Author Name", b.book_title AS "Book Title", b.book_rating AS "Book Rating"
FROM public.books AS b
JOIN public.authors AS a ON b.author_id = a.author_id
WHERE b.book_rating > (SELECT AVG(book_rating) FROM public.books)
ORDER BY b.book_rating DESC, b.book_id;

-- Query 2
SELECT a.name AS "Author Name", b.book_title AS "Book Title", b.book_rating AS "Book Rating"
FROM public.books AS b
JOIN public.authors AS a ON b.author_id = a.author_id
WHERE a.birth_date < DATE '1970-01-01'
ORDER BY a.birth_date, b.book_id;

-- Query 3
SELECT a.name AS "Author Name"
FROM public.authors AS a
WHERE EXISTS (
    SELECT 1
    FROM public.books AS b
    WHERE b.author_id = a.author_id
      AND b.book_rating_count > (SELECT AVG(book_rating_count) FROM public.books)
)
ORDER BY a.author_id;

-- Query 4
SELECT b.book_title AS "Book Title", b.book_pages AS "Number of Pages"
FROM public.books AS b
WHERE b.book_pages > (SELECT AVG(book_pages) FROM public.books)
ORDER BY b.book_pages DESC, b.book_id;

-- Query 5
SELECT a.name AS "Author Name", a.genre_speciality AS "Genre Speciality", b.book_title AS "Book Title"
FROM public.authors AS a
JOIN public.books AS b ON a.author_id = b.author_id
JOIN public.genres AS g ON a.genre_id = g.genre_id
WHERE g.genre_name LIKE 'A%'
ORDER BY g.genre_name, a.author_id, b.book_id;
