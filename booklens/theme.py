"""Color and typography shared by every BookLens visualization."""
import plotly.express as px

SEQUENTIAL = ["#AFD5E8", "#86C0DB", "#49A1C9", "#65B8BB", "#23757F", "#365694", "#3B199B"]
CATEGORICAL = ["#004442", "#008A83", "#57C6C9", "#2198CD", "#2365A1", "#3104B0"]
TEXT = "#F0F4FA"
MUTED = "#B9C9DF"

CSS = """
<style>
.bl-hero {
  background: radial-gradient(ellipse at top right, #263366, transparent 62%),
              linear-gradient(118deg, #152237, #142d3f);
  border: 1px solid #395676;
  border-radius: 22px;
  padding: clamp(1.6rem, 5vw, 4rem);
  margin: .35rem 0 1.55rem;
}
.bl-kicker { color: #AFD5E8; font: 700 .76rem system-ui; letter-spacing: .19em; }
.bl-hero h1 { font: 600 clamp(2.5rem, 7vw, 5.8rem)/1.03 Georgia, serif;
  margin: .45rem 0 .6rem; padding: 0; color: #F0F4FA; }
.bl-hero p { max-width: 39rem; color: #C5D5E8; margin: .6rem 0 0; }
.bl-badge { display: inline-block; border: 1px solid #55749B; color: #AFD5E8;
  padding: .35rem .75rem; border-radius: 30px; font-size: .8rem; margin-top: 1rem; }
.bl-page { color: #AFD5E8; font: 700 .76rem system-ui; letter-spacing: .18em; margin-top: 1rem; }
</style>
"""


def style(fig, height=365):
    fig.update_layout(
        height=height, paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        font={"color": MUTED, "family": "system-ui"}, margin={"l": 8, "r": 18, "t": 14, "b": 24},
        legend_title_text="", coloraxis_showscale=False,
    )
    fig.update_xaxes(gridcolor="#29364C", zeroline=False, automargin=True)
    fig.update_yaxes(gridcolor="#29364C", zeroline=False, automargin=True)
    return fig


def ranked_bar(data, x, y, x_label, height=350):
    fig = px.bar(data, x=x, y=y, orientation="h", color=x,
                 color_continuous_scale=SEQUENTIAL[::-1], labels={x: x_label, y: ""})
    fig.update_yaxes(autorange="reversed")
    fig.update_traces(marker_line_color=SEQUENTIAL[0], marker_line_width=0.6)
    return style(fig, height)
