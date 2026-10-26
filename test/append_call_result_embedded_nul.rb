# `<<` in value position (a method's answer, a reader's, an element's, a
# global's, a local's) appends every byte of its argument, as a statement
# `s << x` does: a NUL in the argument does not end it, and the answer takes
# the argument's encoding.
def head(n)
  s = "".b
  s << n.chr
end

def framed(payload) = head(payload.bytesize) << payload

p framed("xy").bytes
p framed("\x00\x07".b).bytes

x = head(2) << "\x00\x07".b
p x.bytes

y = head(3).concat("a\x00b")
p y.bytes

class Frame
  attr_reader :buf
  def initialize = @buf = "".b
end

f = Frame.new
z = f.buf << "\x00z".b
p z.bytes, f.buf.bytes

a = ["".b]
p (a[0] << "\x00a".b).bytes

$g = "".b
p ($g << "\x00g".b).bytes, $g.bytes

def chained(a, b)
  s = "".b
  s << "<"
  t = (s << a << b)
  t
end
p chained("\x00".b, "1\x002".b).bytes

u = head(1) << "é"
p u.encoding, u.bytes
