import 'package:websocket/multiplayer/core/alert/alert_incoming.dart';
import 'package:websocket/multiplayer/core/ping/ping_incoming.dart';
import 'package:websocket/multiplayer/net/websocket.dart';
import 'package:websocket/multiplayer/protocol/headers/server_headers.dart';
import 'package:websocket/multiplayer/protocol/incoming.dart';
import 'package:websocket/multiplayer/protocol/messages/server_message.dart';
import 'package:web_socket_channel/status.dart';

class Handler {
  final Map<ServerHeaders, IncomingInterface> requestHandlers = {};

  Handler() {
    _registerRequests();
  }

  void handleMessage(WebsocketClient client, ServerMessage message) {
    if (!client.isConnected) {
      return;
    }

    try {
      final ServerHeaders messageId = message.getId();

      if (!requestHandlers.containsKey(messageId)) {
        client.disconnectToServer(
          protocolError,
          'Handler não encontrado para o ID da mensagem: $messageId',
        );

        return;
      }

      final handler = requestHandlers[messageId];
      handler?.handle(client: client, serverMessage: message);
    } catch (e) {
      client.disconnectToServer(
        protocolError,
        'Erro ao processar a mensagem: $e',
      );
    }
  }

  void _registerRequests() {
    requestHandlers[ServerHeaders.ping] = PingIncoming();
    requestHandlers[ServerHeaders.alert] = AlertIncoming();
  }
}
