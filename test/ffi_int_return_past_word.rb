# spinel: not-cruby -- ffi_func is Spinel's own.
# spinel: wasm
# An ffi_func integer return whose C type has values an Integer cannot hold
# (a uint32_t on a 32-bit target, a uint64_t or size_t on any, an int64_t on
# a 32-bit target) was cast to the Integer: on wasm32 a uint32_t of
# 3000000000 came back as -1294967296. A value past the Integer raises
# RangeError now (--int-overflow=promote returns the Bignum, pinned by
# promote_ffi_int_return.rb); one that fits comes back as itself.
module M
  ffi_source <<~C
    #include <stdint.h>
    #include <stddef.h>
    uint32_t u32_big(void) { return 3000000000u; }
    uint32_t u32_top(void) { return 2147483647u; }
    uint64_t u64_max(void) { return UINT64_MAX; }
    uint64_t u64_small(void) { return 42u; }
    size_t size_max(void) { return SIZE_MAX; }
    int64_t i64_low(void) { return -1099511627776ll; }
  C
  ffi_func :u32_big, [], :uint32
  ffi_func :u32_top, [], :uint32
  ffi_func :u64_max, [], :uint64
  ffi_func :u64_small, [], :uint64
  ffi_func :size_max, [], :size_t
  ffi_func :i64_low, [], :int64
end

def value_or_error
  yield
rescue RangeError => e
  e.message
end

p M.u32_top
p M.u64_small
puts value_or_error { M.u64_max }
puts value_or_error { M.size_max }.to_s.include?("returned by M.size_max is out of Integer range")
# 3000000000 and -2**40 fit a 64-bit Integer, not a 32-bit one
wide = 1.size == 8
r = value_or_error { M.u32_big }
p(wide ? r == 3000000000 : r == "integer 3000000000 returned by M.u32_big is out of Integer range (--int-overflow=promote returns it as a Bignum)")
r = value_or_error { M.i64_low }
p(wide ? r == -1099511627776 : r == "integer -1099511627776 returned by M.i64_low is out of Integer range (--int-overflow=promote returns it as a Bignum)")
