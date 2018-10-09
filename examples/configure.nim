import os, memfiles, sequoia

var
  err: sq_error_t
  cfg: sq_config_t
  ctx: sq_context_t
  ks: sq_keyserver_t


cfg = sq_context_configure("nim.sequoia.example")
sq_config_network_policy(cfg, SQ_NETWORK_POLICY_OFFLINE)
ctx = sq_config_build(cfg, addr err)

if ctx == nil:
  quit("Initializing sequoia failed: " & $sq_error_string(err), QuitFailure)

ks = sq_keyserver_sks_pool(ctx)
if ks == nil:
  err = sq_context_last_error(ctx)
  assert(sq_error_status(err) == SQ_STATUS_NETWORK_POLICY_VIOLATION)
  var msg = sq_error_string(err)
  quit("Initializing KeyServer failed as expected: " & $msg, QuitFailure)
else:
  quit("This should not be allowed", QuitFailure)

sq_keyserver_free(ks)
sq_context_free(ctx)
