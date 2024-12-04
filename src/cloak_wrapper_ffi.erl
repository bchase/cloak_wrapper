-module(cloak_wrapper_ffi).

-export([encrypt_aes_gcm/4, decrypt_aes_gcm/4]).

encrypt_aes_gcm(Plaintext, Key, Tag, IvLength) ->
  'Elixir.Cloak.Ciphers.AES.GCM':encrypt(Plaintext, [
    {key, Key},
    {tag, Tag},
    {iv_length, IvLength}
   ]).

decrypt_aes_gcm(Plaintext, Key, Tag, IvLength) ->
  'Elixir.Cloak.Ciphers.AES.GCM':decrypt(Plaintext, [
    {key, Key},
    {tag, Tag},
    {iv_length, IvLength}
   ]).
