import gleam/option.{None, Option, Some}
import gluid.{guidv4}
import wisp

pub const user_id_cookie = "gleam_api_dungeon_user_id"

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  // Log information about the request and response.
  use <- wisp.log_request(req)

  // Return a default 500 response if the request handler crashes.
  use <- wisp.rescue_crashes

  // Rewrite HEAD requests to GET requests and return an empty body.
  use req <- wisp.handle_head(req)

  // Check if the request has a "user_id" cookie, and add one if not.
  let req = ensure_user_id_cookie(req)

  // Handle the request!
  handle_request(req)
}

// Ensure the request has a "gleam_api_dungeon_user_id" cookie. If not, add one.
fn ensure_user_id_cookie(req: wisp.Request) -> wisp.Request {
  case wisp.get_cookie(req, user_id_cookie, wisp.PlainText) {
    Ok(_) -> req
    // The user_id cookie already exists, so return the request as is.
    Error(Nil) -> {
      let new_user_id = guidv4()
      wisp.set_cookie(req, user_id_cookie, new_user_id)
      req
    }
  }
}
