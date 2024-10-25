import 'dart:typed_data';

import 'package:websocket/misc/app_dependencies.dart';
import 'package:websocket/multiplayer/protocol/bytebuffer.dart';
import 'package:websocket/multiplayer/protocol/headers/server_headers.dart';

class ServerMessage {
  final ByteBuffer _byteBuffer;

  ServerMessage(Uint8List buffer) : _byteBuffer = dependency.get<ByteBuffer>() {
    _byteBuffer.putBytes(buffer);
  }

  ServerHeaders getId() {
    final index = _byteBuffer.getInt16();

    return ServerHeaders.values[index];
  }

  Uint8List getContent() {
    return _byteBuffer.getBytes(_byteBuffer.getRemainingBytes());
  }

  int getInt8() {
    return _byteBuffer.getInt8();
  }

  int getInt16() {
    return _byteBuffer.getInt16();
  }

  int getInt32() {
    return _byteBuffer.getInt32();
  }

  String getString() {
    return _byteBuffer.getString();
  }
}
