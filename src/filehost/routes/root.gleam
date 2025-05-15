import filepath
import gleam/bit_array
import gleam/crypto
import gleam/http
import gleam/result
import gleam/string
import gleam/string_tree
import simplifile
import wisp.{type Request, type Response, UploadedFile}

pub fn handle_request(request: Request) -> Response {
  case request.method {
    http.Get -> get()
    http.Post -> post(request)
    _ -> wisp.method_not_allowed([http.Get])
  }
}

fn post(request: Request) {
  use form_data <- wisp.require_form(request)

  case form_data.files {
    [#("upload", UploadedFile(name, path))] -> {
      let ext =
        filepath.extension(name)
        |> result.unwrap("")
        |> string.lowercase()

      let assert Ok(data) = simplifile.read_bits(path)

      let hash =
        crypto.hash(crypto.Sha256, data)
        |> bit_array.base64_encode(False)
        |> string.replace("/", "-")

      let id = hash <> "." <> ext

      let assert Ok(dir) = simplifile.current_directory()

      let destination =
        dir
        |> filepath.join("data")
        |> filepath.join(id)

      echo destination
      let assert Ok(_) = simplifile.copy(path, destination)

      wisp.redirect("/" <> id)
    }
    _ -> wisp.unprocessable_entity()
  }
}

fn get() {
  {
    use dir <- result.try(wisp.priv_directory("filehost"))
    use data <- result.try(
      filepath.join(dir, "index.html")
      |> simplifile.read()
      |> result.replace_error(Nil),
    )
    Ok(wisp.html_response(string_tree.from_string(data), 200))
  }
  |> result.replace_error(wisp.internal_server_error())
  |> result.unwrap_both()
}
