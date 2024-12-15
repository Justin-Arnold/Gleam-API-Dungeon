import app/web
import gleam/http.{Delete, Get, Post, Put}
import gleam/string
import gleam/string_builder
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use req <- web.middleware(req)

  // Wisp doesn't have a special router abstraction, instead we recommend using
  // regular old pattern matching. This is faster than a router, is type safe,
  // and means you don't have to learn or be limited by a special DSL.
  //
  case wisp.path_segments(req) {
    // This matches `/`.
    [] -> home_page(req)

    // This matches `/start`.
    ["start"] -> start(req)

    // Show character creation info
    ["create-character"] -> character_creation_info(req)

    // Handle character creation with class and name
    ["create-character", class_name, character_name] ->
      create_character(req, class_name, character_name)

    // This matches all other paths.
    _ -> wisp.not_found()
  }
}

fn character_creation_info(req: Request) -> Response {
  use <- wisp.require_method(req, Get)
  let html =
    string_builder.from_string(
      "
    <h1>Character Creation</h1>
    <p>
      To create a character, use the following endpoint:
      <code>/create-character/[class]/[name]</code>
    </p>
    <h2>Available Classes:</h2>
    <ul>
      <li>warrior - Strong melee fighter</li>
      <li>mage - Powerful spell caster</li>
      <li>rogue - Quick and stealthy</li>
    </ul>
    <p>Example: <code>/create-character/warrior/Conan</code></p>
  ",
    )

  wisp.ok()
  |> wisp.html_body(html)
}

pub type CreationError {
  InvalidClass
}

fn create_character(
  req: Request,
  class_name: String,
  character_name: String,
) -> Response {
  use <- wisp.require_method(req, Get)

  // Convert string to Class type
  let class = case string.lowercase(class_name) {
    "warrior" -> Ok(Warrior)
    "mage" -> Ok(Mage)
    "rogue" -> Ok(Rogue)
    _ -> Error(InvalidClass)
  }

  case class {
    Ok(class) -> {
      let character =
        Character(
          user_id: "111",
          // You'll need to implement this
          name: character_name,
          class: class,
        )

      // Here you would save the character to your game state

      let html = string_builder.from_string("
        <h1>Character Created!</h1>
        <p>You have created a " <> class_name <> " named " <> character_name <> "</p>
        <p>Your character is ready to enter the dungeon.</p>
      ")

      wisp.ok()
      |> wisp.html_body(html)
    }

    Error(_) -> {
      let html =
        string_builder.from_string(
          "
        <h1>Invalid Class</h1>
        <p>Please choose from: warrior, mage, or rogue</p>
      ",
        )

      wisp.bad_request()
      |> wisp.html_body(html)
    }
  }
}

fn home_page(req: Request) -> Response {
  // The home page can only be accessed via GET requests, so this middleware is
  // used to return a 405: Method Not Allowed response for all other methods.
  use <- wisp.require_method(req, Get)
  let html =
    string_builder.from_string(
      "
    <h1>Gleam Dungeon Crawler</h1>
    <p>
      This was a project created with the goal of learning the Gleam language,
      as well as creating a fun way for people to interact with an API. This can
      either be done in a browser or by directly via the API endpoints.
    </p>
    <h2>Directions</h2>
    <p>
      The goal of this is to traverse the dungeon and defeat the final enemy at the end.
      This is done by using various commands via their respective endpoints. Query
      parameters are used for user input.
    </p>
    <h2>Commands</h2>
    <p>
      These are the different commands you can use. Each command has a description, endpoint,
      and any query parameters.
    </p>
    <h3>Start</h3>
    <p>
      This is used to start an adventure if you have not already. If you have, it will return
      the last given responce.
    </p>
    <p>
      <strong>Endpoint:</strong> /start
    </p>
    <p>
      <strong>Parameters:</strong> none
    </p>
  ",
    )

  wisp.ok()
  |> wisp.html_body(html)
}

fn start(req: Request) -> Response {
  use <- wisp.require_method(req, Get)
  // This handler for `/start` can respond to both GET and POST requests,
  // so we pattern match on the method here.
  use <- wisp.require_method(req, Get)
  let html =
    string_builder.from_string(
      "
    <h1>Start</h1>
    <p>
      To enter the dungeon, you must first create your character
    </p>
  ",
    )

  wisp.ok()
  |> wisp.html_body(html)
}

pub type GameInstance {
  GameInstance(
    user_id: String,
    character: Character,
    current_room: Room,
    inventory: List(Item),
    health: Int,
    // etc
  )
}

pub type Character {
  Character(user_id: String, name: String, class: Class)
}

pub type Class {
  Warrior
  Mage
  Rogue
}

pub type Room {
  Spawn
  Boss
  Fight
  Trap
  Treasure
}

pub type Item {
  Potion
  Poison
}
