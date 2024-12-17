import gleam/erlang/process.{type Subject}
import gleam/option.{type Option}

pub type Character {
  Character(
    name: String,
    // Add other character attributes as needed
  )
}

// Message types for the process
pub type Message {
  CreateCharacter(String, String)
  // user_id, character_name
  GetCharacter(String, Subject(Option(Character)))
  // user_id, reply_subject
}

pub type CharacterRegistry {
  CharacterRegistry
}
