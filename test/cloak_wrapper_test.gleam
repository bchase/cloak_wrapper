import gleam/result
import gleeunit
import gleeunit/should
import cloak_wrapper as cloak

pub fn main() {
  gleeunit.main()
}

pub fn elixir_cloak_encrypt_decrypt_test() {
  let cloak =
    cloak.config_aes_gcm(
      key: "rf2xCGeAqlYP2T3PoO8PkMW2jic2FsPwJ8lnuVo0X1Y=",
      tag:  "AES.GCM.V1",
      iv_length: 12,
    )

  let plaintext = "Fear is the little-death that brings total obliteration."

  Ok(plaintext)
  |> result.then(cloak.encrypt_aes_gcm(cloak, _))
  |> result.then(cloak.decrypt_aes_gcm(cloak, _))
  |> result.unwrap("FAILED elixir_cloak_encrypt_decrypt_test")
  |> should.equal(plaintext)
}
