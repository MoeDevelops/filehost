import filehost/routes/file
import filehost/routes/root
import wisp.{type Request, type Response}

fn middleware(
  request: Request,
  handle_request: fn(Request) -> Response,
) -> Response {
  let request = wisp.method_override(request)
  use <- wisp.log_request(request)
  use <- wisp.rescue_crashes
  use request <- wisp.handle_head(request)

  handle_request(request)
}

pub fn handle_request(request: Request) -> Response {
  use request <- middleware(request)
  case wisp.path_segments(request) {
    [] -> root.handle_request(request)
    ["file"] -> file.handle_request(request)
    _ -> wisp.not_found() |> wisp.string_body("Not found")
  }
}
