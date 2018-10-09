# sequoia
# Copyright Huy Doan
# Sequoia PGP wrapper for Nim
import ospaths
const SOURCE_DIR = currentSourcePath().splitPath.head & "/sequoia/lib"
{.passL: "-L" & SOURCE_DIR & " -lsequoia_ffi".}

{.pragma: sequioa, cdecl, importc.}

include sequoia/error
include sequoia/core
include sequoia/openpgp
include sequoia/net
include sequoia/store
