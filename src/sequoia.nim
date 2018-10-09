# sequoia
# Copyright Huy Doan
# Sequoia PGP wrapper for Nim
import ospaths
const LIB_DIR = currentSourcePath().splitPath.head & "/sequoia/lib"
{.passL: "-L" & LIB_DIR & " -lsequoia_ffi -lssl -lcrypto -lnettle -lhogweed -lgmp -lsqlite3 -lpthread".}

{.pragma: sequioa, cdecl, importc.}

include sequoia/error
include sequoia/core
include sequoia/openpgp
include sequoia/net
include sequoia/store
