import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'MyGame.dart';

class Enemy extends SpriteAnimationComponent with TapCallbacks, HasGameRef<MyGame> {

  bool flipped = false;

  double vx = 0; //m/s
  double vy = 0; //m/s
  double ax = 0;
  double ay = 600;

  late SpriteSheet idleSpriteSheet, hitSpriteSheet;
  late SpriteAnimation idleAnimation, hitAnimation;

  bool gameOver = false;

  @override
  void onLoad() async {
    //sprite = await gameRef.loadSprite('person.png');
    position = gameRef.size / 2;
    size = Vector2(96.0, 96.0);
    scale = Vector2(-1.0, 1.0);
    anchor = Anchor.center;

    //debugMode = true;
    idleSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('enemyRun.png'),
      srcSize: Vector2.all(96.0),
    );
    hitSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('enemyAtack1.png'),
      srcSize: Vector2.all(96.0),
    );

    idleAnimation = idleSpriteSheet.createAnimation(
        row: 0, stepTime: 0.2, from: 0, to: 6, loop: true);
    hitAnimation = hitSpriteSheet.createAnimation(
        row: 0, stepTime: 0.2, from: 0, to: 3, loop: false);

    //define a animação atual
    animation = idleAnimation;
    //add(RectangleHitbox(isSolid: true, size: Vector2(32,32),position: Vector2(200,200),collisionType: CollisionType.active));

    position.x = 100;
    position.y = 705;

    super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) async {
    // Do something in response to a tap event
    //sprite = await gameRef.loadSprite('person2.png');
    //scale = Vector2(1, -2);
    //animation = hitAnimation;
    print("tocou person");
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    //scale = Vector2(1.5, 1.5);
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    //vy += ay * dt;
    if(position.y - 40 >= gameRef.size.y){
      ay=0;
      vy=0;
      gameOver = true;
      removeFromParent();
    }
    //position.x += vx * dt;
    //position.y += vy * dt;

  }

}