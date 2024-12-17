import app/pages.{home, start}
import app/web
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use req <- web.middleware(req)

  // Wisp doesn't have a special router abstraction, instead we recommend using
  // regular old pattern matching. This is faster than a router, is type safe,
  // and means you don't have to learn or be limited by a special DSL.
  //
  case wisp.path_segments(req) {
    // This matches `/`.
    [] -> home(req)
    // This matches `/start`.
    ["start"] -> start(req)
    // // Show character creation info
    // ["create-character"] -> character_creation_info(req)
    // // Handle character creation with class and name
    // ["create-character", class_name, character_name] ->
    //   create_character(req, class_name, character_name)
    // This matches all other paths.
    _ -> wisp.not_found()
  }
}
// import app/types.{Character}
// import gleam/erlang/process.{type Pid}
// import gleam/http.{Delete, Get, Post, Put}
// import gleam/string
// import gleam/dict.{type Dict}
// import gleam/option.{type Option, None, Some}
// import gleam/string_builder
// import wisp.{type Request, type Response}

// // Show character creation info
// fn character_creation_info(req: Request, session_id: String) -> Response {
//   use <- wisp.require_method(req, Get)
//   let html =
//     string_builder.from_string(
//       "
//     <h1>Character Creation</h1>
//     <p>
//       To create a character, use the following endpoint:
//       <code>/create-character/[class]/[name]</code>
//     </p>
//     <h2>Available Classes:</h2>
//     <ul>
//       <li>warrior - Strong melee fighter</li>
//       <li>mage - Powerful spell caster</li>
//       <li>rogue - Quick and stealthy</li>
//     </ul>
//     <p>Example: <code>/create-character/warrior/Conan</code></p>
//   ",
//     )

//   wisp.ok()
//   |> wisp.html_body(html)
// }

// pub type CreationError {
//   InvalidClass
// }

// fn create_character(
//   req: Request,
//   class_name: String,
//   character_name: String,
//   session_id: String,
// ) -> Response {
//   use <- wisp.require_method(req, Get)

//   let class = case string.lowercase(class_name) {
//     "warrior" -> Ok(Warrior)
//     "mage" -> Ok(Mage)
//     "rogue" -> Ok(Rogue)
//     _ -> Error(InvalidClass)
//   }

//   case class {
//     Ok(class) -> {
//       let character =
//         Character(user_id: session_id, name: character_name, class: class)

//       // Store the character in memory keyed by the session_id
//       set_character(session_id, character)

//       let html = string_builder.from_string("
//         <h1>Character Created!</h1>
//         <p>You have created a " <> class_name <> " named " <> character_name <> "</p>
//         <p>Your character is ready to enter the dungeon.</p>
//         <p><a href=\"/start\">Go to start</a></p>
//       ")

//       wisp.ok()
//       |> wisp.html_body(html)
//     }

//     Error(_) -> {
//       let html =
//         string_builder.from_string(
//           "
//         <h1>Invalid Class</h1>
//         <p>Please choose from: warrior, mage, or rogue</p>
//       ",
//         )

//       wisp.bad_request()
//       |> wisp.html_body(html)
//     }
//   }
// }

// fn home_page(req: Request, session_id: String) -> Response {
//   use <- wisp.require_method(req, Get)
//   let html =
//     string_builder.from_string(
//       "
//     <h1>Gleam Dungeon Crawler</h1>
//     <p>
//       This was a project created with the goal of learning the Gleam language,
//       as well as creating a fun way for people to interact with an API. 
//     </p>
//     <h2>Directions</h2>
//     <p>
//       The goal of this is to traverse the dungeon and defeat the final enemy at the end.
//       Use the endpoints to create a character and then start your journey.
//     </p>
//     <h2>Commands</h2>
//     <h3>Start</h3>
//     <p><strong>Endpoint:</strong> /start</p>
//     <p><strong>Parameters:</strong> none</p>
//   ",
//     )

//   wisp.ok()
//   |> wisp.html_body(html)
// }

// fn start(req: Request, session_id: String) -> Response {
//   use <- wisp.require_method(req, Get)

//   let character = get_character(session_id)

//   let html = case character {
//     None -> {
//       // No character created yet
//       string_builder.from_string(
//         "
//         <h1>Start</h1>
//         <p>You have not created a character yet.</p>
//         <p><a href=\"/create-character\">Create one here</a></p>
//       ",
//       )
//     }
//     Some(c) -> {
//       // Character exists
//       string_builder.from_string("
//         <h1>Welcome back, " <> c.name <> " the " <> class_to_string(c.class) <> "!</h1>
//         <p>You are standing at the entrance to the dungeon once more...</p>
//       ")
//     }
//   }

//   wisp.ok()
//   |> wisp.html_body(html)
// }

// fn class_to_string(class: Class) -> String {
//   case class {
//     Warrior -> "Warrior"
//     Mage -> "Mage"
//     Rogue -> "Rogue"
//   }
// }

// pub type GameInstance {
//   GameInstance(
//     user_id: String,
//     character: Character,
//     current_room: Room,
//     inventory: List(Item),
//     health: Int,
//   )
// }

// pub type Character {
//   Character(user_id: String, name: String, class: Class)
// }

// pub type Class {
//   Warrior
//   Mage
//   Rogue
// }

// pub type Room {
//   Spawn
//   Boss
//   Fight
//   Trap
//   Treasure
// }

// pub type Item {
//   Potion
//   Poison
// }
