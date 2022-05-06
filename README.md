# sequoia.nim
Sequoia PGP wrapper for Nim https://gitlab.com/sequoia-pgp

## Dependencies
- nettle-dev
- libsqlite3
- libssl
- libcrypto
- libpthread

## Building

By default this module uses statically linked libraries located at src/sequoia/lib, but you can switch to dynamically linked ones by toggling the  `SQ_DYNAMIC_LINK` switch

