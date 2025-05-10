import filepath
import gleam/result

pub fn get_content_type(file: String) {
  case filepath.extension(file) |> result.unwrap("") {
    "png" -> "image/png"
    _ -> "text/plain"
  }
}
