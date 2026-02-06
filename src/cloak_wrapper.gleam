import gleam/bit_array
import gleam/result
import cloak_wrapper/internal/ffi.{Key, Tag, IvLength} as cloak_ffi

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
  cloak_ffi.encrypt_aes_gcm(plaintext, [
    Key(cloak.key),
    Tag(cloak.tag),
    IvLength(cloak.iv_length),
  ])
  |> result.map(bit_array.base64_encode(_, True))
}

pub fn decrypt_aes_gcm(
  cloak: ConfigAesGcm,
  value: String,
) -> Result(String, Nil) {
  value
  |> bit_array.base64_decode()
  |> result.then(cloak_ffi.decrypt_aes_gcm(_, [
    Key(cloak.key),
    Tag(cloak.tag),
    IvLength(cloak.iv_length),
  ]))
}
