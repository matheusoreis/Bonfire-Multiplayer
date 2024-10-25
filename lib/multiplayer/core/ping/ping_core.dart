import 'package:websocket/main_store.dart';
import 'package:websocket/misc/globals.dart';
import 'package:websocket/multiplayer/core/ping/ping_outgoing.dart';

class PingCore {
  final MainStore mainStore;

  PingCore({
    required this.mainStore,
  });

  void send() {
    Globals.sendPingTime = DateTime.now();
    PingOutgoing().send();
  }

  void core() {
    final senderTime = Globals.sendPingTime;
    final receiverTime = DateTime.now();

    final rtt = receiverTime.difference(senderTime ?? DateTime.now());

    mainStore.pingState.value = '${rtt.inMilliseconds} ms';
  }
}
