import 'package:websocket/multiplayer/net/websocket.dart';
import 'package:websocket/multiplayer/protocol/messages/server_message.dart';

abstract class IncomingInterface {
  void handle({
    required WebsocketClient client,
    required ServerMessage serverMessage,
  });
}
