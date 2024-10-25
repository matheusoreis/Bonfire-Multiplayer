import 'package:websocket/multiplayer/protocol/headers/client_headers.dart';
import 'package:websocket/multiplayer/protocol/messages/client_message.dart';

class PingOutgoing extends ClientMessage {
  PingOutgoing() : super(ClientHeaders.ping.index);
}
