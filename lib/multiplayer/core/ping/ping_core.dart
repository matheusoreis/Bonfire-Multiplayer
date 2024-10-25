import 'package:websocket/multiplayer/core/ping/ping_outgoing.dart';

class PingCore {
  void send() {
    PingOutgoing().send();
  }

  void core() {}
}
