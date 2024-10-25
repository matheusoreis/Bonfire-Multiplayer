import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:websocket/misc/app_dependencies.dart';
import 'package:websocket/multiplayer/net/websocket.dart';

import '../bytebuffer.dart';

class ClientMessage {
  final ByteBuffer _buffer;
  final WebsocketClient _client;

  ClientMessage(int id)
      : _buffer = dependency.get<ByteBuffer>(),
        _client = dependency.get<WebsocketClient>() {
    _buffer.putInt16(id);
  }

  @protected
  void putBytes(Uint8List bytes) {
    _buffer.putBytes(bytes);
  }

  @protected
  void putInt8(int value) {
    _buffer.putInt8(value);
  }

  @protected
  void putInt16(int value) {
    _buffer.putInt16(value);
  }

  @protected
  void putInt32(int value) {
    _buffer.putInt32(value);
  }

  @protected
  void putString(String bytes) {
    _buffer.putString(bytes);
  }

  @protected
  Uint8List getBuffer() {
    return _buffer.getBuffer();
  }

  void send() {
    try {
      _client.sendMessage(_buffer.getBuffer());
    } catch (e) {
      throw Exception('Não foi possível enviar o pacote para o servidor!');
    }
  }
}
