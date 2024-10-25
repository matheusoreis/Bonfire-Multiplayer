import 'package:flutter/material.dart';
import 'package:websocket/misc/app_dependencies.dart';
import 'package:websocket/multiplayer/core/alert/alert_core.dart';
import 'package:websocket/multiplayer/core/ping/ping_core.dart';
import 'package:websocket/multiplayer/net/handler.dart';
import 'package:websocket/multiplayer/net/websocket.dart';
import 'package:websocket/multiplayer/protocol/messages/server_message.dart';
import 'package:web_socket_channel/status.dart';

enum ConnectionStatus {
  conectando,
  conectado,
  desconectado,
}

class MainStore {
  final WebsocketClient client;
  final Handler handler;
  final AlertCore alertCore;

  MainStore({
    required this.client,
    required this.handler,
    required this.alertCore,
  }) {
    _initialize();
  }

  late BuildContext context;

  final connectionState = ValueNotifier<ConnectionStatus>(
    ConnectionStatus.desconectado,
  );

  final pingState = ValueNotifier<String>('');

  void _initialize() {
    client.onOpen.listen((_) {
      _setConnectionStatus(ConnectionStatus.conectado);
    });

    client.onClosed.listen(
      (_) {
        _setConnectionStatus(ConnectionStatus.desconectado);
      },
      onError: (error) {
        _setConnectionStatus(ConnectionStatus.desconectado);
        showAlertDialog(
          error.toString(),
        );
      },
    );

    client.onReceived.listen((data) {
      ServerMessage message = ServerMessage(data);
      handler.handleMessage(client, message);
    });
  }

  void connectToServer() {
    _setConnectionStatus(ConnectionStatus.conectando);

    client.connectToServer();
  }

  void disconnectToServer() {
    _setConnectionStatus(ConnectionStatus.conectando);

    client.disconnectToServer(
      normalClosure,
      'Desconexão solicitada pelo cliente',
    );
  }

  void sendPing() {
    final pingCore = dependency.get<PingCore>();

    try {
      pingCore.send();
    } catch (e) {
      _setConnectionStatus(
        ConnectionStatus.desconectado,
      );

      debugPrint("Erro ao enviar ping: $e");
    }
  }

  void _setConnectionStatus(ConnectionStatus status) {
    connectionState.value = status;
  }

  Color connectionStatusColor(ConnectionStatus status) {
    late Color color;

    switch (status) {
      case ConnectionStatus.conectado:
        color = Colors.green;
        break;

      case ConnectionStatus.conectando:
        color = Colors.orange;
        break;

      case ConnectionStatus.desconectado:
        color = Colors.red;
        break;
    }

    return color;
  }

  void showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alerta'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
