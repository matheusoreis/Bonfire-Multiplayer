import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart';
import 'package:websocket/misc/constants.dart';

class WebsocketClient {
  late WebSocketChannel _socket;
  bool isConnected = false;

  final _onOpen = StreamController<void>.broadcast();
  final _onClosed = StreamController<void>.broadcast();
  final _onReceived = StreamController<Uint8List>.broadcast();

  Stream<void> get onOpen => _onOpen.stream;
  Stream<void> get onClosed => _onClosed.stream;
  Stream<Uint8List> get onReceived => _onReceived.stream;

  void connectToServer() async {
    if (isConnected) {
      disconnectToServer(
        goingAway,
        "Reconectando ao servidor",
      );
    }

    _socket = WebSocketChannel.connect(
      Uri.parse(
        'ws://${Constants.host}:${Constants.port}/ws',
      ),
    );

    try {
      await _socket.ready;

      isConnected = true;
      _onOpen.add(null);

      _socket.stream.listen(
        _handleReceivedData,
        onDone: _handleDisconnection,
        onError: (error) {
          _handleConnectionError(error);
        },
      );
    } catch (e) {
      _handleConnectionError(e);
    }
  }

  Future<void> sendMessage(Uint8List message) async {
    if (!isConnected) {
      return;
    }

    try {
      _socket.sink.add(message);
    } catch (e) {
      disconnectToServer(
        internalServerError,
        "Falha ao enviar mensagem",
      );

      throw Exception(
        'Erro ao enviar mensagem: $e',
      );
    }
  }

  void disconnectToServer(int code, String reason) {
    if (isConnected) {
      _socket.sink.close(code, reason);
      isConnected = false;
    }

    _resetState();
    _onClosed.add(null);
  }

  void _handleReceivedData(dynamic data) {
    if (data is! Uint8List) {
      throw Exception(
        'Os dados recebidos não são do tipo Uint8List: $data',
      );
    }

    _onReceived.add(data);
  }

  void _handleDisconnection() {
    _resetState();
    _onClosed.add(null);
  }

  void _handleConnectionError(Object error) {
    String errorMessage = "Erro ao conectar ao servidor WebSocket.";
    if (error is WebSocketChannelException || error is SocketException) {
      errorMessage = "Erro de conexão: O servidor recusou a conexão.";
    }

    _onClosed.addError(
      Exception(errorMessage),
    );

    _resetState();
  }

  void _resetState() {
    isConnected = false;
  }

  void dispose() {
    disconnectToServer(normalClosure, "Cliente dispensado");

    _onOpen.close();
    _onClosed.close();
    _onReceived.close();
  }
}
