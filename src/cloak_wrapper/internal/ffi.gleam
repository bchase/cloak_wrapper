pub type CloakOpt {
  Key(BitArray)
  Tag(BitArray)
  IvLength(Int)
}

@external(erlang, "Elixir.Cloak.Ciphers.AES.GCM", "encrypt")
pub fn encrypt_aes_gcm(
  plaintext: String,
  opts: List(CloakOpt)
) -> Result(BitArray, Nil)

@external(erlang, "Elixir.Cloak.Ciphers.AES.GCM", "decrypt")
pub fn decrypt_aes_gcm(
  plaintext: BitArray,
  opts: List(CloakOpt)
) -> Result(String, Nil)
