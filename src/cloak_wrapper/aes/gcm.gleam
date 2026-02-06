import gleam/bit_array
import gleam/result.{try}
import cloak_wrapper/internal/ffi.{type CloakOpt, Key, Tag, IvLength} as cloak_ffi

pub opaque type Config {
  Config(
    key: CloakOpt,
    tag: CloakOpt,
    iv_length: CloakOpt,
  )
}

pub fn config(
  key key: String,
  tag tag: String,
  iv_length iv_length: Int,
) -> Config {
  let assert Ok(key) =
    bit_array.base64_decode(key) as "decode key as base64"

  Config(
    key: Key(key),
    tag: Tag(tag |> bit_array.from_string),
    iv_length: IvLength(iv_length),
  )
}

//

pub fn encrypt(
  plaintext plaintext: String,
  config config: Config,
) -> Result(String, Nil) {
  let opts = cloak_opts(config:)

  use encrypted <- try(cloak_ffi.encrypt_aes_gcm(plaintext, opts))

  Ok(encrypted |> bit_array.base64_encode(True))
}

pub fn decrypt(
  ciphertext ciphertext: String,
  config config: Config,
) -> Result(String, Nil) {
  let opts = cloak_opts(config:)

  use bytes <- try(bit_array.base64_decode(ciphertext))
  use plaintext <- try(cloak_ffi.decrypt_aes_gcm(bytes, opts))

  Ok(plaintext)
}

//

fn cloak_opts(
  config config: Config,
) -> List(CloakOpt) {
  let Config(key:, tag:, iv_length:) = config

  [ key, tag, iv_length ]
}
