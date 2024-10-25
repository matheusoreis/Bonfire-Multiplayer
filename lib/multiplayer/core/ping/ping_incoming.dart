import 'package:websocket/misc/app_dependencies.dart';
import 'package:websocket/multiplayer/core/ping/ping_core.dart';
import 'package:websocket/multiplayer/net/websocket.dart';
import 'package:websocket/multiplayer/protocol/incoming.dart';
import 'package:websocket/multiplayer/protocol/messages/server_message.dart';

class PingIncoming implements IncomingInterface {
  @override
  void handle({
    required WebsocketClient client,
    required ServerMessage serverMessage,
  }) {
    dependency.get<PingCore>().core();
  }
}
