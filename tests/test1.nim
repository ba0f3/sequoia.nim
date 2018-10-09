import sequoia

var PUBLIC_KEY = """"-----BEGIN PGP PUBLIC KEY BLOCK-----
mQENBFpxtsABCADZcBa1Q3ZLZnju18o0+t8LoQuIIeyeUQ0H45y6xUqyrD5HSkVM
VGQs6IHLq70mAizBJ4VznUVqVOh/NhOlapXi6/TKpjHvttdg45o6Pgqa0Kx64luT
ZY+TEKyILcdBdhr3CzsEILnQst5jadgMvU9fnT/EkJIvxtWPlUzU5R7nnALO626x
2M5Pj3k0h3ZNHMmYQQtReX/RP/xUh2SfOYG6i/MCclIlee8BXHB9k0bW2NAX2W7H
rLDGPm1LzmyqxFGDvDvfPlYZ5nN2cbGsv3w75LDzv75kMhVnkZsrUjnHjVRzFq7q
fSIpxlvJMEMKSIJ/TFztQoOBO5OlBb5qzYPpABEBAAG0F+G8iM+BzrnPg8+Ezr/P
hM6tzrvOt8+CiQFUBBMBCAA+FiEEfcpYtU6xQxad3uFfJH9tq8hJFP4FAlpxtsAC
GwMFCQPCZwAFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQJH9tq8hJFP49hgf+
IKvec0RkD9EHSLFc6AKDm/knaI4AIH0isZTz9jRCF8H/j3h8QVUE+/0jtCcyvR6F
TGVSfO3pelDPYGIjDFI3aA6H/UlhZWzYRXZ+QQRrV0zwvLna3XjiW8ib3Ky+5bpQ
0uVeee30u+U3SnaCL9QB4+UvwVvAxRuk49Z0Q8TsRrQyQNYpeZDN7uNrvA134cf6
6pLUvzPG4lMLIvSXFuHou704EhT7NS3wAzFtjMrsLLieVqtbEi/kBaJTQSZQwjVB
sE/Z8lp1heKw/33Br3cB63n4cTf0FdoFywDBhCAMU7fKboU5xBpm5bQJ4ck6j6w+
BKG1FiQRR6PCUeb6GjxVOrkBDQRacbbAAQgAw538MMb/pRdpt7PTgBCedw+rU9fh
onZYKwmCO7wz5VrVf8zIVvWKxhX6fBTSAy8mxaYbeL/3woQ9Leuo8f0PQNs9zw1N
mdH+cnm2KQmL9l7/HQKMLgEAu/0C/q7ii/j8OMYitaMUyrwy+OzW3nCal/uJHIfj
bdKx29MbKgF/zaBs8mhTvf/Tu0rIVNDPEicwijDEolGSGebZxdGdHJA31uayMHDK
/mwySJViMZ8b+Lzc/dRgNbQoY6yjsjso7U9OZpQK1fooHOSQS6iLsSSsZLcGPD+7
m7j3jwq68SIJPMsu0O8hdjFWL4Cfj815CwptAxRGkp00CIusAabO7m8DzwARAQAB
iQE2BBgBCAAgFiEEfcpYtU6xQxad3uFfJH9tq8hJFP4FAlpxtsACGwwACgkQJH9t
q8hJFP5rmQgAoYOUXolTiQmWipJTdMG/VZ5X7mL8JiBWAQ11K1o01cZCMlziyHnJ
xJ6Mqjb6wAFpYBtqysJG/vfjc/XEoKgfFs7+zcuEnt41xJQ6tl/L0VTxs+tEwjZu
Rp/owB9GCkqN9+xNEnlH77TLW1UisW+l0F8CJ2WFOj4lk9rcXcLlEdGmXfWIlVCb
2/o0DD+HDNsF8nWHpDEy0mcajkgIUTvXQaDXKbccX6Wgep8dyBP7YucGmRPd9Z6H
bGeT3KvlJlH5kthQ9shsmT14gYwGMR6rKpNUXmlpetkjqUK7pGVaHGgJWUZ9QPGU
awwPdWWvZSyXJAPZ9lC5sTKwMJDwIxILug==
=lAie
-----END PGP PUBLIC KEY BLOCK-----"""".cstring

var
  err: sq_error_t
  ctx = sq_context_new("nim.sequoia.example", addr err)
  reader = sq_armor_reader_from_bytes(cast[ptr uint8](PUBLIC_KEY), PUBLIC_KEY.len, SQ_ARMOR_KIND_PUBLICKEY)
  tpk = sq_tpk_from_reader(ctx, reader)
  store = sq_store_open(ctx, "default")

sq_tpk_dump(tpk)

discard sq_store_import(ctx, store, "Ἀριστοτέλης", tpk)
let tpk2 = sq_store_lookup(ctx, store, "Ἀριστοτέλης")
assert sq_tpk_fingerprint(tpk) == sq_tpk_fingerprint(tpk2)
