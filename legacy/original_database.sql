-- BookLens historical database, reconstructed from the PostgreSQL 15.1 TAR archive.
-- Apply to a fresh empty database. The archive's database and ownership commands are omitted.
-- Original rows and sequence positions are included.

BEGIN;
SET LOCAL standard_conforming_strings = on;

-- Original table definitions, defaults, and constraints
CREATE TABLE public.authors (
    author_id integer NOT NULL,
    name character varying(255) NOT NULL,
    birth_date date,
    genre_speciality character varying(255),
    genre_id integer
);

CREATE SEQUENCE public.authors_author_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.authors_author_id_seq OWNED BY public.authors.author_id;

CREATE TABLE public.books (
    book_id integer NOT NULL,
    book_authors character varying(255),
    book_format character varying(255),
    book_pages integer,
    book_rating double precision,
    book_rating_count integer,
    book_review_count integer,
    book_title character varying(255),
    genres character varying(255),
    author_id integer
);

CREATE SEQUENCE public.books_temp_book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.books_temp_book_id_seq OWNED BY public.books.book_id;

CREATE TABLE public.genres (
    genre_id integer NOT NULL,
    genre_name character varying(255) NOT NULL,
    genre_description character varying(255)
);

CREATE SEQUENCE public.genres_genre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.genres_genre_id_seq OWNED BY public.genres.genre_id;

ALTER TABLE ONLY public.authors ALTER COLUMN author_id SET DEFAULT nextval('public.authors_author_id_seq'::regclass);

ALTER TABLE ONLY public.books ALTER COLUMN book_id SET DEFAULT nextval('public.books_temp_book_id_seq'::regclass);

ALTER TABLE ONLY public.genres ALTER COLUMN genre_id SET DEFAULT nextval('public.genres_genre_id_seq'::regclass);

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_name_key UNIQUE (name);

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (author_id);

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_temp_pkey PRIMARY KEY (book_id);

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (genre_id);

ALTER TABLE ONLY public.books
    ADD CONSTRAINT fk_author FOREIGN KEY (author_id) REFERENCES public.authors(author_id);

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT fk_authors_genre_id FOREIGN KEY (genre_id) REFERENCES public.genres(genre_id);

-- Historical records, loaded in foreign-key order
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (1, 'Dystopian', 'A genre set in a future where society is oppressive or chaotic.');
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (2, 'Fantasy', 'A genre with magical or make-believe elements in a fictional world.');
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (3, 'Southern Gothic', 'A genre that explores creepy and decaying aspects of the American South.');
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (4, 'Romance', 'A genre focused on love stories and relationships between characters.');
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (5, 'Young Adult', 'A genre for teenagers that often explores themes of growing up and self-discovery.');
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (6, 'Historical Fiction', 'A genre set in the past, featuring fictional stories based on real events.');
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (7, 'Science Fiction', 'A genre that deals with imaginative and futuristic ideas and technology.');
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (8, 'Children Literature', 'A genre aimed at young kids with age-appropriate stories and characters.');
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (9, 'Thriller', 'A genre that creates excitement and suspense, keeping readers on the edge of their seats.');
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (10, 'Gothic Fiction', 'A genre with dark and mysterious elements, often featuring haunted settings.');
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (11, 'Drama', 'A genre focusing on emotional development and conflicts between characters.');
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (12, 'Allegorical', 'A genre that uses symbolic stories to convey deeper meanings and moral lessons.');
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (13, 'Philosophical', 'A genre exploring big questions about life, existence, and human nature.');
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (14, 'Urban Fantasy', 'A genre blending fantasy elements with modern urban settings.');
INSERT INTO public.genres (genre_id, genre_name, genre_description) VALUES (15, 'Mystery', 'A genre focused on solving puzzles and uncovering secrets or crimes.');
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (1, 'Suzanne Collins', '1962-08-10', 'Dystopian', 1);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (2, 'J.K. Rowling', '1965-07-31', 'Fantasy', 2);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (3, 'Harper Lee', '1926-04-28', 'Southern Gothic', 3);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (4, 'Jane Austen', '1775-12-16', 'Romance', 4);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (5, 'Stephenie Meyer', '1973-12-24', 'Young Adult', 5);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (6, 'Markus Zusak', '1975-06-23', 'Historical Fiction', 6);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (7, 'C.S. Lewis', '1898-11-29', 'Fantasy', 2);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (8, 'George Orwell', '1903-06-25', 'Dystopian', 1);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (9, 'Margaret Mitchell', '1900-11-08', 'Historical Fiction', 6);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (10, 'J.R.R. Tolkien', '1892-01-03', 'Fantasy', 2);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (11, 'John Green', '1977-08-24', 'Young Adult', 5);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (12, 'Douglas Adams', '1952-03-11', 'Science Fiction', 7);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (13, 'Shel Silverstein', '1930-09-25', 'Children Literature', 8);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (14, 'Dan Brown', '1964-06-22', 'Thriller', 9);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (15, 'Emily Bront', '1818-07-30', 'Gothic Fiction', 10);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (16, 'Arthur Golden', '1956-12-06', 'Historical Fiction', 6);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (17, 'Lewis Carroll', '1832-01-27', 'Fantasy', 2);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (18, 'Oscar Wilde', '1854-10-16', 'Drama', 11);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (19, 'Victor Hugo', '1802-02-26', 'Historical Fiction', 6);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (20, 'Veronica Roth', '1988-08-19', 'Dystopian', 1);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (21, 'Charlotte Bront', '1816-04-21', 'Gothic Fiction', 10);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (22, 'William Shakespeare', '1564-04-23', 'Drama', 11);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (23, 'William Golding', '1911-09-19', 'Allegorical', 12);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (24, 'Paulo Coelho', '1947-08-24', 'Philosophical', 13);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (25, 'Fyodor Dostoyevsky', '1821-11-11', 'Philosophical', 13);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (26, 'Orson Scott Card', '1951-08-24', 'Science Fiction', 7);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (27, 'Stephen Chbosky', '1970-01-25', 'Young Adult', 5);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (28, 'Cassandra Clare', '1973-07-27', 'Urban Fantasy', 14);
INSERT INTO public.authors (author_id, name, birth_date, genre_speciality, genre_id) VALUES (29, 'Kathryn Stockett', '1969-02-19', 'Historical Fiction', 6);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (1, 'Suzanne Collins', 'Hardcover', 374, 4.33, 5519135, 160706, 'The Hunger Games', 'Dystopian', 1);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (2, 'J.K. Rowling', 'Paperback', 870, 4.48, 2041594, 33264, 'Harry Potter and the Order of the Phoenix', 'Fantasy', 2);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (3, 'Harper Lee', 'Paperback', 324, 4.27, 3745197, 79450, 'To Kill a Mockingbird', 'Southern Gothic', 3);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (4, 'Jane Austen', 'Paperback', 279, 4.25, 2453620, 54322, 'Pride and Prejudice', 'Romance', 4);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (5, 'Stephenie Meyer', 'Paperback', 498, 3.58, 4281268, 97991, 'Twilight', 'Young Adult', 5);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (6, 'Markus Zusak', 'Hardcover', 552, 4.36, 1485632, 100821, 'The Book Thief', 'Historical Fiction', 6);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (7, 'C.S. Lewis', 'Paperback', 767, 4.25, 437829, 9439, 'The Chronicles of Narnia', 'Fantasy', 7);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (8, 'George Orwell', 'Paperback', 122, 3.9, 2235084, 42156, 'Animal Farm', 'Dystopian', 8);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (9, 'Margaret Mitchell', 'Paperback', 1037, 4.29, 969181, 17452, 'Gone with the Wind', 'Historical Fiction', 9);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (10, 'J.R.R. Tolkien', 'Mass Market Paperback', 1728, 4.59, 99793, 1652, 'J.R.R. Tolkien 4-Book Boxed Set: The Hobbit and The Lord of the Rings', 'Fantasy', 10);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (11, 'John Green', 'Hardcover', 313, 4.24, 2881648, 147270, 'The Fault in Our Stars', 'Young Adult', 11);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (12, 'Douglas Adams', 'Paperback', 193, 4.21, 1155911, 23919, 'The Hitchhiker''s Guide to the Galaxy', 'Science Fiction', 12);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (13, 'Shel Silverstein', 'Hardcover', 64, 4.37, 789681, 15694, 'The Giving Tree', 'Children Literature', 13);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (14, 'Dan Brown', 'Paperback', 481, 3.81, 1668594, 43699, 'The Da Vinci Code', 'Thriller', 14);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (15, 'Emily Bront', 'Paperback', 464, 3.84, 1121100, 29400, 'Wuthering Heights', 'Gothic Fiction', 15);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (16, 'Arthur Golden', 'Hardcover', 434, 4.09, 1525851, 27168, 'Memoirs of a Geisha', 'Historical Fiction', 16);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (17, 'Lewis Carroll', 'Mass Market Paperback', 239, 4.07, 411153, 9166, 'Alice''s Adventures in Wonderland & Through the Looking-Glass', 'Fantasy', 17);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (18, 'Oscar Wilde', 'Paperback', 367, 4.06, 775701, 22938, 'The Picture of Dorian Gray', 'Drama', 18);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (19, 'Victor Hugo', 'Mass Market Paperback', 1463, 4.15, 591874, 13063, 'Les Misrables', 'Historical Fiction', 19);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (20, 'Veronica Roth', 'Paperback', 487, 4.22, 2493519, 104329, 'Divergent', 'Dystopian', 20);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (21, 'Charlotte Bront', 'Paperback', 507, 4.11, 1381404, 34670, 'Jane Eyre', 'Gothic Fiction', 21);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (22, 'William Shakespeare', 'Mass Market Paperback', 283, 3.74, 1818262, 16442, 'Romeo and Juliet', 'Drama', 22);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (23, 'William Golding', 'Paperback', 182, 3.66, 1840595, 30634, 'Lord of the Flies', 'Allegorical', 23);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (24, 'Paulo Coelho', 'Paperback', 197, 3.84, 1644387, 63861, 'The Alchemist', 'Philosophical', 24);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (25, 'Fyodor Dostoyevsky', 'Paperback', 671, 4.2, 507522, 14496, 'Crime and Punishment', 'Philosophical', 25);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (26, 'Orson Scott Card', 'Mass Market Paperback', 324, 4.3, 965351, 40289, 'Ender''s Game', 'Science Fiction', 26);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (27, 'Stephen Chbosky', 'Paperback', 213, 4.2, 1063711, 50846, 'The Perks of Being a Wallflower', 'Young Adult', 27);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (28, 'Cassandra Clare', 'Hardcover', 485, 4.11, 1383479, 55446, 'City of Bones', 'Urban Fantasy', 28);
INSERT INTO public.books (book_id, book_authors, book_format, book_pages, book_rating, book_rating_count, book_review_count, book_title, genres, author_id) VALUES (29, 'Kathryn Stockett', 'Hardcover', 465, 4.46, 1790905, 80741, 'The Help', 'Historical Fiction', 29);
SELECT pg_catalog.setval('public.authors_author_id_seq', 29, true);
SELECT pg_catalog.setval('public.books_temp_book_id_seq', 29, true);
SELECT pg_catalog.setval('public.genres_genre_id_seq', 15, true);

COMMIT;
