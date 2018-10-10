import sequoia, os

var
  err: sq_error_t
  id: sq_keyid_t
  ctx: sq_context_t
  bytes: sq_reader_t
  armor: sq_reader_t
  kind: sq_armor_kind_t
  message: array[12, char]
  header: ptr sq_armor_header_t
  header_len: int

  armored = """-----BEGIN PGP ARMORED FILE-----
Key0: Value0
Key1: Value1

SGVsbG8gd29ybGQh
=s4Gu
-----END PGP ARMORED FILE-----"""


ctx = sq_context_new("nim.sequoia.example", addr err)
if ctx == nil:
  quit("Initializing sequoia failed: " & $sq_error_string(err), QuitFailure)

bytes = sq_reader_from_bytes(cast[ptr uint8](addr armored[0]), armored.len)
armor = sq_armor_reader_new(bytes, SQ_ARMOR_KIND_ANY)

header = sq_armor_reader_headers(ctx, armor, addr header_len)

if header == nil:
  err = sq_context_last_error(ctx)
  quit("Getting headers failed: " & $sq_error_string(err), QuitFailure)


assert header_len == 2
var headers = cast[ptr array[2, sq_armor_header_t]](header)

assert headers[0].key == "Key0"
assert headers[0].value == "Value0"

assert headers[1].key == "Key1"
assert headers[1].value == "Value1"

for i in 0..<header_len:
  dealloc(headers[i].key)
  dealloc(headers[i].value)
dealloc(header)


kind = sq_armor_reader_kind(armor)
assert kind == SQ_ARMOR_KIND_FILE

if sq_reader_read(ctx, armor, cast[ptr uint8](addr message[0]), 12) < 0:
  err = sq_context_last_error(ctx)
  quit("Reading failed: " & $sq_error_string(err), QuitFailure)

assert equalMem(addr message, "Hello world!".cstring, 12)

sq_reader_free(armor)
sq_reader_free(bytes)
sq_context_free (ctx)
