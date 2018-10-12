# sequoia
# Copyright Huy Doan
# Sequoia PGP wrapper for Nim
import ospaths
when defined(SQ_DYNAMIC_LINK):
  {.passL: "-lsequoia_ffi -lssl -lcrypto -lnettle -lhogweed -lgmp -lsqlite3 -lpthread".}
else:
  const LIB_DIR = currentSourcePath().splitPath.head & "/sequoia/lib"
  when hostCPU == "i386":
    const SUFFIX = "32"
  else:
    const SUFFIX = "64"
  {.passL: "-L" & LIB_DIR & " -lsequoia_ffi" & SUFFIX & " -lssl -lcrypto -lnettle -lhogweed -lgmp -lsqlite3 -lpthread".}

{.pragma: sequioa, cdecl, importc.}

include sequoia/error
include sequoia/core
include sequoia/openpgp
include sequoia/net
include sequoia/store
