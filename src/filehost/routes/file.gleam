import filehost/filetype
import gleam/bool
import gleam/http
import simplifile
import wisp.{type Request, type Response}

pub fn handle_request(request: Request, id: String) -> Response {
  case request.method {
    http.Get -> get(id)
    _ -> wisp.method_not_allowed([http.Get, http.Post])
  }
}

fn get(id: String) {
  use <- bool.guard(
    simplifile.is_file("data/" <> id) != Ok(True),
    wisp.not_found(),
  )

  wisp.ok()
  |> wisp.set_header("Content-Type", filetype.get_content_type(id))
  |> wisp.set_body(wisp.File("data/" <> id))
}
