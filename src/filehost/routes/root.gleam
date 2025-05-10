import filehost/view
import filepath
import gleam/http
import gleam/result
import gleam/string
import simplifile
import wisp.{type Request, type Response, UploadedFile}
import youid/uuid

pub fn handle_request(request: Request) -> Response {
  case request.method {
    http.Get -> get()
    http.Post -> post(request)
    _ -> wisp.method_not_allowed([http.Get])
  }
}

fn post(request: Request) {
  use form_data <- wisp.require_form(request)

  let id = uuid.v7_string()

  case form_data.files {
    [#("upload", UploadedFile(name, path))] -> {
      let ext =
        filepath.extension(name)
        |> result.unwrap("")
        |> string.lowercase()

      let id = id <> "." <> ext
      let assert Ok(_) = simplifile.copy(path, "data/" <> id)
      wisp.redirect("/" <> id)
    }
    _ -> wisp.unprocessable_entity()
  }
}

fn get() {
  wisp.ok()
  |> wisp.string_tree_body(view.view())
}
