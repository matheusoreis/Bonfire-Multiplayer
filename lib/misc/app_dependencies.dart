import 'package:get_it/get_it.dart';
import 'package:websocket/main_store.dart';
import 'package:websocket/multiplayer/core/alert/alert_core.dart';
import 'package:websocket/multiplayer/core/ping/ping_core.dart';
import 'package:websocket/multiplayer/net/handler.dart';
import 'package:websocket/multiplayer/net/websocket.dart';
import 'package:websocket/multiplayer/protocol/bytebuffer.dart';

final GetIt dependency = GetIt.instance;

class AppDependencies {
  static void setup() {
    dependency
      ..registerFactory(
        () => ByteBuffer(),
      )
      ..registerLazySingleton(
        () => WebsocketClient(),
      )
      ..registerFactory(
        () => Handler(),
      )
      ..registerLazySingleton(
        () => MainStore(
          client: dependency.get<WebsocketClient>(),
          handler: dependency.get<Handler>(),
          alertCore: dependency.get<AlertCore>(),
        ),
      )
      ..registerLazySingleton(
        () => PingCore(
          mainStore: dependency.get<MainStore>(),
        ),
      )
      ..registerLazySingleton(
        () => AlertCore(),
      );
  }
}
