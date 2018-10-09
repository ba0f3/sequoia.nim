import sequoia

var
  err: sq_error_t
  ctx: sq_context_t
  tpk: sq_tpk_t

ctx = sq_context_new("nim.sequoia.example", addr err);


