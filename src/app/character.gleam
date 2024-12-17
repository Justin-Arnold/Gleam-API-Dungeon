// import app/types.{Character}
// import gleam/dict.{type Dict}

// fn loop(characters: Dict(String, Character)) {
//   receive() {
//     CreateCharacter(user_id, name) -> {
//       let new_characters = dict.insert(characters, user_id, Character(name))
//       loop(new_characters)
//     }
//     GetCharacter(user_id, reply_to) -> {
//       let character = dict.get(characters, user_id)
//       process.send(reply_to, character)
//       loop(characters)
//     }
//   }
// }
