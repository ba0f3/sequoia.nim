## This is a port of sequoia's ffi example (https://gitlab.com/sequoia-pgp/sequoia/blob/master/ffi/examples/example.c)
## Im not sure what is this used for yet

import os, memfiles, sequoia

var
  err: sq_error_t
  ctx: sq_context_t
  tpk: sq_tpk_t

if paramCount() != 1:
  quit("Usage: " & paramStr(0) & " <file>" , QuitFailure)

let file = paramStr(1)

if not file.fileExists():
  quit("File not found: " & file, QuitFailure)

ctx = sq_context_new("nim.sequoia.example", addr err)
if ctx == nil:
  quit("Initializing sequoia failed: " & $sq_error_string(err), QuitFailure)

var mm = memfiles.open(file)

tpk = sq_tpk_from_bytes(ctx, cast[ptr uint8](mm.mem), mm.size)
if tpk == nil:
  err = sq_context_last_error(ctx)
  quit("sq_tpk_from_bytes: " & $sq_error_string(err), QuitFailure)

sq_tpk_dump(tpk)
sq_tpk_free(tpk)
sq_context_free(ctx)
mm.close()

