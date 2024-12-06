# cloak_wrapper

[![Package Version](https://img.shields.io/hexpm/v/cloak_wrapper)](https://hex.pm/packages/cloak_wrapper)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/cloak_wrapper/)

```sh
gleam add cloak_wrapper@1
```

```gleam
import cloak_wrapper as cloak

let cloak_cfg =
  cloak.config_aes_gcm(
    key: "rf2xCGeAqlYP2T3PoO8PkMW2jic2FsPwJ8lnuVo0X1Y=",
    tag:  "AES.GCM.V1",
    iv_length: 12,
  )

let plaintext = "Fear is the little-death that brings total obliteration."

let assert Ok(encrypted) = cloak.encrypt_aes_gcm(cloak_cfg, plaintext)
let assert Ok(decrypted) = cloak.decrypt_aes_gcm(cloak_cfg, encrypted)
```
