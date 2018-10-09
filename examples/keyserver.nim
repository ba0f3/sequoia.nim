import os, memfiles, sequoia

var
  err: sq_error_t
  ctx: sq_context_t
  id: sq_keyid_t
  ks: sq_keyserver_t
  tpk: sq_tpk_t

var KEY_ID = "\x24\x7F\x6D\xAB\xC8\x49\x14\xFE".cstring

ctx = sq_context_new("nim.sequoia.example", addr err)
if ctx == nil:
  quit("Initializing sequoia failed: " & $sq_error_string(err), QuitFailure)

ks = sq_keyserver_sks_pool(ctx)
if ks == nil:
  err = sq_context_last_error(ctx)
  quit("Initializing Keyserver failed: " & $sq_error_string(err), QuitFailure)

id = sq_keyid_from_bytes(cast[ptr uint8](KEY_ID))

tpk = sq_keyserver_get(ctx, ks, id)

if tpk == nil:
  err = sq_context_last_error(ctx)
  quit("Failed to retrieve key: " & $sq_error_string(err), QuitFailure)

sq_tpk_dump(tpk)
sq_tpk_free(tpk)
sq_keyid_free(id)
sq_keyserver_free(ks)
sq_context_free(ctx)
