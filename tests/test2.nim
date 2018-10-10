import sequoia, os

var
  err: sq_error_t
  ctx: sq_context_t
  tpk: sq_tpk_t

ctx = sq_context_new("nim.sequoia.example", addr err)
if ctx == nil:
  quit("Initializing sequoia failed: " & $sq_error_string(err), QuitFailure)

tpk = sq_tpk_from_file(ctx, getAppDir() & "/data/keys/testy.pgp")
if tpk == nil:
  err = sq_context_last_error(ctx)
  quit("Initializing sequoia failed: " & $sq_error_string(err), QuitFailure)

sq_tpk_free(tpk)
sq_context_free(ctx)
