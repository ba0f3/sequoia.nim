##  sequoia::Context.
## /
## /// A `struct sq_context *` is required for many operations.
## ///
## /// # Example
## ///
## /// ```c
## /// struct sq_context *ctx sq_context_new("org.sequoia-pgp.example");
## /// if (ctx == NULL) { ... }
## /// ```
## /

type
  sq_context_t* {.pure.} = pointer

## /
## /// Returns the last error.
## ///
## /// Returns and removes the last error from the context.
## /

proc sq_context_last_error*(ctx: sq_context_t): sq_error_t {.sequioa.}
## /
## /// Frees a string returned from Sequoia.
## /

proc sq_string_free*(s: cstring) {.sequioa.}
## /
## /// Represents a `Context` configuration.
## /

type
  sq_config_t* = pointer

## /
## /// Network policy for Sequoia.
## ///
## /// With this policy you can control how Sequoia accesses remote
## /// systems.
## /

type                          ##  Do not contact remote systems.
  sq_network_policy_t* = enum
    SQ_NETWORK_POLICY_OFFLINE = 0, ##  Only contact remote systems using anonymization techniques like
                                ##  TOR.
    SQ_NETWORK_POLICY_ANONYMIZED = 1, ##  Only contact remote systems using transports offering
                                   ##  encryption and authentication like TLS.
    SQ_NETWORK_POLICY_ENCRYPTED = 2, ##  Contact remote systems even with insecure transports.
    SQ_NETWORK_POLICY_INSECURE = 3, ##  Dummy value to make sure the enumeration has a defined size.  Do
                                 ##      not use this value.
    SQ_NETWORK_POLICY_FORCE_WIDTH = high(int)


## /
## /// IPC policy for Sequoia.
## ///
## /// With this policy you can control how Sequoia starts background
## /// servers.
## /

type ## /
    ##   /// External background servers only.
    ##   ///
    ##   /// We will always use external background servers.  If starting
    ##   /// one fails, the operation will fail.
    ##   ///
    ##   /// The advantage is that we never spawn a thread.
    ##   ///
    ##   /// The disadvantage is that we need to locate the background
    ##   /// server to start.  If you are distribute Sequoia with your
    ##   /// application, make sure to include the binaries, and to
    ##   /// configure the Context so that `context.lib()` points to the
    ##   /// directory containing the binaries.
    ##   /
  sq_ipc_policy_t* = enum
    SQ_IPC_POLICY_EXTERNAL = 0, ## /
                             ##   /// Internal background servers only.
                             ##   ///
                             ##   /// We will always use internal background servers.  It is very
                             ##   /// unlikely that this fails.
                             ##   ///
                             ##   /// The advantage is that this method is very robust.  If you
                             ##   /// distribute Sequoia with your application, you do not need to
                             ##   /// ship the binary, and it does not matter what `context.lib()`
                             ##   /// points to.  This is very robust and convenient.
                             ##   ///
                             ##   /// The disadvantage is that we spawn a thread in your
                             ##   /// application.  Threads may play badly with `fork(2)`, file
                             ##   /// handles, and locks.  If you are not doing anything fancy,
                             ##   /// however, and only use fork-then-exec, you should be okay.
                             ##   /
    SQ_IPC_POLICY_INTERNAL = 1, ## /
                             ##   /// Prefer external, fall back to internal.
                             ##   ///
                             ##   /// We will first try to use an external background server, but
                             ##   /// fall back on an internal one should that fail.
                             ##   ///
                             ##   /// The advantage is that if Sequoia is properly set up to find
                             ##   /// the background servers, we will use these and get the
                             ##   /// advantages of that approach.  Because we fail back on using an
                             ##   /// internal server, we gain the robustness of that approach.
                             ##   ///
                             ##   /// The disadvantage is that we may or may not spawn a thread in
                             ##   /// your application.  If this is unacceptable in your
                             ##   /// environment, use the `External` policy.
                             ##   /
    SQ_IPC_POLICY_ROBUST = 2, ##  Dummy value to make sure the enumeration has a defined size.  Do
                           ##      not use this value.
    SQ_IPC_POLICY_FORCE_WIDTH = high(int)


## /
## /// Creates a Context with reasonable defaults.
## ///
## /// `domain` should uniquely identify your application, it is strongly
## /// suggested to use a reversed fully qualified domain name that is
## /// associated with your application.  `domain` must not be `NULL`.
## ///
## /// Returns `NULL` on errors.  If `errp` is not `NULL`, the error is
## /// stored there.
## /

proc sq_context_new*(domain: cstring; errp: ptr sq_error_t): sq_context_t {.sequioa.}
## /
## /// Frees a context.
## /

proc sq_context_free*(context: sq_context_t) {.sequioa.}
## /
## /// Creates a Context that can be configured.
## ///
## /// `domain` should uniquely identify your application, it is strongly
## /// suggested to use a reversed fully qualified domain name that is
## /// associated with your application.  `domain` must not be `NULL`.
## ///
## /// The configuration is seeded like in `sq_context_new`, but can be
## /// modified.  A configuration has to be finalized using
## /// `sq_config_build()` in order to turn it into a Context.
## /

proc sq_context_configure*(domain: cstring): sq_config_t {.sequioa.}
## /
## /// Returns the domain of the context.
## /

proc sq_context_domain*(ctx: sq_context_t): cstring {.sequioa.}
## /
## /// Returns the directory containing shared state.
## /

proc sq_context_home*(ctx: sq_context_t): cstring {.sequioa.}
## /
## /// Returns the directory containing backend servers.
## /

proc sq_context_lib*(ctx: sq_context_t): cstring {.sequioa.}
## /
## /// Returns the network policy.
## /

proc sq_context_network_policy*(ctx: sq_context_t): sq_network_policy_t {.sequioa.}
## /
## /// Returns the IPC policy.
## /

proc sq_context_ipc_policy*(ctx: sq_context_t): sq_ipc_policy_t {.sequioa.}
## /
## /// Returns whether or not this is an ephemeral context.
## /

proc sq_context_ephemeral*(ctx: sq_context_t): uint8 {.sequioa.}
##  sequoia::Config.
## /
## /// Finalizes the configuration and return a `Context`.
## ///
## /// Consumes `cfg`.  Returns `NULL` on errors. Returns `NULL` on
## /// errors.  If `errp` is not `NULL`, the error is stored there.
## /

proc sq_config_build*(cfg: sq_config_t; errp: ptr sq_error_t): sq_context_t {.sequioa.}
## /
## /// Sets the directory containing shared state.
## /

proc sq_config_home*(cfg: sq_config_t; home: cstring) {.sequioa.}
## /
## /// Sets the directory containing backend servers.
## /

proc sq_config_lib*(cfg: sq_config_t; lib: cstring) {.sequioa.}
## /
## /// Sets the network policy.
## /

proc sq_config_network_policy*(cfg: sq_config_t; policy: sq_network_policy_t) {.sequioa.}
## /
## /// Sets the IPC policy.
## /

proc sq_config_ipc_policy*(cfg: sq_config_t; policy: sq_ipc_policy_t) {.sequioa.}
## /
## /// Makes this context ephemeral.
## /

proc sq_config_ephemeral*(cfg: sq_config_t) {.sequioa.}
##  Reader and writer.
## /
## /// A generic reader.
## /

type
  sq_reader_t* = pointer

## /
## /// Opens a file returning a reader.
## /

proc sq_reader_from_file*(ctx: sq_context_t; filename: cstring): sq_reader_t {.sequioa.}
## /
## /// Opens a file descriptor returning a reader.
## /

proc sq_reader_from_fd*(fd: cint): sq_reader_t {.sequioa.}
## /
## /// Creates a reader from a buffer.
## /

proc sq_reader_from_bytes*(buf: ptr uint8; len: int): sq_reader_t {.sequioa.}
## /
## /// Frees a reader.
## /

proc sq_reader_free*(reader: sq_reader_t) {.sequioa.}
## /
## /// Reads up to `len` bytes into `buf`.
## /

proc sq_reader_read*(ctx: sq_context_t; reader: sq_reader_t; buf: ptr uint8;
                     len: int): int {.sequioa.}
## /
## /// A generic writer.
## /

type
  sq_writer_t* = pointer

## /
## /// Opens a file returning a writer.
## ///
## /// The file will be created if it does not exist, or be truncated
## /// otherwise.  If you need more control, use `sq_writer_from_fd`.
## /

proc sq_writer_from_file*(ctx: sq_context_t; filename: cstring): sq_writer_t {.sequioa.}
## /
## /// Opens a file descriptor returning a writer.
## /

proc sq_writer_from_fd*(fd: cint): sq_writer_t {.sequioa.}
## /
## /// Creates a writer from a buffer.
## /

proc sq_writer_from_bytes*(buf: ptr uint8; len: int): sq_writer_t {.sequioa.}
## /
## /// Creates an allocating writer.
## ///
## /// This writer allocates memory using `malloc`, and stores the
## /// pointer to the memory and the number of bytes written to the given
## /// locations `buf`, and `len`.  Both must either be set to zero, or
## /// reference a chunk of memory allocated using libc's heap allocator.
## /// The caller is responsible to `free` it once the writer has been
## /// destroyed.
## /

proc sq_writer_alloc*(buf: ptr pointer; len: ptr int): sq_writer_t {.sequioa.}
## /
## /// Frees a writer.
## /

proc sq_writer_free*(writer: sq_writer_t) {.sequioa.}
## /
## /// Writes up to `len` bytes of `buf` into `writer`.
## /

proc sq_writer_write*(ctx: sq_context_t; writer: sq_writer_t; buf: ptr uint8;
                      len: int): int {.sequioa.}
