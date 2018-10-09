## /
## /// For accessing keyservers using HKP.
## /

type
  sq_keyserver_t* = pointer

## /
## /// Returns a handle for the given URI.
## ///
## /// `uri` is a UTF-8 encoded value of a keyserver URI,
## /// e.g. `hkps://examle.org`.
## ///
## /// Returns `NULL` on errors.
## /

proc sq_keyserver_new*(ctx: sq_context_t; uri: cstring): sq_keyserver_t {.sequioa.}
## /
## /// Returns a handle for the given URI.
## ///
## /// `uri` is a UTF-8 encoded value of a keyserver URI,
## /// e.g. `hkps://examle.org`.  `cert` is a DER encoded certificate of
## /// size `len` used to authenticate the server.
## ///
## /// Returns `NULL` on errors.
## /

proc sq_keyserver_with_cert*(ctx: sq_context_t; uri: cstring; cert: ptr uint8;
                             len: int): sq_keyserver_t {.sequioa.}
## /
## /// Returns a handle for the SKS keyserver pool.
## ///
## /// The pool `hkps://hkps.pool.sks-keyservers.net` provides HKP
## /// services over https.  It is authenticated using a certificate
## /// included in this library.  It is a good default choice.
## ///
## /// Returns `NULL` on errors.
## /

proc sq_keyserver_sks_pool*(ctx: sq_context_t): sq_keyserver_t {.sequioa.}
## /
## /// Frees a keyserver object.
## /

proc sq_keyserver_free*(ks: sq_keyserver_t) {.sequioa.}
## /
## /// Retrieves the key with the given `keyid`.
## ///
## /// Returns `NULL` on errors.
## /

proc sq_keyserver_get*(ctx: sq_context_t; ks: sq_keyserver_t; id: sq_keyid_t): sq_tpk_t {.sequioa.}
## /
## /// Sends the given key to the server.
## ///
## /// Returns != 0 on errors.
## /

proc sq_keyserver_send*(ctx: sq_context_t; ks: sq_keyserver_t; tpk: sq_tpk_t): sq_status_t {.sequioa.}
