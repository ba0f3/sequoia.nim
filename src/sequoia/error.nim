##  XXX: Reorder and name-space before release.

type                          ## /
    ##   /// The operation was successful.
    ##   /
  sq_status_t* = enum
    SQ_STATUS_MANIPULATED_MESSAGE = -25, ## /
                                      ##   /// Malformed message.
                                      ##   /
    SQ_STATUS_UNSUPPORTED_TPK = -24, ##  Dummy value to make sure the enumeration has a defined size.  Do
                                  ##      not use this value.
    SQ_STATUS_INDEX_OUT_OF_RANGE = -23, ## /
                                                                   ##   /// TPK not supported.
                                                                   ##   /
    SQ_STATUS_MALFORMED_MESSAGE = -22, ## /
                                    ##   /// Index out of range.
                                    ##   /
    SQ_STATUS_UNSUPPORTED_ELLIPTIC_CURVE = -21, ## /
                                             ##   /// Unsupported symmetric algorithm.
                                             ##   /
    SQ_STATUS_UNSUPPORTED_SIGNATURE_TYPE = -20, ## /
                                             ##   /// Invalid password.
                                             ##   /
    SQ_STATUS_BAD_SIGNATURE = -19, ## /
                                ##   /// Message has been manipulated.
                                ##   /
    SQ_STATUS_UNSUPPORTED_PUBLICKEY_ALGORITHM = -18, ## /
                                                  ##   /// Unsupported elliptic curve.
                                                  ##   /
    SQ_STATUS_UNKNOWN_PUBLICKEY_ALGORITHM = -17, ## /
                                              ##   /// Unknown symmetric algorithm.
                                              ##   /
    SQ_STATUS_INVALID_ARGUMENT = -15, ## /
                                   ##   /// The requested operation is invalid.
                                   ##   /
    SQ_STATUS_MALFORMED_TPK = -13, ## /
                                ##   /// Bad signature.
                                ##   /
    SQ_STATUS_INVALID_SESSION_KEY = -12, ## /
                                      ##   /// Malformed TPK.
                                      ##   /
    SQ_STATUS_INVALID_PASSWORD = -11, ## /
                                   ##   /// Invalid session key.
                                   ##   /
    SQ_STATUS_UNSUPPORTED_SYMMETRIC_ALGORITHM = -10, ## /
                                                  ##   /// Unsupport signature type.
                                                  ##   /
    SQ_STATUS_UNSUPPORTED_HASH_ALGORITHM = -9, ## /
                                            ##   /// Unsupported public key algorithm.
                                            ##   /
    SQ_STATUS_UNKNOWN_SYMMETRIC_ALGORITHM = -8, ## /
                                             ##   /// Unsupported hash algorithm.
                                             ##   /
    SQ_STATUS_UNKNOWN_HASH_ALGORITHM = -7, ## /
                                        ##   /// Unknown public key algorithm.
                                        ##   /
    SQ_STATUS_UNKNOWN_PACKET_TAG = -6, ## /
                                    ##   /// Unknown hash algorithm.
                                    ##   /
    SQ_STATUS_MALFORMED_PACKET = -5, ## /
                                  ##   /// Unknown packet type.
                                  ##   /
    SQ_STATUS_INVALID_OPERATION = -4, ## /
                                   ##   /// The packet is malformed.
                                   ##   /
    SQ_STATUS_IO_ERROR = -3,    ## /
                          ##   /// A given argument is invalid.
                          ##   /
    SQ_STATUS_NETWORK_POLICY_VIOLATION = -2, ## /
                                          ##   /// An IO error occurred.
                                          ##   /
    SQ_STATUS_UNKNOWN_ERROR = -1, ## /
                               ##   /// The network policy was violated by the given action.
                               ##   /
    SQ_STATUS_SUCCESS = 0       ## /
                       ##   /// An unknown error occurred.
                       ##   /
    SQ_STATUS_FORCE_WIDTH = high(int)


## /
## /// Complex errors returned from Sequoia.
## /

type
  sq_error_t* {.pure.} = pointer

## /
## /// Frees an error.
## /

proc sq_error_free*(error: sq_error_t) {.sequioa.}
## /
## /// Returns the error message.
## ///
## /// The returned value must be freed with `sq_string_free`.
## /

proc sq_error_string*(err: sq_error_t): cstring {.sequioa.}
## /
## /// Returns the error status code.
## /

proc sq_error_status*(err: sq_error_t): sq_status_t {.sequioa.}
