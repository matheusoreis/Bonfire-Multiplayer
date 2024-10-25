import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:websocket/game/player.dart';

// void main() {
//   ByteBuffer bb = ByteBuffer();

//   bb.putInt8(8);
//   bb.putInt16(16);
//   bb.putInt32(32);
//   bb.putString('value');

//   print(bb.getInt8());
//   print(bb.getInt16());
//   print(bb.getInt32());
//   print(bb.getString());
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    this.enabledMouse = true,
  });

  final String title;
  final bool enabledMouse;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BonfireWidget(
      showCollisionArea: true,
      playerControllers: [
        Joystick(
          directional: JoystickDirectional(
            isFixed: false,
            size: 100,
          ),
          actions: [
            JoystickAction(
              actionId: 1,
              enableDirection: true,
              margin: const EdgeInsets.all(80),
              size: 60,
            ),
          ],
        ),
      ],
      map: WorldMapByTiled(
        WorldMapReader.fromAsset(
          'maps/map1.tmj',
        ),
      ),
      player: GamePlayer(
        position: Vector2(
          10,
          10,
        ),
      ),
      cameraConfig: CameraConfig(
        zoom: getZoomFromMaxVisibleTile(context, 20, 30),
      ),
    );
  }
}
