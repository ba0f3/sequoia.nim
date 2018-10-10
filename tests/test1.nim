import sequoia, os

var
  err: sq_error_t
  ctx = sq_context_new("nim.sequoia.example", addr err)

if ctx == nil:
  err = sq_context_last_error(ctx)
  quit("sq_context_new: " & $sq_error_string(err), QuitFailure)


var
  #bytes = sq_reader_from_bytes(cast[ptr uint8](addr PUBLIC_KEY[0]), PUBLIC_KEY.len)
  #reader = sq_armor_reader_new(bytes, SQ_ARMOR_KIND_PUBLICKEY)
  reader = sq_armor_reader_from_file(ctx, getAppDir() & "/pubkey.asc", SQ_ARMOR_KIND_PUBLICKEY)

if reader == nil:
    err = sq_context_last_error(ctx)
    quit("sq_armor_reader_new: " & $sq_error_string(err), QuitFailure)

var
  tpk = sq_tpk_from_reader(ctx, reader)
  store = sq_store_open(ctx, "default")
if tpk == nil:
  err = sq_context_last_error(ctx)
  quit("sq_tpk_from_reader: " & $sq_error_string(err), QuitFailure)

discard sq_store_import(ctx, store, "Ἀριστοτέλης", tpk)
var
  binding = sq_store_lookup(ctx, store, "Ἀριστοτέλης")
  tpk2 = sq_binding_tpk(ctx, binding)

if tpk2 == nil:
  err = sq_context_last_error(ctx)
  quit("binding_tpk: " & $sq_error_string(err), QuitFailure)

assert sq_fingerprint_equal(sq_tpk_fingerprint(tpk), sq_tpk_fingerprint(tpk2)) == 1
