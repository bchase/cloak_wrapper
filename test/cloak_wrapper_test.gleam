import cloak_wrapper/aes/gcm as aes_gcm
import cloak_wrapper/crypto/key
import cloak_wrapper/store
import gleam/erlang/process
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

const plaintext = "Fear is the little-death that brings total obliteration."

pub fn cloak_encrypt_decrypt_test() {
  let config = build_config()

  let assert Ok(ciphertext) = aes_gcm.encrypt(plaintext:, config:)
  let assert Ok(decrypted) = aes_gcm.decrypt(ciphertext:, config:)

  ciphertext |> should.not_equal(plaintext)
  decrypted |> should.equal(plaintext)
}

pub fn store_test() {
  let name = process.new_name("store_test")

  let assert Ok(_started) = store.start(name:, load: fn() { build_config() })

  let store = store.get(name)

  let assert Ok(ciphertext) = store.encrypt(plaintext:, store:)
  let assert Ok(decrypted) = store.decrypt(ciphertext:, store:)

  ciphertext |> should.not_equal(plaintext)
  decrypted |> should.equal(plaintext)
}

//

fn build_config() -> aes_gcm.Config {
  aes_gcm.config(
    // key: "rf2xCGeAqlYP2T3PoO8PkMW2jic2FsPwJ8lnuVo0X1Y=",
    key: key.gen_base64(32),
    tag: "AES.GCM.V1",
    iv_length: 12,
  )
}
