import 'package:bonfire/bonfire.dart';

class PlayerSpriteSheet {
  static Future<SpriteAnimation> idle() => SpriteAnimation.load(
        'player_blue.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: Vector2.all(32),
        ),
      );

  static Future<SpriteAnimation> run() => SpriteAnimation.load(
        'player_blue.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.2,
          textureSize: Vector2.all(32),
          texturePosition: Vector2(0, 64),
        ),
      );

  static Future<SpriteAnimation> die() => SpriteAnimation.load(
        'player_blue.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2.all(32),
          texturePosition: Vector2(0, 96),
        ),
      );

  static Future<SpriteAnimation> talk() => SpriteAnimation.load(
        'player_blue.png',
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.1,
          textureSize: Vector2.all(32),
          texturePosition: Vector2(0, 32),
        ),
      );

  static Future<SpriteAnimation> gun() => SpriteAnimation.load(
        'gun_blue.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: Vector2.all(32),
        ),
      );

  static Future<SpriteAnimation> gunShot() => SpriteAnimation.load(
        'gun_blue.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2.all(32),
          texturePosition: Vector2(0, 64),
        ),
      );

  static Future<SpriteAnimation> gunReload() => SpriteAnimation.load(
        'gun_blue.png',
        SpriteAnimationData.sequenced(
          amount: 5,
          stepTime: 0.1,
          textureSize: Vector2.all(32),
          texturePosition: Vector2(0, 32),
        ),
      );

  static Future<SpriteAnimation> get bullet => SpriteAnimation.load(
        'bullet_blue.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2.all(16),
        ),
      );

  static Future<Sprite> get bulletCapsule => Sprite.load(
        'bullet_blue.png',
        srcSize: Vector2.all(16),
        srcPosition: Vector2(0, 16),
      );

  static SimpleDirectionAnimation animation() => SimpleDirectionAnimation(
        idleRight: idle(),
        runRight: run(),
        others: {
          'talk': talk(),
        },
      );
}
