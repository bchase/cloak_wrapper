import gleam/bit_array
import gleam/result


// CONFIG

pub opaque type ConfigAesGcm {
  ConfigAesGcm(
    key: BitArray,
    tag: BitArray,
    iv_length: Int,
  )
}

pub fn config_aes_gcm(
  key key: String,
  tag tag: String,
  iv_length iv_length: Int,
) -> ConfigAesGcm {
  let assert Ok(key) = bit_array.base64_decode(key)
  let tag = bit_array.from_string(tag)

  ConfigAesGcm(key, tag, iv_length)
}


// ENCRYPT & DECRYPT

pub fn encrypt_aes_gcm(
  cloak: ConfigAesGcm,
  plaintext: String,
) -> Result(String, Nil) {
  // encrypt_aes_gcm_erlang(plaintext, cloak.key, cloak.tag, cloak.iv_length)
  encrypt_aes_gcm_elixir(plaintext, [
    Key(cloak.key),
    Tag(cloak.tag),
    IvLength(cloak.iv_length),
  ])
  |> result.map (bit_array.base64_encode(_, True))
}

pub fn decrypt_aes_gcm(
  cloak: ConfigAesGcm,
  value: String,
) -> Result(String, Nil) {
  value
  |> bit_array.base64_decode()
  // |> result.then(decrypt_aes_gcm_erlang(_, cloak.key, cloak.tag, cloak.iv_length))
  |> result.then(decrypt_aes_gcm_elixir(_, [
    Key(cloak.key),
    Tag(cloak.tag),
    IvLength(cloak.iv_length),
  ]))
}

type CloakOpt {
  Key(BitArray)
  Tag(BitArray)
  IvLength(Int)
}


// FFI

@external(erlang, "Elixir.Cloak.Ciphers.AES.GCM", "encrypt")
fn encrypt_aes_gcm_elixir(
  plaintext: String,
  opts: List(CloakOpt)
) -> Result(BitArray, Nil)

@external(erlang, "Elixir.Cloak.Ciphers.AES.GCM", "decrypt")
fn decrypt_aes_gcm_elixir(
  plaintext: BitArray,
  opts: List(CloakOpt)
) -> Result(String, Nil)

// @external(erlang, "cloak_wrapper_ffi", "encrypt_aes_gcm")
// fn encrypt_aes_gcm_erlang(
//   plaintext: String,
//   key: BitArray,
//   tag: BitArray,
//   iv_length: Int,
// ) -> Result(BitArray, Nil)
//
// @external(erlang, "cloak_wrapper_ffi", "decrypt_aes_gcm")
// fn decrypt_aes_gcm_erlang(
//   plaintext: BitArray,
//   key: BitArray,
//   tag: BitArray,
//   iv_length: Int,
// ) -> Result(String, Nil)
