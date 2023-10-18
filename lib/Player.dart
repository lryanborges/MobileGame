import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'MyGame.dart';
import 'Enemy.dart';

class Player extends SpriteAnimationComponent with TapCallbacks, HasGameRef<MyGame>, HasCollisionDetection,
    CollisionCallbacks {

  bool flipped = false;
  int lifes = 5;

  double vx = 0; //m/s
  double vy = 0; //m/s
  double ax = 0;
  double ay = 600;

  late SpriteSheet idleSpriteSheet, hitSpriteSheet, deathSpriteSheet;
  late SpriteAnimation idleAnimation, hitAnimation, deathAnimation;

  bool gameOver = false;

  @override
  void onLoad() async {
    //sprite = await gameRef.loadSprite('person.png');
    position = gameRef.size / 2;
    size = Vector2(50.0, 50.0);
    scale = Vector2(1.8, 1.8);
    anchor = Anchor.center;

    //debugMode = true;
    idleSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('playerRun.png'),
      srcSize: Vector2.all(50.0),
    );
    hitSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('playerAtack.png'),
      srcSize: Vector2(50.0, 50.0),
    );
    deathSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('playerDeath.png'),
      srcSize: Vector2(50.0, 50.0),
    );

    idleAnimation = idleSpriteSheet.createAnimation(
        row: 0, stepTime: 0.2, from: 0, to: 7, loop: true);
    hitAnimation = hitSpriteSheet.createAnimation(
        row: 0, stepTime: 0.2, from: 0, to: 13, loop: false);
    deathAnimation = deathSpriteSheet.createAnimation(
        row: 0, stepTime: 0.2, from: 0, to: 23, loop: false);

    animation = idleAnimation;
    add(RectangleHitbox(isSolid: true, size: Vector2(50,50),position: Vector2(position.x, position.y),collisionType: CollisionType.active));

    position.x = 400;
    position.y = 355;

    super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) async {
    animation = hitAnimation;
    size = Vector2(50.0, 50.0);

    print("tocou person");
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    //scale = Vector2(1.5, 1.5);
  }

  bool isCollidingWith(PositionComponent other) {
    return this.toRect().overlaps(other.toRect());
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if(other is Enemy){
      if(other.hit){
        lifes--;
        other.hit = false;
      }
    }
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);

    if(hitAnimation.frames.indexOf(SpriteAnimationFrame(hitSpriteSheet.getSprite(0, 13), 0.2)) == 13){
      animation = idleAnimation;
    }

    if(lifes == 0){
      animation = deathAnimation;
      gameOver = true;
    }

  }

}