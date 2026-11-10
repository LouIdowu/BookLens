-- Physical schema from the PostgreSQL 15.1 archive. Apply only in an empty database.

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
