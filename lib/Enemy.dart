import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'MyGame.dart';
import 'Player.dart';

class Enemy extends SpriteAnimationComponent
    with TapCallbacks, HasGameRef<MyGame>, HasCollisionDetection, CollisionCallbacks {
  bool flipped = false;
  int totalFrames = 0;

  double vx = 100; // m/s
  double vy = 0; // m/s
  double ax = 20;
  double ay = 600;

  late SpriteSheet idleSpriteSheet, hitSpriteSheet;
  late SpriteAnimation idleAnimation, hitAnimation;

  bool gameOver = false;

  @override
  Future<void> onLoad() async {
    // Carrega as imagens para as animações
    idleSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('enemyRun.png'),
      srcSize: Vector2.all(96.0),
    );
    hitSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('enemyAtack1.png'),
      srcSize: Vector2.all(96.0),
    );

    // Cria as animações
    idleAnimation = idleSpriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 0, to: 6, loop: true);
    hitAnimation = hitSpriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 0, to: 3, loop: false);

    animation = idleAnimation;

    position.x = 100;
    position.y = 280;
  }

  bool isCollidingWith(PositionComponent other) {
    return this.toRect().overlaps(other.toRect());
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    // Ação ao colidir com outro components
    if (other is Player) {
      animation = hitAnimation;
      totalFrames = hitAnimation.frames.length;
    }
  }

  @override
  void update(double dt) {
    // Atualizações lógicas, movimento, etc.
    super.update(dt);

    //vy += ay * dt;
    if (position.y - 40 >= gameRef.size.y) {
      ay = 0;
      vy = 0;
      gameOver = true;
      removeFromParent();
    }

    position.x = position.x + 10*dt;
    //position.x += vx * dt;
    //position.y += vy * dt;
  }
}
