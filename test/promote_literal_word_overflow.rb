# Under --int-overflow=promote, an operation on two Integer literals is
# judged at compile time: a result past the word is the Bignum, the rest an
# sp_int. The word is the target's, which on wasm32-wasi is 32 bits whatever
# the compiler's own width. It was judged at 64 bits there, so `127 << 28`
# was typed an sp_int and raised "integer overflow in <<" where `n << 28`
# promoted; so did `+`, `-`, `*`, `**`, pow, succ, abs and `/`. A pow past
# the word was typed the Bignum and emitted as an sp_int on every target.
# spinel: wasm
# spinel: wasm-int-overflow: promote
n = 127
p n << 28
p 127 << 28
p 1 << 31
p 1 << 62
p 1 << 63
p 2147483647 + 1
p(-2147483647 - 2)
p 65536 * 65536
p 9223372036854775807 + 1
p 2 ** 31
p 2 ** 63
p 2.pow(31)
p 2.pow(63)
p 2147483647.succ
p(-2147483648.abs)
p(-2147483648 / -1)
p [65536, 65536].inject(:*)
p (-2147483648..0).count
x = 127 << 28
p x + 1
# results the 32-bit word holds stay plain Integers
p 1 << 30
p(-1 << 31)
p 2147483646 + 1
p 2 ** 30
p 2.pow(30)
