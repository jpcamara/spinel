# spinel: not-cruby -- ffi_func is Spinel's own.
# spinel: wasm
# --int-overflow=promote: an ffi_func integer return an Integer cannot hold
# (a uint32_t on a 32-bit target, a uint64_t or size_t on any, an int64_t on
# a 32-bit target) is the Bignum, as CRuby's ffi answers it. The cast gave
# -1294967296 for a uint32_t of 3000000000 on wasm32. A value that fits is
# an ordinary Integer.
module M
  ffi_source <<~C
    #include <stdint.h>
    #include <stddef.h>
    uint32_t u32_big(void) { return 3000000000u; }
    uint32_t u32_small(void) { return 7u; }
    uint64_t u64_max(void) { return UINT64_MAX; }
    size_t size_max(void) { return SIZE_MAX; }
    int64_t i64_low(void) { return -1099511627776ll; }
  C
  ffi_func :u32_big, [], :uint32
  ffi_func :u32_small, [], :uint32
  ffi_func :u64_max, [], :uint64
  ffi_func :size_max, [], :size_t
  ffi_func :i64_low, [], :int64
end

p M.u32_big
p M.u32_big + 1
p M.u32_big.class
p M.u32_small
p M.u64_max
p M.size_max == 2 ** (8 * 1.size) - 1
p M.i64_low
