import os, sequoia

var
  use_armor = true
  rc: sq_status_t
  err: sq_error_t
  ctx: sq_context_t
  tpk: sq_tpk_t
  sink: sq_writer_t
  writer: sq_writer_stack_t
  cipher: pointer
  cipher_bytes: int

if paramCount() != 1:
  quit("Usage: " & paramStr(0) & " <keyfile> <plain >cipher" , QuitFailure)

ctx = sq_context_new("nim.sequoia.example", addr err)
if ctx == nil:
  quit("Initializing sequoia failed: " & $sq_error_string(err), QuitFailure)


let keyfile = paramStr(1)

if not keyfile.fileExists():
  quit("File not found: " & keyfile, QuitFailure)


var reader = sq_armor_reader_from_file(ctx, keyfile, SQ_ARMOR_KIND_PUBLICKEY)

if reader == nil:
  err = sq_context_last_error(ctx)
  quit("sq_armor_reader_new: " & $sq_error_string(err), QuitFailure)

tpk = sq_tpk_from_reader(ctx, reader)

if tpk == nil:
  err = sq_context_last_error(ctx)
  quit("sq_tpk_from_reader: " & $sq_error_string(err), QuitFailure)

sink = sq_writer_alloc(addr cipher, addr cipher_bytes)

if use_armor:
  sink = sq_armor_writer_new(ctx, sink, SQ_ARMOR_KIND_MESSAGE, nil, 0)

writer = sq_writer_stack_wrap(sink)
writer = sq_encryptor_new(ctx, writer, nil, 0, addr tpk, 1, SQ_ENCRYPTION_MODE_FOR_TRANSPORT)
if writer == nil:
  err = sq_context_last_error(ctx)
  quit("sq_encryptor_new: " & $sq_error_string(err), QuitFailure)

writer = sq_literal_writer_new(ctx, writer)
if writer == nil:
  err = sq_context_last_error(ctx)
  quit("sq_literal_writer_new: " & $sq_error_string(err), QuitFailure)

var input = readAll(stdin)
var written = sq_writer_stack_write(ctx, writer, cast[ptr uint8](addr input[0]), input.len)
if written < 0:
  err = sq_context_last_error(ctx)
  quit("sq_writer_stack_write: " & $sq_error_string(err), QuitFailure)

rc = sq_writer_stack_finalize(ctx, writer)
if rc != SQ_STATUS_SUCCESS:
  err = sq_context_last_error(ctx)
  quit("sq_writer_stack_write: " & $sq_error_string(err), QuitFailure)

discard writeBuffer(stdout, cipher, cipher_bytes)

#sq_tpk_dump(tpk)
sq_tpk_free(tpk)
sq_context_free(ctx)
