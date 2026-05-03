## LEB128 (Little Endian Base 128) encoding/decoding.
## Shared module to avoid duplication across encode/decode/interp/transforms.

proc readByte*(data: openArray[byte], pos: var int): byte =
  result = data[pos]
  inc pos

proc readUleb128*(data: openArray[byte], pos: var int): uint32 =
  var shift = 0
  while pos < data.len:
    let b = data[pos]
    inc pos
    result = result or (uint32(b and 0x7F) shl shift)
    if (b and 0x80) == 0: break
    shift += 7

proc readSleb128*(data: openArray[byte], pos: var int): int32 =
  var shift = 0
  var b: byte
  while pos < data.len:
    b = data[pos]
    inc pos
    result = result or (int32(b and 0x7F) shl shift)
    shift += 7
    if (b and 0x80) == 0: break
  if shift < 32 and (b and 0x40) != 0:
    result = result or (int32(not 0) shl shift)

proc writeUleb128*(buf: var seq[byte], val: uint32) =
  var v = val
  while true:
    var b = byte(v and 0x7F)
    v = v shr 7
    if v != 0: b = b or 0x80
    buf.add(b)
    if v == 0: break

proc writeSleb128*(buf: var seq[byte], val: int32) =
  var v = val
  while true:
    var b = byte(v and 0x7F)
    v = v shr 7
    if (v == 0 and (b and 0x40) == 0) or (v == -1 and (b and 0x40) != 0):
      buf.add(b)
      break
    else:
      buf.add(b or 0x80)

proc readUleb128String*(data: openArray[byte], pos: var int): string =
  let len = int(readUleb128(data, pos))
  result = newString(len)
  for i in 0..<len:
    result[i] = char(data[pos + i])
  pos += len

proc writeUleb128String*(buf: var seq[byte], s: string) =
  writeUleb128(buf, uint32(s.len))
  for c in s:
    buf.add(byte(c))
