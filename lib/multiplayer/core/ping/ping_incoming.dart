import 'package:websocket/multiplayer/net/websocket.dart';
import 'package:websocket/multiplayer/protocol/incoming.dart';
import 'package:websocket/multiplayer/protocol/messages/server_message.dart';

class PingIncoming implements IncomingInterface {
  @override
  void handle({
    required WebsocketClient client,
    required ServerMessage serverMessage,
  }) {
    print('Recebendo ping do servidor!');
  }
}
