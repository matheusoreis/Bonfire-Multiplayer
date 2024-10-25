import 'package:flutter/material.dart';
import 'package:websocket/multiplayer/core/alert/alert_core.dart';
import 'package:websocket/multiplayer/core/ping/ping_core.dart';
import 'package:websocket/multiplayer/net/handler.dart';
import 'package:websocket/multiplayer/net/websocket.dart';
import 'package:websocket/multiplayer/protocol/messages/server_message.dart';

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

  final connectionStatus = ValueNotifier<ConnectionStatus>(
    ConnectionStatus.desconectado,
  );

  final connectionError = ValueNotifier<String?>(null);

  void _initialize() {
    client.onOpen.listen((_) {
      _setConnectionStatus(ConnectionStatus.conectado);
      connectionError.value = null;
    });

    client.onClosed.listen(
      (_) {
        _setConnectionStatus(ConnectionStatus.desconectado);
      },
      onError: (error) {
        _setConnectionStatus(ConnectionStatus.desconectado);
        connectionError.value = error.toString();
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

  void sendPing() {
    try {
      PingCore().send();
    } catch (e) {
      connectionError.value = 'Erro ao enviar ping: $e';
      _setConnectionStatus(
        ConnectionStatus.desconectado,
      );
      debugPrint("Erro ao enviar ping: $e");
    }
  }

  void _setConnectionStatus(ConnectionStatus status) {
    connectionStatus.value = status;
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
