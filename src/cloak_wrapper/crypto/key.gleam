import gleam/bit_array
import gleam/crypto

pub fn gen(
  bytes bytes: Int,
) -> BitArray {
  bytes
  |> crypto.strong_random_bytes
}

pub fn gen_base64(
  bytes bytes: Int,
) -> String {
  bytes
  |> gen
  |> bit_array.base64_encode(True)
}
