import filehost/filetype
import filepath
import gleam/bool
import gleam/http
import gleam/list
import gleam/result
import gleam/string
import simplifile
import wisp.{type Request, type Response, UploadedFile}
import youid/uuid

pub fn handle_request(request: Request) -> Response {
  case request.method {
    http.Get -> get(request)
    http.Post -> post(request)
    _ -> wisp.method_not_allowed([http.Get, http.Post])
  }
}

fn get(request: Request) {
  let params = wisp.get_query(request)
  {
    use id <- result.try(
      list.key_find(params, "id")
      |> result.replace_error(wisp.unprocessable_entity()),
    )

    use <- bool.guard(
      simplifile.is_file("data/" <> id) != Ok(True),
      Error(wisp.not_found()),
    )

    Ok(
      wisp.ok()
      |> wisp.set_header("Content-Type", filetype.get_content_type(id))
      |> wisp.set_body(wisp.File("data/" <> id)),
    )
  }
  |> result.unwrap_both()
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
      wisp.redirect("/file?id=" <> id)
    }
    _ -> wisp.unprocessable_entity()
  }
}
