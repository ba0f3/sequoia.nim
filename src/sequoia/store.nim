## /
## /// A public key store.
## /

type
  sq_store_t* = pointer

## /
## /// Frees a sq_store_t.
## /

proc sq_store_free*(store: sq_store_t) {.sequioa.}
## /
## /// Represents an entry in a Store.
## ///
## /// Stores map labels to TPKs.  A `Binding` represents a pair in this
## /// relation.  We make this explicit because we associate metadata
## /// with these pairs.
## /

type
  sq_binding_t* = pointer

## /
## /// Frees a sq_binding_t.
## /
proc sq_binding_free*(binding: sq_binding_t) {.sequioa.}
## /
## /// Represents a key in a store.
## ///
## /// A `Key` is a handle to a stored TPK.  We make this explicit
## /// because we associate metadata with TPKs.
## /

type
  sq_key_t* = pointer

## /
## /// Frees a sq_key_t.
## /

proc sq_key_free*(key: sq_key_t) {.sequioa.}
## /
## /// Represents a log entry.
## /

type
  sq_log* {.bycopy.} = object
    timestamp*: uint64       ## /
                       ##   /// Records the time of the entry.
                       ##   /
    ## /
    ##   /// Relates the entry to a store.
    ##   ///
    ##   /// May be `NULL`.
    ##   /
    store*: sq_store_t         ## /
                     ##   /// Relates the entry to a binding.
                     ##   ///
                     ##   /// May be `NULL`.
                     ##   /
    binding*: sq_binding_t     ## /
                         ##   /// Relates the entry to a key.
                         ##   ///
                         ##   /// May be `NULL`.
                         ##   /
    key*: sq_key_t ## /
                 ##   /// Relates the entry to some object.
                 ##   ///
                 ##   /// This is a human-readable description of what this log entry is
                 ##   /// mainly concerned with.
                 ##   /
    slug*: cstring             ## /
                 ##   /// Holds the log message.
                 ##   /
    status*: cstring           ## /
                   ##   /// Holds the error message, if any.
                   ##   ///
                   ##   /// May be `NULL`.
                   ##   /
    error*: cstring

  sq_log_t* = ptr sq_log

## /
## /// Frees a sq_log_t.
## /

proc sq_log_free*(log: sq_log_t) {.sequioa.}
## /
## /// Counter and timestamps.
## /

type
  sq_stamps* {.bycopy.} = object
    count*: uint64           ## /
                   ##   /// Counts how many times this has been used.
                   ##   /
    ## /
    ##   /// Records the time when this has been used first.
    ##   /
    first*: uint64 ## /
                   ##   /// Records the time when this has been used last.
                   ##   /
    last*: uint64


## /
## /// Represents binding or key stats.
## /

type
  sq_stats* {.bycopy.} = object
    created*: uint64         ## /
                     ##   /// Records the time this item was created.
                     ##   /
    ## /
    ##   /// Records the time this item was last updated.
    ##   /
    updated*: uint64 ## /
                     ##   /// Records counters and timestamps of encryptions.
                     ##   /
    encryption*: sq_stamps ## /
                         ##   /// Records counters and timestamps of verifications.
                         ##   /
    verification*: sq_stamps

  sq_stats_t* = ptr sq_stats

## /
## /// Frees a sq_stats_t.
## /

proc sq_stats_free*(stats: sq_stats_t) {.sequioa.}
## /
## /// Iterates over stores.
## /

type
  sq_store_iter_t* = pointer

## /
## /// Returns the next store.
## ///
## /// Returns `NULL` on exhaustion.  If `domainp` is not `NULL`, the
## /// stores domain is stored there.  If `namep` is not `NULL`, the
## /// stores name is stored there.  If `policyp` is not `NULL`, the
## /// stores network policy is stored there.
## /

proc sq_store_iter_next*(iter: sq_store_iter_t; domainp: cstringArray;
                        namep: cstringArray; policyp: ptr uint8): sq_store_t {.sequioa.}
## /
## /// Frees a sq_store_iter_t.
## /

proc sq_store_iter_free*(iter: sq_store_iter_t) {.sequioa.}
## /
## /// Iterates over bindings in a store.
## /

type
  sq_binding_iter_t* = pointer

## /
## /// Returns the next binding.
## ///
## /// Returns `NULL` on exhaustion.  If `labelp` is not `NULL`, the
## /// bindings label is stored there.  If `fpp` is not `NULL`, the
## /// bindings fingerprint is stored there.
## /

proc sq_binding_iter_next*(iter: sq_binding_iter_t; labelp: cstringArray;
                           fpp: ptr sq_fingerprint_t): sq_binding_t {.sequioa.}
## /
## /// Frees a sq_binding_iter_t.
## /

proc sq_binding_iter_free*(iter: sq_binding_iter_t) {.sequioa.}
## /
## /// Iterates over keys in the common key pool.
## /

type
  sq_key_iter_t* = pointer

## /
## /// Returns the next key.
## ///
## /// Returns `NULL` on exhaustion.  If `fpp` is not `NULL`, the keys
## /// fingerprint is stored there.
## /

proc sq_key_iter_next*(iter: sq_key_iter_t; fpp: ptr sq_fingerprint_t): sq_key_t {.sequioa.}
## /
## /// Frees a sq_key_iter_t.
## /

proc sq_key_iter_free*(iter: sq_key_iter_t) {.sequioa.}
## /
## /// Iterates over logs.
## /

type
  sq_log_iter_t* = pointer

## /
## /// Returns the next log entry.
## ///
## /// Returns `NULL` on exhaustion.
## /

proc sq_log_iter_next*(iter: sq_log_iter_t): sq_log_t {.sequioa.}
## /
## /// Frees a sq_log_iter_t.
## /

proc sq_log_iter_free*(iter: sq_log_iter_t) {.sequioa.}
## /
## /// Lists all log entries.
## /

proc sq_store_server_log*(ctx: sq_context_t): sq_log_iter_t {.sequioa.}
## /
## /// Lists all keys in the common key pool.
## /

proc sq_store_list_keys*(ctx: sq_context_t): sq_key_iter_t {.sequioa.}
## /
## /// Opens a store.
## ///
## /// Opens a store with the given name.  If the store does not
## /// exist, it is created.  Stores are handles for objects
## /// maintained by a background service.  The background service
## /// associates state with this name.
## ///
## /// The store updates TPKs in compliance with the network policy
## /// of the context that created the store in the first place.
## /// Opening the store with a different network policy is
## /// forbidden.
## /

proc sq_store_open*(ctx: sq_context_t; name: cstring): sq_store_t {.sequioa.}
## /
## /// Adds a key identified by fingerprint to the store.
## /

proc sq_store_add*(ctx: sq_context_t; store: sq_store_t; label: cstring;
                   fp: sq_fingerprint_t): sq_binding_t {.sequioa.}
## /
## /// Imports a key into the store.
## /

proc sq_store_import*(ctx: sq_context_t; store: sq_store_t; label: cstring;
                      tpk: sq_tpk_t): sq_tpk_t {.sequioa.}
## /
## /// Returns the binding for the given label.
## /

proc sq_store_lookup*(ctx: sq_context_t; store: sq_store_t; label: cstring): sq_binding_t {.sequioa.}
## /
## /// Deletes this store.
## ///
## /// Consumes `store`.  Returns != 0 on error.
## /

proc sq_store_delete*(store: sq_store_t): sq_status_t {.sequioa.}
## /
## /// Lists all bindings.
## /

proc sq_store_iter*(ctx: sq_context_t; store: sq_store_t): sq_binding_iter_t {.sequioa.}
## /
## /// Lists all log entries related to this store.
## /

proc sq_store_log*(ctx: sq_context_t; store: sq_store_t): sq_log_iter_t {.sequioa.}
## /
## /// Returns the `sq_stats_t` of this binding.
## /

proc sq_binding_stats*(ctx: sq_context_t; binding: sq_binding_t): sq_stats_t {.sequioa.}
## /
## /// Returns the `sq_key_t` of this binding.
## /

proc sq_binding_key*(ctx: sq_context_t; binding: sq_binding_t): sq_key_t {.sequioa.}
## /
## /// Returns the `sq_tpk_t` of this binding.
## /

proc sq_binding_tpk*(ctx: sq_context_t; binding: sq_binding_t): sq_tpk_t {.sequioa.}
## /
## /// Updates this binding with the given TPK.
## ///
## /// If the new key `tpk` matches the current key, i.e. they have
## /// the same fingerprint, both keys are merged and normalized.
## /// The returned key contains all packets known to Sequoia, and
## /// should be used instead of `tpk`.
## ///
## /// If the new key does not match the current key, but carries a
## /// valid signature from the current key, it replaces the current
## /// key.  This provides a natural way for key rotations.
## ///
## /// If the new key does not match the current key, and it does not
## /// carry a valid signature from the current key, an
## /// `Error::Conflict` is returned, and you have to resolve the
## /// conflict, either by ignoring the new key, or by using
## /// `sq_binding_rotate` to force a rotation.
## /

proc sq_binding_import*(ctx: sq_context_t; binding: sq_binding_t; tpk: sq_tpk_t): sq_tpk_t {.sequioa.}
## /
## /// Forces a keyrotation to the given TPK.
## ///
## /// The current key is replaced with the new key `tpk`, even if
## /// they do not have the same fingerprint.  If a key with the same
## /// fingerprint as `tpk` is already in the store, is merged with
## /// `tpk` and normalized.  The returned key contains all packets
## /// known to Sequoia, and should be used instead of `tpk`.
## ///
## /// Use this function to resolve conflicts returned from
## /// `sq_binding_import`.  Make sure that you have authenticated
## /// `tpk` properly.  How to do that depends on your thread model.
## /// You could simply ask Alice to call her communication partner
## /// Bob and confirm that he rotated his keys.
## /

proc sq_binding_rotate*(ctx: sq_context_t; binding: sq_binding_t; tpk: sq_tpk_t): sq_tpk_t {.sequioa.}
## /
## /// Deletes this binding.
## ///
## /// Consumes `binding`.  Returns != 0 on error.
## /

proc sq_binding_delete*(binding: sq_binding_t): sq_status_t {.sequioa.}
## /
## /// Lists all log entries related to this binding.
## /

proc sq_binding_log*(ctx: sq_context_t; binding: sq_binding_t): sq_log_iter_t {.sequioa.}
## /
## /// Returns the `sq_stats_t` of this key.
## /

proc sq_key_stats*(ctx: sq_context_t; key: sq_key_t): sq_stats_t {.sequioa.}
## /
## /// Returns the `sq_tpk_t` of this key.
## /

proc sq_key_tpk*(ctx: sq_context_t; key: sq_key_t): sq_tpk_t {.sequioa.}
## /
## /// Updates this stored key with the given TPK.
## ///
## /// If the new key `tpk` matches the current key, i.e. they have
## /// the same fingerprint, both keys are merged and normalized.
## /// The returned key contains all packets known to Sequoia, and
## /// should be used instead of `tpk`.
## ///
## /// If the new key does not match the current key,
## /// `Error::Conflict` is returned.
## /

proc sq_key_import*(ctx: sq_context_t; key: sq_key_t; tpk: sq_tpk_t): sq_tpk_t {.sequioa.}
## /
## /// Lists all log entries related to this key.
## /

proc sq_key_log*(ctx: sq_context_t; key: sq_key_t): sq_log_iter_t {.sequioa.}
