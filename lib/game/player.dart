import 'package:bonfire/bonfire.dart';
import 'package:websocket/game/sprite.dart';

class GamePlayer extends SimplePlayer with BlockMovementCollision {
  GamePlayer({
    required super.position,
  }) : super(
          size: Vector2.all(64),
          speed: 150,
          life: 100,
          animation: PlayerSpriteSheet.animation(),
        );

  @override
  Future<void> onLoad() async {
    await add(
      RectangleHitbox(
        size: size / 4,
        position: Vector2(size.y * 0.35, size.x * 0.70),
      ),
    );

    return super.onLoad();
  }
}
