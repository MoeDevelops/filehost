import filehost/router
import gleam/erlang/process
import mist
import simplifile
import wisp
import wisp/wisp_mist

pub fn main() -> Nil {
  let _ = simplifile.create_directory("data")
  wisp.configure_logger()

  let secret_key_base = wisp.random_string(64)

  let assert Ok(_) =
    wisp_mist.handler(router.handle_request, secret_key_base)
    |> mist.new()
    |> mist.bind("0.0.0.0")
    |> mist.port(5001)
    |> mist.start_http()

  process.sleep_forever()
}
