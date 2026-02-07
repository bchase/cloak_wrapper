import gleam/result
import gleam/otp/actor
import gleam/otp/supervision
import gleam/erlang/process.{type Name}
import cloak_wrapper/aes/gcm.{type Config} as aes_gcm

const fetch_config_wait_time_ms = 100

pub opaque type Store {
  Store(
    name: Name(Msg),
  )
}

// SUPERVISION

pub fn supervised(
  name name: Name(Msg),
  load load: fn() -> Config,
) -> supervision.ChildSpecification(Store) {
  supervision.worker(fn() { start(name:, load:) })
}

type State {
  State(
    config: Config,
  )
}

pub opaque type Msg {
  GotConfigRequest(reply: process.Subject(Config))
}

@internal
pub fn start(
  name name: Name(Msg),
  load load_config: fn() -> Config,
) -> Result(actor.Started(Store), actor.StartError) {
  actor.new_with_initialiser(100, fn(_self) {
    let config = load_config()

    State(
      config:,
    )
    |> actor.initialised
    |> actor.returning(Store(name:))
    |> Ok
  })
  |> actor.on_message(fn(state, msg) {
    case msg {
      GotConfigRequest(reply:) -> {
        process.send(reply, state.config)
        actor.continue(state)
      }
    }
  })
  |> actor.named(name)
  |> actor.start
}

// API

pub fn get(
  name name: Name(Msg),
) -> Store {
  Store(name:)
}

pub fn encrypt(
  store store: Store,
  plaintext plaintext: String,
) -> Result(String, Nil) {
  store
  |> fetch_config
  |> result.map(aes_gcm.encrypt(plaintext:, config: _))
  |> result.flatten
}

pub fn decrypt(
  store store: Store,
  ciphertext ciphertext: String,
) -> Result(String, Nil) {
  store
  |> fetch_config
  |> result.map(aes_gcm.decrypt(ciphertext:, config: _))
  |> result.flatten
}

//

fn fetch_config(
  store store: Store,
) -> Result(Config, Nil) {
  let store = store.name |> process.named_subject

  let self = process.new_subject()
  process.send(store, GotConfigRequest(reply: self))

  process.receive(self, fetch_config_wait_time_ms)
}
