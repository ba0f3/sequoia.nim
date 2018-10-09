import os, sequoia

var
  err: sq_error_t
  ctx: sq_context_t
  reader: sq_reader_t
  tpk: sq_tpk_t

if paramCount() != 1:
  quit("Usage: " & paramStr(0) & " <file>" , QuitFailure)

let file = paramStr(1)

if not file.fileExists():
  quit("File not found: " & file, QuitFailure)

ctx = sq_context_new("nim.sequoia.example", addr err)
if ctx == nil:
  quit("Initializing sequoia failed: " & $sq_error_string(err), QuitFailure)

reader = sq_armor_reader_from_file(ctx, file, SQ_ARMOR_KIND_PUBLICKEY)

tpk = sq_tpk_from_reader(ctx, reader)
if tpk == nil:
  err = sq_context_last_error(ctx)
  quit("sq_tpk_from_reader: " & $sq_error_string(err), QuitFailure)

sq_tpk_dump(tpk)
sq_tpk_free(tpk)
sq_context_free(ctx)

