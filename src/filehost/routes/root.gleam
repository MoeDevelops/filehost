import gleam/http
import lustre/attribute
import lustre/element
import lustre/element/html
import wisp.{type Request, type Response}

pub fn handle_request(request: Request) -> Response {
  case request.method {
    http.Get -> get(request)
    _ -> wisp.method_not_allowed([http.Get])
  }
}

fn get(_request: Request) {
  let body =
    view()
    |> base()
    |> element.to_document_string_tree()

  wisp.ok()
  |> wisp.string_tree_body(body)
}

fn base(body: element.Element(a)) {
  html.html([], [html.head([], []), html.body([], [body])])
}

fn view() {
  html.div([], [
    html.h1([], [html.text("Filehost")]),
    html.form(
      [
        attribute.action("/file"),
        attribute.method("POST"),
        attribute.enctype("multipart/form-data"),
      ],
      [
        html.input([attribute.type_("file"), attribute.name("upload")]),
        html.input([attribute.type_("submit"), attribute.value("Submit")]),
      ],
    ),
  ])
}
