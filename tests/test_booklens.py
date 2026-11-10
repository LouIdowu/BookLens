import unittest

from streamlit.testing.v1 import AppTest

from booklens.data import ROOT, filter_books, genre_counts, load_catalog, query_results


class DataTests(unittest.TestCase):
    def setUp(self):
        self.books, self.authors, self.genres = load_catalog()

    def test_snapshot_and_relationships(self):
        self.assertEqual((len(self.books), len(self.authors), len(self.genres)), (29, 29, 15))
        self.assertTrue(self.books.book_id.is_unique)
        self.assertTrue(self.books.author_id.isin(self.authors.author_id).all())
        self.assertTrue(self.authors.genre_id.isin(self.genres.genre_id).all())
        self.assertEqual(self.books.book_rating_count.sum(), 49078981)
        self.assertAlmostEqual(self.books.book_rating.mean(), 4.1372413793)
        self.assertEqual(genre_counts(self.books).iloc[0].tolist(), ["Historical Fiction", 5])
        self.assertEqual(genre_counts(self.books)["size"].sum(), 29)

    def test_filters_and_sorting(self):
        result = filter_books(self.books, "  PRIDE ", ["Jane Austen"], ["Romance"], (4, 5))
        self.assertEqual(result.book_title.tolist(), ["Pride and Prejudice"])
        self.assertTrue(filter_books(self.books, "[").empty)
        self.assertTrue(filter_books(self.books, ratings=(0, 1)).empty)
        self.assertTrue(filter_books(self.books, sort="Most ratings").book_rating_count.is_monotonic_decreasing)
        self.assertTrue(filter_books(self.books, sort="Title A–Z").book_title.is_monotonic_increasing)

    def test_missing_title_and_rating(self):
        changed = self.books.copy()
        changed.loc[changed.index[0], ["book_title", "book_rating"]] = None
        self.assertEqual(len(filter_books(changed)), 29)
        self.assertEqual(len(filter_books(changed, ratings=(0, 5))), 28)

    def test_query_results(self):
        self.assertEqual([len(query_results(n)) for n in range(1, 6)], [17, 23, 11, 9, 1])


class AppTests(unittest.TestCase):
    def test_all_pages_and_interactions(self):
        app = AppTest.from_file(str(ROOT / "streamlit_app.py"), default_timeout=30).run()
        self.assertFalse(app.exception)
        self.assertEqual(len(app.metric), 6)
        self.assertEqual(len(app.get("plotly_chart")), 2)
        for page in app.sidebar.radio[0].options[1:]:
            app.sidebar.radio[0].set_value(page).run()
            self.assertFalse(app.exception, page)
            if page == "Book Explorer":
                app.text_input[0].set_value("Pride").run()
                self.assertEqual(app.dataframe[0].value["Title"].tolist(), ["Pride and Prejudice"])
                app.text_input[0].set_value("No matching title here").run()
                self.assertTrue(app.info)
            if page == "Literary Analytics":
                app.multiselect[0].set_value(["Romance"]).run()
                self.assertEqual(len(app.get("plotly_chart")), 3)
                self.assertEqual(len(app.dataframe[0].value), 1)
            if page == "SQL Query Explorer":
                for n in range(1, 6):
                    app.selectbox[0].set_value(n).run()
                    self.assertFalse(app.exception)
                    self.assertEqual(len(app.dataframe[0].value), len(query_results(n)))
