import sequoia

var
  cfg: sq_config_t
  ctx: sq_context_t

cfg = sq_context_configure("nim.sequoia.example")
sq_config_network_policy(cfg, SQ_NETWORK_POLICY_OFFLINE)
ctx = sq_config_build(cfg, nil)

sq_context_free(ctx)
