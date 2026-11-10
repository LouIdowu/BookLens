"""BookLens | PostgreSQL Book Discovery & Analytics."""
import re

import pandas as pd
import plotly.express as px
import streamlit as st

from booklens.data import ROOT, SORTS, filter_books, genre_counts, load_catalog, provenance, query_results
from booklens.theme import CATEGORICAL, CSS, SEQUENTIAL, ranked_bar, style

st.set_page_config(page_title="BookLens | PostgreSQL Book Discovery & Analytics", page_icon="📚", layout="wide")

QUERIES = [
    ("Books rated above the catalog average", "Which titles exceed the unweighted mean rating?",
     "INNER JOIN · AVG · scalar subquery", "Each row shows a qualifying title and its linked author."),
    ("Books by authors born before 1970", "Which titles are linked to authors born before January 1, 1970?",
     "INNER JOIN · DATE literal · WHERE", "The date filter applies to the linked author record."),
    ("Authors with an above-average rating count", "Which authors have at least one book with more ratings than the catalog mean?",
     "Correlated EXISTS · AVG · nested subquery", "Each qualifying author appears once. The threshold is a mean over book rating counts."),
    ("Books longer than the catalog average", "Which titles have more pages than the catalog mean?",
     "AVG · scalar subquery · WHERE", "This query uses only the books table and sorts the longest titles first."),
    ("Books by authors linked to an A genre", "Which titles have authors whose linked genre starts with uppercase A?",
     "Three-table join · LIKE · foreign keys", "The predicate applies to genres.genre_name. The output includes the author’s recorded specialty."),
]
LABELS = {
    "book_title": "Title", "author": "Author", "book_genre": "Book genre",
    "book_rating": "Rating", "book_pages": "Pages", "book_rating_count": "Ratings", "book_format": "Format",
}


@st.cache_data
def snapshot():
    return load_catalog()


def section(number, title, description):
    st.markdown(f'<div class="bl-page">{number} / BOOKLENS</div>', unsafe_allow_html=True)
    st.title(title)
    st.caption(description)


def chart(fig):
    st.plotly_chart(fig, width="stretch", theme=None, config={"displayModeBar": False})


def overview(catalog, authors, genres):
    st.markdown(
        """<div class="bl-hero">
        <div class="bl-kicker">THE FICTION COLLECTION / 2023 SNAPSHOT</div>
        <h1>Explore fiction<br>through data.</h1>
        <p>BookLens brings a historic PostgreSQL library to life. Browse the catalog,
        compare ratings and reading lengths, and trace each SQL result back to its source tables.</p>
        <span class="bl-badge">BOOKLENS · POSTGRESQL &amp; STREAMLIT</span>
        </div>""", unsafe_allow_html=True,
    )
    metrics = [
        ("Books", str(len(catalog))), ("Authors", str(len(authors))), ("Genres in lookup", str(len(genres))),
        ("Mean rating", f"{catalog.book_rating.mean():.2f} / 5"),
        ("Mean length", f"{catalog.book_pages.mean():.0f} pages"),
        ("Recorded ratings", f"{catalog.book_rating_count.sum():,}"),
    ]
    for start in (0, 3):
        for col, (name, value) in zip(st.columns(3), metrics[start:start + 3]):
            col.metric(name, value, border=True)
    st.divider()
    left, right = st.columns([1.08, 1], gap="large")
    with left:
        st.subheader("The highest-rated titles")
        st.caption("Eight titles ranked by archived average rating.")
        top = filter_books(catalog).head(8)
        chart(ranked_bar(top, "book_rating", "book_title", "Average rating out of 5"))
    with right:
        st.subheader("Genres on the shelf")
        st.caption("Counts use each book’s original genre text.")
        by_genre = genre_counts(catalog)
        chart(ranked_bar(by_genre, "size", "book_genre", "Books", 385))
    st.caption("Ratings and counts reflect the historical snapshot. Mean rating weights each book equally.")


def explorer(catalog):
    section("02", "Book Explorer", "Search the original catalog and open a title to inspect its archived metadata.")
    title = st.text_input("Search title", placeholder="Try Pride and Prejudice")
    left, right = st.columns(2)
    authors = left.multiselect("Authors", sorted(catalog.author.unique()))
    genres = right.multiselect("Book genres", sorted(catalog.book_genre.unique()))
    low, high = left.slider("Rating range", 0.0, 5.0, (0.0, 5.0), 0.01)
    sort = right.selectbox("Sort by", list(SORTS))
    results = filter_books(catalog, title, authors, genres, None if (low, high) == (0, 5) else (low, high), sort)
    st.caption(f"{len(results)} of {len(catalog)} books")
    if results.empty:
        st.info("No titles match these filters. Try a shorter search or broaden the filters.")
        return
    st.dataframe(results[list(LABELS)].rename(columns=LABELS), hide_index=True, width="stretch")
    lookup = results.set_index("book_id")
    book_id = st.selectbox("Open a book", list(lookup.index), format_func=lambda key: lookup.loc[key, "book_title"])
    row = lookup.loc[book_id]
    with st.container(border=True):
        st.subheader(row.book_title)
        st.write(f"{row.author} · {row.book_genre}")
        columns = st.columns(3)
        for col, name, key, fmt in zip(columns, ("Rating", "Pages", "Ratings"),
                                       ("book_rating", "book_pages", "book_rating_count"), (".2f", ",.0f", ",.0f")):
            value = row[key]
            col.metric(name, format(value, fmt) if pd.notna(value) else "Unavailable")
        st.caption(f"Format · {row.book_format if pd.notna(row.book_format) else 'Unavailable'}")


def analytics(catalog):
    section("03", "Literary Analytics", "Compare archived ratings, page counts and audience activity within the collection.")
    genres = st.multiselect("Focus on book genres", sorted(catalog.book_genre.unique()))
    selected = filter_books(catalog, genres=genres)
    st.caption(f"Showing {len(selected)} of {len(catalog)} titles.")
    st.subheader("Length and rating")
    st.caption("Each point is a book. Color groups the archived rating counts into three fixed bands.")
    points = selected.dropna(subset=["book_pages", "book_rating", "book_rating_count"]).copy()
    if points.empty:
        st.info("No titles in this selection have the three measurements needed for this chart.")
    else:
        points["Audience"] = pd.cut(points.book_rating_count, [-1, 499999, 1999999, float("inf")],
                                    labels=["Under 500k", "500k to under 2M", "2M or more"])
        fig = px.scatter(
            points, x="book_pages", y="book_rating", color="Audience", hover_name="book_title",
            hover_data={"author": True, "book_rating_count": ":,"}, labels=LABELS,
            color_discrete_map=dict(zip(["Under 500k", "500k to under 2M", "2M or more"],
                                        [CATEGORICAL[1], CATEGORICAL[3], CATEGORICAL[5]])),
        )
        fig.update_traces(marker={"size": 11, "line": {"width": 1, "color": SEQUENTIAL[0]}})
        chart(style(fig))
    left, right = st.columns(2, gap="large")
    with left:
        st.subheader("Rating distribution")
        chart(style(px.histogram(selected, x="book_rating", nbins=9, labels=LABELS,
                                 color_discrete_sequence=[SEQUENTIAL[2]])))
    with right:
        st.subheader("Most recorded ratings")
        top = selected.dropna(subset=["book_rating_count"]).nlargest(6, "book_rating_count").copy()
        top["Title · author"] = top.book_title + " · " + top.author
        chart(ranked_bar(top, "book_rating_count", "Title · author", "Recorded ratings"))
    st.caption("The counts measure activity recorded for a title. They do not measure unique readers across the collection.")
    st.subheader("Author and genre links")
    st.dataframe(selected[["book_title", "author", "book_genre", "genre_name"]].rename(
        columns=LABELS | {"genre_name": "Author’s linked genre"}), width="stretch", hide_index=True)


def sql_explorer():
    section("04", "SQL Query Explorer", "Five preserved analytical questions with verified PostgreSQL outputs.")
    number = st.selectbox("Choose an analysis", range(1, 6), format_func=lambda n: f"0{n} · {QUERIES[n - 1][0]}")
    title, purpose, techniques, interpretation = QUERIES[number - 1]
    sql = re.split(r"^-- Query \d+\s*", (ROOT / "sql/queries.sql").read_text(encoding="utf-8"), flags=re.M)
    results = query_results(number)
    st.subheader(title)
    st.write(purpose)
    st.caption(techniques)
    code, output = st.tabs(["SQL", f"Results · {len(results)} rows"])
    with code:
        st.code(sql[number].strip(), language="sql")
    with output:
        st.write(interpretation)
        st.dataframe(results, hide_index=True, width="stretch")
    st.caption("BookLens reads bundled result files. " + provenance()["verification"])


def architecture():
    section("05", "Database Architecture", "Three public-schema tables and two foreign keys preserved from the original archive.")
    st.graphviz_chart("""
    digraph library {
      graph [rankdir=LR, bgcolor=transparent, nodesep=0.3, ranksep=0.65];
      node [shape=box, style="rounded,filled", fillcolor="#182337", color="#86C0DB", fontcolor="#F0F4FA", fontname="Arial", margin="0.18,0.12"];
      edge [color="#86C0DB", fontcolor="#AFD5E8", fontname="Arial"];
      books [label="BOOKS\nPK book_id\nFK author_id"];
      authors [label="AUTHORS\nPK author_id\nFK genre_id"];
      genres [label="GENRES\nPK genre_id"];
      books -> authors [label=" author_id "];
      authors -> genres [label=" genre_id "];
    }""")
    st.write("A book can link to one author and an author can link to one genre. Each parent can have multiple child rows. Both foreign keys allow nulls.")
    with st.expander("Columns, types and constraints", expanded=True):
        st.code((ROOT / "sql/schema.sql").read_text(encoding="utf-8"), language="sql")
    st.subheader("From database to dashboard")
    st.markdown("PostgreSQL TAR archive → isolated reconstruction → validated CSV tables and query results → Streamlit")
    st.write("The archive also keeps book genre and author specialty as text. A book’s genre filter uses its text label. The relational join follows the author’s genre key. The catalog uses the author key for its display name.")
    st.caption("The foreign keys constrain references. Ratings, pages and counts are nullable and carry no range constraints in the historical schema.")


def about():
    section("06", "About and Methodology", "BookLens is a modernization of a collaborative 2023 PostgreSQL fiction-library project.")
    st.subheader("Source and scope")
    st.write("The original University of Maryland project assembled a small fiction collection with Goodreads-related metadata. The archived database contains 29 books, 29 authors and 15 genre lookup rows. The figures describe this selection of titles.")
    st.subheader("How the analysis works")
    st.write("The original PostgreSQL schema and records feed a reproducible snapshot. Streamlit and pandas handle browsing and calculations. Plotly provides interactive charts. SQL examples are predefined and their results are bundled with the app.")
    st.subheader("Limitations and future work")
    st.write("Ratings, counts, dates and genres are historical source values. Edition and capture-date coverage are limited. A future version could track snapshot dates, reconcile editions and model multiple authors and genres with junction tables.")


def main():
    st.markdown(CSS, unsafe_allow_html=True)
    with st.sidebar:
        st.markdown("## BookLens")
        st.caption("POSTGRESQL BOOK DISCOVERY")
        page = st.radio("Navigate", ["Overview", "Book Explorer", "Literary Analytics", "SQL Query Explorer",
                                     "Database Architecture", "About / Methodology"], label_visibility="collapsed")
        st.divider()
        st.caption("2023 fiction collection · Historical snapshot")
    catalog, authors, genres = snapshot()
    pages = {
        "Overview": lambda: overview(catalog, authors, genres),
        "Book Explorer": lambda: explorer(catalog),
        "Literary Analytics": lambda: analytics(catalog),
        "SQL Query Explorer": sql_explorer,
        "Database Architecture": architecture,
        "About / Methodology": about,
    }
    pages[page]()


if __name__ == "__main__":
    main()
