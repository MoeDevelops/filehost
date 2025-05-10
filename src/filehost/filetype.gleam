import filepath
import gleam/result

pub fn get_content_type(file: String) {
  case filepath.extension(file) |> result.unwrap("") {
    // Image
    "apng" -> "image/apng"
    "avif" -> "image/avif"
    "gif" -> "image/gif"
    "jpg" | "jpeg" -> "image/jpeg"
    "png" -> "image/png"
    "svg" -> "image/svg+xml"
    "webp" -> "image/webp"
    // Video
    "mp4" -> "video/mp4"
    _ -> "text/plain"
  }
}
