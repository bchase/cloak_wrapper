import gleam/result
import gleeunit
import gleeunit/should
// import cloak_wrapper as cloak
import cloak_wrapper/aes/gcm as cloak
import cloak_wrapper/crypto/key

pub fn main() {
  gleeunit.main()
}

pub fn elixir_cloak_encrypt_decrypt_test() {
  let key = key.gen_base64(32)

  let cloak =
    cloak.config(
      // key: "rf2xCGeAqlYP2T3PoO8PkMW2jic2FsPwJ8lnuVo0X1Y=",
      key:,
      tag:  "AES.GCM.V1",
      iv_length: 12,
    )

  let plaintext = "Fear is the little-death that brings total obliteration."

  Ok(plaintext)
  |> result.try(cloak.encrypt(_, cloak))
  |> result.try(cloak.decrypt(_, cloak))
  |> result.unwrap("FAILED elixir_cloak_encrypt_decrypt_test")
  |> should.equal(plaintext)
}
