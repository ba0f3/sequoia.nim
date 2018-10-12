# sequoia.nim
Sequoia PGP wrapper for Nim https://gitlab.com/sequoia-pgp
        

## Dependences
- nettle-dev
- libsqilte3
- libssl
- libcrypto
- libpthread

## Building

By default, this module uses static linked libraies provided in src/sequioa/lib, you can use dynamic linked with `SQ_DYMANIC_LINK` swtich

