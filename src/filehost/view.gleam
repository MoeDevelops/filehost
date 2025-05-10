import gleam/string_tree.{type StringTree}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn view() -> StringTree {
  inner()
  |> base()
  |> element.to_document_string_tree()
}

fn base(body: Element(a)) -> Element(a) {
  html.html([], [html.head([], []), html.body([], [body])])
}

fn inner() -> Element(a) {
  html.div([], [
    html.h1([], [html.text("Filehost")]),
    html.form(
      [attribute.method("POST"), attribute.enctype("multipart/form-data")],
      [
        html.input([attribute.type_("file"), attribute.name("upload")]),
        html.input([attribute.type_("submit"), attribute.value("Submit")]),
      ],
    ),
  ])
}
