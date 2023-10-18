import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'MyGame.dart';
import 'Player.dart';
import 'Arrow.dart';

class Enemy extends SpriteAnimationComponent
    with HasGameRef<MyGame>, HasCollisionDetection, CollisionCallbacks {
  bool flipped = false;
  int totalFrames = 0;
  double enX = 0;
  bool hit = true;
  bool move = true;
  int end = 0;

  double vx = 100;
  double vy = 0;
  double ax = 20;
  double ay = 600;

  late SpriteSheet idleSpriteSheet, hitSpriteSheet;
  late SpriteAnimation idleAnimation, hitAnimation;

  bool gameOver = false;

  @override
  Future<void> onLoad() async {
    idleSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('enemyRun.png'),
      srcSize: Vector2.all(96.0),
    );
    hitSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('enemyAtack1.png'),
      srcSize: Vector2.all(96.0),
    );

    idleAnimation = idleSpriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 0, to: 6, loop: true);
    hitAnimation = hitSpriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 0, to: 3, loop: true);

    animation = idleAnimation;

    position.x = enX;
    position.y = 280;
  }

  bool isCollidingWith(PositionComponent other) {
    return this.toRect().overlaps(other.toRect());
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is Player) {
      if(move){
        if(other.position.x < position.x){
          position.x = position.x - 25;
        } else {
          position.x = position.x + 25;
        }
        move = false;
      }

      vx = 0;
      animation = hitAnimation;
      totalFrames = hitAnimation.frames.length;
    }

    if(other is Arrow){
      gameRef.pontos++;
      print(gameRef.pontos);
      position.y = 10000;
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if(gameRef.gameOver) {
      end++;
      if(end == 300){

        vx = -100;
        animation = idleAnimation;
        if(enX < gameRef.size.x / 2){
          scale = Vector2(-1.0, 1.0);
        } else {
          scale = Vector2(1.0, 1.0);
        }
      }
    }

    if(enX < gameRef.size.x / 2){
      position.x += vx * dt;
    } else {
      position.x += -vx * dt;
    }

  }
}
