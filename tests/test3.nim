import sequoia, os

var
  err: sq_error_t
  id: sq_keyid_t
  ctx: sq_context_t
  ks: sq_keyserver_t
  tpk: sq_tpk_t

ctx = sq_context_new("nim.sequoia.example", addr err)
if ctx == nil:
  quit("Initializing sequoia failed: " & $sq_error_string(err), QuitFailure)

var KEY_ID = "\x24\x7F\x6D\xAB\xC8\x49\x14\xFE"

ks = sq_keyserver_sks_pool(ctx)
id = sq_keyid_from_bytes(cast[ptr uint8](addr KEY_ID[0]))
tpk = sq_keyserver_get(ctx, ks, id)
