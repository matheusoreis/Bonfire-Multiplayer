import 'dart:async';

class AlertCore {
  final _alertController = StreamController<String>();
  Stream<String> get alertStream => _alertController.stream;

  void core(String message) {
    _alertController.add(message);
  }

  void dispose() {
    _alertController.close();
  }
}
