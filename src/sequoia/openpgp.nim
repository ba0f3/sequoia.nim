##  sequoia::openpgp::KeyID.
## /
## /// Holds a KeyID.
## /

type
  sq_keyid_t* = pointer

## /
## /// Reads a binary key ID.
## /

proc sq_keyid_from_bytes*(id: ptr uint8): sq_keyid_t {.sequioa.}
## /
## /// Reads a hex-encoded Key ID.
## /

proc sq_keyid_from_hex*(id: cstring): sq_keyid_t {.sequioa.}
## /
## /// Frees a sq_keyid_t.
## /

proc sq_keyid_free*(keyid: sq_keyid_t) {.sequioa.}
## /
## /// Clones the KeyID.
## /

proc sq_keyid_clone*(keyid: sq_keyid_t): sq_keyid_t {.sequioa.}
## /
## /// Hashes the KeyID.
## /

proc sq_keyid_hash*(keyid: sq_keyid_t): uint64 {.sequioa.}
## /
## /// Converts the KeyID to its standard representation.
## /

proc sq_keyid_to_string*(fp: sq_keyid_t): cstring {.sequioa.}
## /
## /// Converts the KeyID to a hexadecimal number.
## /

proc sq_keyid_to_hex*(fp: sq_keyid_t): cstring {.sequioa.}
## /
## /// Compares KeyIDs.
## /

proc sq_keyid_equal*(a: sq_keyid_t; b: sq_keyid_t): cint {.sequioa.}
##  sequoia::openpgp::Fingerprint.
## /
## /// Holds a fingerprint.
## /

type
  sq_fingerprint_t* = pointer

## /
## /// Reads a binary fingerprint.
## /

proc sq_fingerprint_from_bytes*(buf: ptr uint8; len: csize): sq_fingerprint_t {.sequioa.}
## /
## /// Reads a hexadecimal fingerprint.
## /

proc sq_fingerprint_from_hex*(hex: cstring): sq_fingerprint_t {.sequioa.}
## /
## /// Frees a sq_fingerprint_t.
## /

proc sq_fingerprint_free*(fp: sq_fingerprint_t) {.sequioa.}
## /
## /// Clones the Fingerprint.
## /

proc sq_fingerprint_clone*(fingerprint: sq_fingerprint_t): sq_fingerprint_t {.sequioa.}
## /
## /// Hashes the Fingerprint.
## /

proc sq_fingerprint_hash*(fingerprint: sq_fingerprint_t): uint64 {.sequioa.}
## /
## /// Returns a reference to the raw Fingerprint.
## ///
## /// This returns a reference to the internal buffer that is valid as
## /// long as the fingerprint is.
## /

proc sq_fingerprint_as_bytes*(fp: sq_fingerprint_t; fp_len: ptr csize): ptr uint8 {.sequioa.}
## /
## /// Converts the fingerprint to its standard representation.
## /

proc sq_fingerprint_to_string*(fp: sq_fingerprint_t): cstring {.sequioa.}
## /
## /// Converts the fingerprint to a hexadecimal number.
## /

proc sq_fingerprint_to_hex*(fp: sq_fingerprint_t): cstring {.sequioa.}
## /
## /// Converts the fingerprint to a key ID.
## /

proc sq_fingerprint_to_keyid*(fp: sq_fingerprint_t): sq_keyid_t {.sequioa.}
## /
## /// Compares Fingerprints.
## /

proc sq_fingerprint_equal*(a: sq_fingerprint_t; b: sq_fingerprint_t): cint {.sequioa.}
##  openpgp::armor.
## /
## /// Specifies the type of data (see [RFC 4880, section 6.2]).
## ///
## /// [RFC 4880, section 6.2]: https://tools.ietf.org/html/rfc4880#section-6.2
## /

type ## /
    ##   /// When reading an Armored file, accept any type.
    ##   /
  sq_armor_kind_t* = enum
    SQ_ARMOR_KIND_ANY,        ## /
                      ##   /// A generic OpenPGP message.
                      ##   /
    SQ_ARMOR_KIND_MESSAGE,    ## /
                          ##   /// A transferable public key.
                          ##   /
    SQ_ARMOR_KIND_PUBLICKEY,  ## /
                            ##   /// A transferable secret key.
                            ##   /
    SQ_ARMOR_KIND_SECRETKEY,  ## /
                            ##   /// A detached signature.
                            ##   /
    SQ_ARMOR_KIND_SIGNATURE,  ## /
                            ##   /// A generic file.  This is a GnuPG extension.
                            ##   /
    SQ_ARMOR_KIND_FILE, ##  Dummy value to make sure the enumeration has a defined size.  Do
                       ##      not use this value.
    SQ_ARMOR_KIND_FORCE_WIDTH = high(int)


## /
## /// Represents a (key, value) pair in an armor header.
## /

type
  sq_armor_header_t* {.bycopy.} = object
    key*: cstring
    value*: cstring


## /
## /// Constructs a new filter for the given type of data.
## ///
## /// A filter that strips ASCII Armor from a stream of data.
## /

proc sq_armor_reader_new*(inner: sq_reader_t; kind: sq_armor_kind_t): sq_reader_t {.sequioa.}
## /
## /// Creates a `Reader` from a file.
## /

proc sq_armor_reader_from_file*(ctx: sq_context_t; filename: cstring;
                                kind: sq_armor_kind_t): sq_reader_t {.sequioa.}
## /
## /// Creates a `Reader` from a buffer.
## /

proc sq_armor_reader_from_bytes*(b: ptr uint8; len: csize; kind: sq_armor_kind_t): sq_reader_t {.sequioa.}
## /
## /// Returns the kind of data this reader is for.
## ///
## /// Useful if the kind of data is not known in advance.  If the header
## /// has not been encountered yet (try reading some data first!), this
## /// function returns SQ_ARMOR_KIND_ANY.
## /

proc sq_armor_reader_kind*(reader: sq_reader_t): sq_armor_kind_t {.sequioa.}
## /
## /// Returns the armored headers.
## ///
## /// The tuples contain a key and a value.
## ///
## /// Note: if a key occurs multiple times, then there are multiple
## /// entries in the vector with the same key; values with the same
## /// key are *not* combined.
## ///
## /// The returned array and the strings in the headers have been
## /// allocated with `malloc`, and the caller is responsible for freeing
## /// both the array and the strings.
## /

proc sq_armor_reader_headers*(ctx: sq_context_t; reader: sq_reader_t; len: ptr csize): ptr sq_armor_header_t {.sequioa.}
## /
## /// Constructs a new filter for the given type of data.
## ///
## /// A filter that applies ASCII Armor to the data written to it.
## /

proc sq_armor_writer_new*(ctx: sq_context_t; inner: sq_writer_t;
                         kind: sq_armor_kind_t; header: ptr sq_armor_header_t;
                          header_len: csize): sq_writer_t {.sequioa.}
##  openpgp::PacketPile.
## /
## /// A `PacketPile` holds a deserialized OpenPGP message.
## /

type
  sq_packet_pile_t* = pointer

## /
## /// Deserializes the OpenPGP message stored in a `std::io::Read`
## /// object.
## ///
## /// Although this method is easier to use to parse an OpenPGP
## /// packet pile than a `PacketParser` or a `PacketPileParser`, this
## /// interface buffers the whole packet pile in memory.  Thus, the
## /// caller must be certain that the *deserialized* packet pile is not
## /// too large.
## ///
## /// Note: this interface *does* buffer the contents of packets.
## /

proc sq_packet_pile_from_reader*(ctx: sq_context_t; reader: sq_reader_t): sq_packet_pile_t {.sequioa.}
## /
## /// Deserializes the OpenPGP packet pile stored in the file named by
## /// `filename`.
## ///
## /// See `sq_packet_pile_from_reader` for more details and caveats.
## /

proc sq_packet_pile_from_file*(ctx: sq_context_t; filename: cstring): sq_packet_pile_t {.sequioa.}
## /
## /// Deserializes the OpenPGP packet pile stored in the provided buffer.
## ///
## /// See `sq_packet_pile_from_reader` for more details and caveats.
## /

proc sq_packet_pile_from_bytes*(ctx: sq_context_t; b: ptr uint8; len: csize): sq_packet_pile_t {.sequioa.}
## /
## /// Frees the packet pile.
## /

proc sq_packet_pile_free*(message: sq_packet_pile_t) {.sequioa.}
## /
## /// Clones the packet pile.
## /

proc sq_packet_pile_clone*(message: sq_packet_pile_t): sq_packet_pile_t {.sequioa.}
## /
## /// Serializes the packet pile.
## /

proc sq_packet_pile_serialize*(ctx: sq_context_t; message: sq_packet_pile_t;
                               writer: sq_writer_t): sq_status_t {.sequioa.}
##  openpgp::tpk.
## /
## /// A transferable public key (TPK).
## ///
## /// A TPK (see [RFC 4880, section 11.1]) can be used to verify
## /// signatures and encrypt data.  It can be stored in a keystore and
## /// uploaded to keyservers.
## ///
## /// [RFC 4880, section 11.1]: https://tools.ietf.org/html/rfc4880#section-11.1
## /

type
  sq_tpk_t* = pointer

## /
## /// A transferable secret key (TSK).
## ///
## /// A TSK (see [RFC 4880, section 11.2]) can be used to create
## /// signatures and decrypt data.
## ///
## /// [RFC 4880, section 11.2]: https://tools.ietf.org/html/rfc4880#section-11.2
## /

type
  sq_tsk_t* = pointer

## /
## /// Returns the first TPK encountered in the reader.
## /

proc sq_tpk_from_reader*(ctx: sq_context_t; reader: sq_reader_t): sq_tpk_t {.sequioa.}
## /
## /// Returns the first TPK encountered in the file.
## /

proc sq_tpk_from_file*(ctx: sq_context_t; filename: cstring): sq_tpk_t {.sequioa.}
## /
## /// Returns the first TPK found in `m`.
## ///
## /// Consumes `m`.
## /

proc sq_tpk_from_packet_pile*(ctx: sq_context_t; m: sq_packet_pile_t): sq_tpk_t {.sequioa.}
## /
## /// Returns the first TPK found in `buf`.
## ///
## /// `buf` must be an OpenPGP-encoded TPK.
## /

proc sq_tpk_from_bytes*(ctx: sq_context_t; b: ptr uint8; len: csize): sq_tpk_t {.sequioa.}
## /
## /// Frees the TPK.
## /

proc sq_tpk_free*(tpk: sq_tpk_t) {.sequioa.}
## /
## /// Clones the TPK.
## /

proc sq_tpk_clone*(tpk: sq_tpk_t): sq_tpk_t {.sequioa.}
## /
## /// Compares TPKs.
## /

proc sq_tpk_equal*(a: sq_tpk_t; b: sq_tpk_t): cint {.sequioa.}
## /
## /// Serializes the TPK.
## /

proc sq_tpk_serialize*(ctx: sq_context_t; tpk: sq_tpk_t; writer: sq_writer_t): sq_status_t {.sequioa.}
## /
## /// Merges `other` into `tpk`.
## ///
## /// If `other` is a different key, then nothing is merged into
## /// `tpk`, but `tpk` is still canonicalized.
## ///
## /// Consumes `tpk` and `other`.
## /

proc sq_tpk_merge*(ctx: sq_context_t; tpk: sq_tpk_t; other: sq_tpk_t): sq_tpk_t {.sequioa.}
## /
## /// Dumps the TPK.
## /

proc sq_tpk_dump*(tpk: sq_tpk_t) {.sequioa.}
## /
## /// Returns the fingerprint.
## /

proc sq_tpk_fingerprint*(tpk: sq_tpk_t): sq_fingerprint_t {.sequioa.}
## /
## /// Cast the public key into a secret key that allows using the secret
## /// parts of the containing keys.
## /

proc sq_tpk_into_tsk*(tpk: sq_tpk_t): sq_tsk_t {.sequioa.}
##  TPKBuilder

type ## /
    ##   /// EdDSA and ECDH over Curve25519 with SHA512 and AES256.
    ##   /
  sq_tpk_builder_t* = pointer
  sq_tpk_cipher_suite_t* = enum
    SQ_TPK_CIPHER_SUITE_CV25519, ## /
                                ##   /// 3072 bit RSA with SHA512 and AES256.
                                ##   /
    SQ_TPK_CIPHER_SUITE_RSA3K, ##  Dummy value to make sure the enumeration has a defined size.  Do
                              ##      not use this value.
    SQ_TPK_CIPHER_SUITE_FORCE_WIDTH = high(int)


## /
## /// Creates a default `sq_tpk_builder_t`.
## /

proc sq_tpk_builder_default*(): sq_tpk_builder_t {.sequioa.}
## /
## /// Generates a key compliant to [Autocrypt Level 1].
## ///
## ///   [Autocrypt Level 1]: https://autocrypt.org/level1.html
## /

proc sq_tpk_builder_autocrypt*(): sq_tpk_builder_t {.sequioa.}
## /
## /// Frees an `sq_tpk_builder_t`.
## /

proc sq_tpk_builder_free*(tpkb: sq_tpk_builder_t) {.sequioa.}
## /
## /// Sets the encryption and signature algorithms for primary and all
## /// subkeys.
## /

proc sq_tpk_builder_set_cipher_suite*(tpkb: ptr sq_tpk_builder_t;
                                      cs: sq_tpk_cipher_suite_t) {.sequioa.}
## /
## /// Adds a new user ID. The first user ID added replaces the default
## /// ID that is just the empty string.
## /

proc sq_tpk_builder_add_userid*(tpkb: ptr sq_tpk_builder_t; uid: cstring) {.sequioa.}
## /
## /// Adds a signing capable subkey.
## /

proc sq_tpk_builder_add_signing_subkey*(tpkb: ptr sq_tpk_builder_t) {.sequioa.}
## /
## /// Adds an encryption capable subkey.
## /

proc sq_tpk_builder_add_encryption_subkey*(tpkb: ptr sq_tpk_builder_t) {.sequioa.}
## /
## /// Adds an certification capable subkey.
## /

proc sq_tpk_builder_add_certification_subkey*(tpkb: ptr sq_tpk_builder_t) {.sequioa.}
## /
## /// Generates the actual TPK.
## ///
## /// Consumes `tpkb`.
## /

proc sq_tpk_builder_generate*(ctx: sq_context_t; tpkb: sq_tpk_builder_t): sq_tpk_t {.sequioa.}
##  TSK
## /
## /// Generates a new RSA 3072 bit key with UID `primary_uid`.
## /

proc sq_tsk_new*(ctx: sq_context_t; primary_uid: cstring): sq_tsk_t {.sequioa.}
## /
## /// Frees the TSK.
## /

proc sq_tsk_free*(tsk: sq_tsk_t) {.sequioa.}
## /
## /// Returns a reference to the corresponding TPK.
## /

proc sq_tsk_tpk*(tsk: sq_tsk_t): sq_tpk_t {.sequioa.}
## /
## /// Serializes the TSK.
## /

proc sq_tsk_serialize*(ctx: sq_context_t; tsk: sq_tsk_t; writer: sq_writer_t): sq_status_t {.sequioa.}
## /
## /// The OpenPGP packet tags as defined in [Section 4.3 of RFC 4880].
## ///
## ///   [Section 4.3 of RFC 4880]: https://tools.ietf.org/html/rfc4880#section-4.3
## ///
## /// The values correspond to the serialized format.  The packet types
## /// named `UnassignedXX` are not in use as of RFC 4880.
## ///
## /// Use [`Tag::from_numeric`] to translate a numeric value to a symbolic
## /// one.
## ///
## ///   [`Tag::from_numeric`]: enum.Tag.html#method.from_numeric
## /

type
  sq_tag_t* = enum
    SQ_TAG_RESERVED0 = 0,       ##  Public-Key Encrypted Session Key Packet.
    SQ_TAG_PKESK = 1, SQ_TAG_SIGNATURE = 2, ##  Symmetric-Key Encrypted Session Key Packet.
    SQ_TAG_SKESK = 3,           ##  One-Pass Signature Packet.
    SQ_TAG_ONE_PASS_SIG = 4, SQ_TAG_SECRET_KEY = 5, SQ_TAG_PUBLIC_KEY = 6,
    SQ_TAG_SECRET_SUBKEY = 7, SQ_TAG_COMPRESSED_DATA = 8, ##  Symmetrically Encrypted Data Packet.
    SQ_TAG_SED = 9, SQ_TAG_MARKER = 10, SQ_TAG_LITERAL = 11, SQ_TAG_TRUST = 12,
    SQ_TAG_USER_ID = 13, SQ_TAG_PUBLIC_SUBKEY = 14, SQ_TAG_UNASSIGNED15 = 15,
    SQ_TAG_UNASSIGNED16 = 16, SQ_TAG_USER_ATTRIBUTE = 17, ##  Sym. Encrypted and Integrity Protected Data Packet.
    SQ_TAG_SEIP = 18,           ##  Modification Detection Code Packet.
    SQ_TAG_MDC = 19,            ##  Unassigned packets (as of RFC4880).
    SQ_TAG_UNASSIGNED20 = 20, SQ_TAG_UNASSIGNED21 = 21, SQ_TAG_UNASSIGNED22 = 22,
    SQ_TAG_UNASSIGNED23 = 23, SQ_TAG_UNASSIGNED24 = 24, SQ_TAG_UNASSIGNED25 = 25,
    SQ_TAG_UNASSIGNED26 = 26, SQ_TAG_UNASSIGNED27 = 27, SQ_TAG_UNASSIGNED28 = 28,
    SQ_TAG_UNASSIGNED29 = 29, SQ_TAG_UNASSIGNED30 = 30, SQ_TAG_UNASSIGNED31 = 31,
    SQ_TAG_UNASSIGNED32 = 32, SQ_TAG_UNASSIGNED33 = 33, SQ_TAG_UNASSIGNED34 = 34,
    SQ_TAG_UNASSIGNED35 = 35, SQ_TAG_UNASSIGNED36 = 36, SQ_TAG_UNASSIGNED37 = 37,
    SQ_TAG_UNASSIGNED38 = 38, SQ_TAG_UNASSIGNED39 = 39, SQ_TAG_UNASSIGNED40 = 40,
    SQ_TAG_UNASSIGNED41 = 41, SQ_TAG_UNASSIGNED42 = 42, SQ_TAG_UNASSIGNED43 = 43,
    SQ_TAG_UNASSIGNED44 = 44, SQ_TAG_UNASSIGNED45 = 45, SQ_TAG_UNASSIGNED46 = 46,
    SQ_TAG_UNASSIGNED47 = 47, SQ_TAG_UNASSIGNED48 = 48, SQ_TAG_UNASSIGNED49 = 49,
    SQ_TAG_UNASSIGNED50 = 50, SQ_TAG_UNASSIGNED51 = 51, SQ_TAG_UNASSIGNED52 = 52,
    SQ_TAG_UNASSIGNED53 = 53, SQ_TAG_UNASSIGNED54 = 54, SQ_TAG_UNASSIGNED55 = 55,
    SQ_TAG_UNASSIGNED56 = 56, SQ_TAG_UNASSIGNED57 = 57, SQ_TAG_UNASSIGNED58 = 58, SQ_TAG_UNASSIGNED59 = 59, ##  Experimental packets.
    SQ_TAG_PRIVATE0 = 60, SQ_TAG_PRIVATE1 = 61, SQ_TAG_PRIVATE2 = 62,
    SQ_TAG_PRIVATE3 = 63


## /
## /// Opaque types for all the Packets that Sequoia understands.
## /

type
  sq_unknown_t* = pointer
  sq_signature_t* = pointer
  sq_one_pass_sig_t* = pointer
  sq_p_key_t* = pointer
  sq_user_id_t* = pointer
  sq_user_attribute_t* = pointer
  sq_literal_t* = pointer
  sq_compressed_data_t* = pointer
  sq_pkesk_t* = pointer
  sq_skesk_t* = pointer
  sq_seip_t* = pointer
  sq_mdc_t* = pointer

## /
## /// The OpenPGP packets that Sequoia understands.
## ///
## /// The different OpenPGP packets are detailed in [Section 5 of RFC 4880].
## ///
## /// The `Unknown` packet allows Sequoia to deal with packets that it
## /// doesn't understand.  The `Unknown` packet is basically a binary
## /// blob that includes the packet's tag.
## ///
## /// The unknown packet is also used for packets that are understood,
## /// but use unsupported options.  For instance, when the packet parser
## /// encounters a compressed data packet with an unknown compression
## /// algorithm, it returns the packet in an `Unknown` packet rather
## /// than a `CompressedData` packet.
## ///
## ///   [Section 5 of RFC 4880]: https://tools.ietf.org/html/rfc4880#section-5
## /

type
  sq_packet_t* {.bycopy.} = object {.union.}
    unknown*: sq_unknown_t
    signature*: sq_signature_t
    one_pass_sig*: sq_one_pass_sig_t
    key*: sq_p_key_t
    user_id*: sq_user_id_t
    user_attribute*: sq_user_attribute_t
    literal*: sq_literal_t
    compressed_data*: sq_compressed_data_t
    pkesk*: sq_pkesk_t
    skesk*: sq_skesk_t
    seip*: sq_seip_t
    mdc*: sq_mdc_t


## /
## /// Frees the Packet.
## /

proc sq_packet_free*(p: sq_packet_t) {.sequioa.}
## /
## /// Returns the `Packet's` corresponding OpenPGP tag.
## ///
## /// Tags are explained in [Section 4.3 of RFC 4880].
## ///
## ///   [Section 4.3 of RFC 4880]: https://tools.ietf.org/html/rfc4880#section-4.3
## /

proc sq_packet_tag*(p: sq_packet_t): sq_tag_t {.sequioa.}
## /
## /// Returns the parsed `Packet's` corresponding OpenPGP tag.
## ///
## /// Returns the packets tag, but only if it was successfully
## /// parsed into the corresponding packet type.  If e.g. a
## /// Signature Packet uses some unsupported methods, it is parsed
## /// into an `Packet::Unknown`.  `tag()` returns `SQ_TAG_SIGNATURE`,
## /// whereas `kind()` returns `0`.
## /

proc sq_packet_kind*(p: sq_packet_t): sq_tag_t {.sequioa.}
## /
## /// Computes and returns the key's fingerprint as per Section 12.2
## /// of RFC 4880.
## /

proc sq_p_key_fingerprint*(p: sq_p_key_t): sq_fingerprint_t {.sequioa.}
## /
## /// Computes and returns the key's key ID as per Section 12.2 of RFC
## /// 4880.
## /

proc sq_p_key_keyid*(p: sq_p_key_t): sq_keyid_t {.sequioa.}
## /
## /// Returns the value of the User ID Packet.
## ///
## /// The returned pointer is valid until `uid` is deallocated.  If
## /// `value_len` is not `NULL`, the size of value is stored there.
## /

proc sq_user_id_value*(uid: sq_user_id_t; value_len: ptr csize): ptr uint8 {.sequioa.}
## /
## /// Returns the value of the User Attribute Packet.
## ///
## /// The returned pointer is valid until `ua` is deallocated.  If
## /// `value_len` is not `NULL`, the size of value is stored there.
## /

proc sq_user_attribute_value*(ua: sq_user_attribute_t; value_len: ptr csize): ptr uint8 {.sequioa.}
## /
## /// Returns the session key.
## ///
## /// `key` of size `key_len` must be a buffer large enough to hold the
## /// session key.  If `key` is NULL, or not large enough, then the key
## /// is not written to it.  Either way, `key_len` is set to the size of
## /// the session key.
## /

proc sq_skesk_decrypt*(ctx: sq_context_t; skesk: sq_skesk_t; password: ptr uint8;
                      password_len: csize; algo: ptr uint8; key: ptr uint8;
                       key_len: ptr csize): sq_status_t {.sequioa.}
  ##  XXX
##  openpgp::parse.
## /
## /// A low-level OpenPGP message parser.
## ///
## /// A `PacketParser` provides a low-level, iterator-like interface to
## /// parse OpenPGP messages.
## ///
## /// For each iteration, the user is presented with a [`Packet`]
## /// corresponding to the last packet, a `PacketParser` for the next
## /// packet, and their positions within the message.
## ///
## /// Using the `PacketParser`, the user is able to configure how the
## /// new packet will be parsed.  For instance, it is possible to stream
## /// the packet's contents (a `PacketParser` implements the
## /// `std::io::Read` and the `BufferedReader` traits), buffer them
## /// within the [`Packet`], or drop them.  The user can also decide to
## /// recurse into the packet, if it is a container, instead of getting
## /// the following packet.
## /

type
  sq_packet_parser_t* = pointer

## /
## /// Like an `Option<PacketParser>`, but the `None` variant
## /// (`PacketParserEOF`) contains some summary information.
## /

type
  sq_packet_parser_result_t* = pointer

## /
## /// The `None` variant of a `PacketParserResult`.
## /

type
  sq_packet_parser_eof_t* = pointer

## /
## /// Starts parsing an OpenPGP message stored in a `sq_reader_t` object.
## /

proc sq_packet_parser_from_reader*(ctx: sq_context_t; reader: sq_reader_t): sq_packet_parser_result_t {.sequioa.}
## /
## /// Starts parsing an OpenPGP message stored in a file named `path`.
## /

proc sq_packet_parser_from_file*(ctx: sq_context_t; filename: cstring): sq_packet_parser_result_t {.sequioa.}
## /
## /// Starts parsing an OpenPGP message stored in a buffer.
## /

proc sq_packet_parser_from_bytes*(ctx: sq_context_t; b: ptr uint8; len: csize): sq_packet_parser_result_t {.sequioa.}
## /
## /// If the `PacketParserResult` contains a `PacketParser`, returns it,
## /// otherwise, returns NULL.
## ///
## /// If the `PacketParser` reached EOF, then the `PacketParserResult`
## /// contains a `PacketParserEOF` and you should use
## /// `sq_packet_parser_result_eof` to get it.
## ///
## /// If this function returns a `PacketParser`, then it consumes the
## /// `PacketParserResult` and ownership of the `PacketParser` is
## /// returned to the caller, i.e., the caller is responsible for
## /// ensuring that the `PacketParser` is freed.
## /

proc sq_packet_parser_result_packet_parser*(ppr: sq_packet_parser_result_t): sq_packet_parser_t {.sequioa.}
## /
## /// If the `PacketParserResult` contains a `PacketParserEOF`, returns
## /// it, otherwise, returns NULL.
## ///
## /// If the `PacketParser` did not yet reach EOF, then the
## /// `PacketParserResult` contains a `PacketParser` and you should use
## /// `sq_packet_parser_result_packet_parser` to get it.
## ///
## /// If this function returns a `PacketParserEOF`, then it consumes the
## /// `PacketParserResult` and ownership of the `PacketParserEOF` is
## /// returned to the caller, i.e., the caller is responsible for
## /// ensuring that the `PacketParserEOF` is freed.
## /

proc sq_packet_parser_result_eof*(ppr: sq_packet_parser_result_t): sq_packet_parser_eof_t {.sequioa.}
## /
## /// Frees the packet parser result.
## /

proc sq_packet_parser_result_free*(ppr: sq_packet_parser_result_t) {.sequioa.}
## /
## /// Frees the packet parser.
## /

proc sq_packet_parser_free*(pp: sq_packet_parser_t) {.sequioa.}
## /
## /// Frees the packet parser EOF object.
## /

proc sq_packet_parser_eof_free*(eof: sq_packet_parser_eof_t) {.sequioa.}
## /
## /// Returns a reference to the packet that is being parsed.
## /

proc sq_packet_parser_packet*(pp: sq_packet_parser_t): sq_packet_t {.sequioa.}
## /
## /// Returns the current packet's recursion depth.
## ///
## /// A top-level packet has a recursion depth of 0.  Packets in a
## /// top-level container have a recursion depth of 1, etc.
## /

proc sq_packet_parser_recursion_depth*(pp: sq_packet_parser_t): uint8 {.sequioa.}
## /
## /// Finishes parsing the current packet and starts parsing the
## /// following one.
## ///
## /// This function finishes parsing the current packet.  By
## /// default, any unread content is dropped.  (See
## /// [`PacketParsererBuilder`] for how to configure this.)  It then
## /// creates a new packet parser for the following packet.  If the
## /// current packet is a container, this function does *not*
## /// recurse into the container, but skips any packets it contains.
## /// To recurse into the container, use the [`recurse()`] method.
## ///
## ///   [`PacketParsererBuilder`]: parse/struct.PacketParserBuilder.html
## ///   [`recurse()`]: #method.recurse
## ///
## /// The return value is a tuple containing:
## ///
## ///   - A `Packet` holding the fully processed old packet;
## ///
## ///   - The old packet's recursion depth;
## ///
## ///   - A `PacketParser` holding the new packet;
## ///
## ///   - And, the recursion depth of the new packet.
## ///
## /// A recursion depth of 0 means that the packet is a top-level
## /// packet, a recursion depth of 1 means that the packet is an
## /// immediate child of a top-level-packet, etc.
## ///
## /// Since the packets are serialized in depth-first order and all
## /// interior nodes are visited, we know that if the recursion
## /// depth is the same, then the packets are siblings (they have a
## /// common parent) and not, e.g., cousins (they have a common
## /// grandparent).  This is because, if we move up the tree, the
## /// only way to move back down is to first visit a new container
## /// (e.g., an aunt).
## ///
## /// Using the two positions, we can compute the change in depth as
## /// new_depth - old_depth.  Thus, if the change in depth is 0, the
## /// two packets are siblings.  If the value is 1, the old packet
## /// is a container, and the new packet is its first child.  And,
## /// if the value is -1, the new packet is contained in the old
## /// packet's grandparent.  The idea is illustrated below:
## ///
## /// ```text
## ///             ancestor
## ///             |       \
## ///            ...      -n
## ///             |
## ///           grandparent
## ///           |          \
## ///         parent       -1
## ///         |      \
## ///      packet    0
## ///         |
## ///         1
## /// ```
## ///
## /// Note: since this function does not automatically recurse into
## /// a container, the change in depth will always be non-positive.
## /// If the current container is empty, this function DOES pop that
## /// container off the container stack, and returns the following
## /// packet in the parent container.
## ///
## /// The items of the tuple are returned in out-parameters.  If you do
## /// not wish to receive the value, pass `NULL` as the parameter.
## ///
## /// Consumes the given packet parser.
## /

proc sq_packet_parser_next*(ctx: sq_context_t; pp: sq_packet_parser_t;
                           old_packet: ptr sq_packet_t;
                           old_recursion_level: ptr uint8;
                           ppr: ptr sq_packet_parser_result_t;
                            new_recursion_level: ptr uint8): sq_status_t {.sequioa.}
## /
## /// Finishes parsing the current packet and starts parsing the
## /// next one, recursing if possible.
## ///
## /// This method is similar to the [`next()`] method (see that
## /// method for more details), but if the current packet is a
## /// container (and we haven't reached the maximum recursion depth,
## /// and the user hasn't started reading the packet's contents), we
## /// recurse into the container, and return a `PacketParser` for
## /// its first child.  Otherwise, we return the next packet in the
## /// packet stream.  If this function recurses, then the new
## /// packet's position will be old_position + 1; because we always
## /// visit interior nodes, we can't recurse more than one level at
## /// a time.
## ///
## ///   [`next()`]: #method.next
## ///
## /// The items of the tuple are returned in out-parameters.  If you do
## /// not wish to receive the value, pass `NULL` as the parameter.
## ///
## /// Consumes the given packet parser.
## /

proc sq_packet_parser_recurse*(ctx: sq_context_t; pp: sq_packet_parser_t;
                              old_packet: ptr sq_packet_t;
                              old_recursion_level: ptr uint8;
                              ppr: ptr sq_packet_parser_result_t;
                               new_recursion_level: ptr uint8): sq_status_t {.sequioa.}
## /
## /// Causes the PacketParser to buffer the packet's contents.
## ///
## /// The packet's contents are stored in `packet.content`.  In
## /// general, you should avoid buffering a packet's content and
## /// prefer streaming its content unless you are certain that the
## /// content is small.
## /

proc sq_packet_parser_buffer_unread_content*(ctx: sq_context_t;
                                             pp: sq_packet_parser_t; len: ptr csize): ptr uint8 {.sequioa.}
## /
## /// Finishes parsing the current packet.
## ///
## /// By default, this drops any unread content.  Use, for instance,
## /// `PacketParserBuild` to customize the default behavior.
## /

proc sq_packet_parser_finish*(ctx: sq_context_t; pp: sq_packet_parser_t;
                              packet: ptr ptr sq_packet_t): sq_status_t {.sequioa.}
## /
## /// Tries to decrypt the current packet.
## ///
## /// On success, this function pushes one or more readers onto the
## /// `PacketParser`'s reader stack, and sets the packet's
## /// `decrypted` flag.
## ///
## /// If this function is called on a packet that does not contain
## /// encrypted data, or some of the data was already read, then it
## /// returns `Error::InvalidOperation`.
## /

proc sq_packet_parser_decrypt*(ctx: sq_context_t; pp: sq_packet_parser_t;
                               algo: uint8; key: ptr uint8; key_len: csize): sq_status_t {.sequioa.}
  ##  XXX
type
  sq_writer_stack_t* = pointer

## /
## /// Wraps a `std::io::Write`r for use with the streaming subsystem.
## ///
## /// XXX: This interface will likely change.
## /

proc sq_writer_stack_wrap*(writer: sq_writer_t): sq_writer_stack_t {.sequioa.}
## /
## /// Writes up to `len` bytes of `buf` into `writer`.
## o/

proc sq_writer_stack_write*(ctx: sq_context_t; writer: sq_writer_stack_t;
                            buf: ptr uint8; len: csize): int {.sequioa.}
## /
## /// Finalizes this writer, returning the underlying writer.
## /

proc sq_writer_stack_finalize_one*(ctx: sq_context_t; writer: sq_writer_stack_t): sq_writer_stack_t {.sequioa.}
## /
## /// Finalizes all writers, tearing down the whole stack.
## /

proc sq_writer_stack_finalize*(ctx: sq_context_t; writer: sq_writer_stack_t): sq_status_t {.sequioa.}
## /
## /// Writes an arbitrary packet.
## ///
## /// This writer can be used to construct arbitrary OpenPGP packets.
## /// The body will be written using partial length encoding, or, if the
## /// body is short, using full length encoding.
## /

proc sq_arbitrary_writer_new*(ctx: sq_context_t; inner: sq_writer_stack_t;
                              tag: sq_tag_t): sq_writer_stack_t {.sequioa.}
## /
## /// Signs a packet stream.
## ///
## /// For every signing key, a signer writes a one-pass-signature
## /// packet, then hashes and emits the data stream, then for every key
## /// writes a signature packet.
## /

proc sq_signer_new*(ctx: sq_context_t; inner: sq_writer_stack_t;
                    signers: ptr sq_tpk_t; signers_len: csize): sq_writer_stack_t {.sequioa.}
## /
## /// Creates a signer for a detached signature.
## /

proc sq_signer_new_detached*(ctx: sq_context_t; inner: sq_writer_stack_t;
                             signers: ptr sq_tpk_t; signers_len: csize): sq_writer_stack_t {.sequioa.}
## /
## /// Writes a literal data packet.
## ///
## /// The body will be written using partial length encoding, or, if the
## /// body is short, using full length encoding.
## /

proc sq_literal_writer_new*(ctx: sq_context_t; inner: sq_writer_stack_t): sq_writer_stack_t {.sequioa.}
## /
## /// Specifies whether to encrypt for archival purposes or for
## /// transport.
## /

type ## /
    ##   /// Encrypt data for long-term storage.
    ##   ///
    ##   /// This should be used for things that should be decryptable for
    ##   /// a long period of time, e.g. backups, archives, etc.
    ##   /
  sq_encryption_mode_t* = enum
    SQ_ENCRYPTION_MODE_AT_REST = 0, ## /
                                 ##   /// Encrypt data for transport.
                                 ##   ///
                                 ##   /// This should be used to protect a message in transit.  The
                                 ##   /// recipient is expected to take additional steps if she wants to
                                 ##   /// be able to decrypt it later on, e.g. store the decrypted
                                 ##   /// session key, or re-encrypt the session key with a different
                                 ##   /// key.
                                 ##   /
    SQ_ENCRYPTION_MODE_FOR_TRANSPORT = 1


## /
## /// Creates a new encryptor.
## ///
## /// The stream will be encrypted using a generated session key,
## /// which will be encrypted using the given passwords, and all
## /// encryption-capable subkeys of the given TPKs.
## ///
## /// The stream is encrypted using AES256, regardless of any key
## /// preferences.
## /

proc sq_encryptor_new*(ctx: sq_context_t; inner: sq_writer_stack_t;
                      passwords: cstringArray; passwords_len: csize;
                      recipients: ptr sq_tpk_t; recipients_len: csize;
                       mode: sq_encryption_mode_t): sq_writer_stack_t {.sequioa.}
