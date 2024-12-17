import app/utilities.{make_page}
import wisp.{type Request}

pub fn home(req: Request) {
  make_page(
    req,
    "
        <h1>Gleam Dungeon Crawler</h1>
        <p>
        This was a project created with the goal of learning the Gleam language,
        as well as creating a fun way for people to interact with an API. 
        </p>
        <h2>Directions</h2>
        <p>
        The goal of this is to traverse the dungeon and defeat the final enemy at the end.
        Use the endpoints to create a character and then start your journey.
        </p>
        <h2>Commands</h2>
        <h3>Start</h3>
        <p><strong>Endpoint:</strong> /start</p>
        <p><strong>Parameters:</strong> none</p>
    ",
  )
}

pub fn start(req: Request) {
  make_page(
    req,
    "
        <h1>Start</h1>
        <p>
        To enter the dungeon, you must first create your character
        </p>
    ",
  )
}

pub fn create_character(
  req: Request,
  class_name: String,
  character_name: String,
) {
  // let class = case string.lowercase(class_name) {
  //     "warrior" -> Ok(Warrior)
  //     "mage" -> Ok(Mage)
  //     "rogue" -> Ok(Rogue)
  //     _ -> Error(InvalidClass)
  // }
  make_page(req, "
        <h1>Character Created!</h1>
        <p>You have created a " <> class_name <> " named " <> character_name <> "</p>
        <p>Your character is ready to enter the dungeon.</p>
    ")
}
