import 'package:web_socket_channel/status.dart';
import 'package:websocket/misc/app_dependencies.dart';
import 'package:websocket/multiplayer/core/alert/alert_core.dart';
import 'package:websocket/multiplayer/net/websocket.dart';
import 'package:websocket/multiplayer/protocol/incoming.dart';
import 'package:websocket/multiplayer/protocol/messages/server_message.dart';

class AlertIncoming implements IncomingInterface {
  @override
  void handle({
    required WebsocketClient client,
    required ServerMessage serverMessage,
  }) {
    final alertCore = dependency.get<AlertCore>();

    final message = serverMessage.getString();
    final disconnect = serverMessage.getInt8();

    if (disconnect == 1) {
      client.disconnectToServer(
        normalClosure,
        'Desconexão solicitada pelo servidor',
      );
    }

    alertCore.core(message);
  }
}
