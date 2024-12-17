import gleam/http.{Get}
import gleam/string_tree
import wisp.{type Request, type Response}

pub fn make_page(req: Request, html: String) -> Response {
  use <- wisp.require_method(req, Get)

  let parsed_html = string_tree.from_string(html)

  wisp.ok()
  |> wisp.html_body(parsed_html)
}
