import 'dart:convert';
import 'dart:typed_data';

class ByteBuffer {
  Uint8List _buffer;
  int _writeHead;
  int _readHead;

  ByteBuffer()
      : _buffer = Uint8List(0),
        _writeHead = 0,
        _readHead = 0;

  void _ensureCapacity(int additionalBytes) {
    if (_writeHead + additionalBytes > _buffer.length) {
      Uint8List newBuffer = Uint8List((_writeHead + additionalBytes) * 2); // Aloca um tamanho maior
      newBuffer.setRange(0, _buffer.length, _buffer);
      _buffer = newBuffer;
    }
  }

  void putBytes(Uint8List bytes) {
    _ensureCapacity(bytes.length);
    _buffer.setRange(_writeHead, _writeHead + bytes.length, bytes);
    _writeHead += bytes.length;
  }

  void putInt8(int value) {
    _ensureCapacity(1);
    _buffer[_writeHead] = value;
    _writeHead++;
  }

  void putInt16(int value) {
    _ensureCapacity(2);
    ByteData.view(_buffer.buffer).setInt16(_writeHead, value, Endian.little);
    _writeHead += 2;
  }

  void putInt32(int value) {
    _ensureCapacity(4);
    ByteData.view(_buffer.buffer).setInt32(_writeHead, value, Endian.little);
    _writeHead += 4;
  }

  void putString(String value) {
    Uint8List encoded = utf8.encode(value);
    putInt32(encoded.length);
    putBytes(encoded);
  }

  int getInt8() {
    if (_readHead + 1 > _writeHead) throw RangeError('Not enough bytes to read Int8');
    return _buffer[_readHead++];
  }

  int getInt16() {
    if (_readHead + 2 > _writeHead) throw RangeError('Not enough bytes to read Int16');
    int value = ByteData.view(_buffer.buffer).getInt16(_readHead, Endian.little);
    _readHead += 2;
    return value;
  }

  int getInt32() {
    if (_readHead + 4 > _writeHead) throw RangeError('Not enough bytes to read Int32');
    int value = ByteData.view(_buffer.buffer).getInt32(_readHead, Endian.little);
    _readHead += 4;
    return value;
  }

  String getString() {
    int length = getInt32(); // Lê o tamanho da string
    if (_readHead + length > _writeHead) {
      throw RangeError('Not enough bytes to read string of length $length');
    }
    Uint8List value = _buffer.sublist(_readHead, _readHead + length);
    _readHead += length; // Atualiza o offset
    return utf8.decode(value); // Decodifica e retorna a string
  }

  Uint8List getBytes(int length) {
    if (_readHead + length > _writeHead) throw RangeError('Not enough bytes to read $length bytes');
    Uint8List value = _buffer.sublist(_readHead, _readHead + length);
    _readHead += length;
    return value;
  }

  Uint8List getBuffer() {
    return _buffer.sublist(0, _writeHead);
  }

  int getRemainingBytes() {
    return _writeHead - _readHead;
  }

  void reset() {
    _writeHead = 0;
    _readHead = 0;
  }

  void flush() {
    _writeHead = 0; // Limpa o buffer para novas gravações
    _readHead = 0;
  }
}
