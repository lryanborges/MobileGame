import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'MyGame.dart';

class Arrow extends SpriteAnimationComponent with TapCallbacks, HasGameRef<MyGame>, HasCollisionDetection,
    CollisionCallbacks {

  late SpriteSheet idleSpriteSheet;
  late SpriteAnimation idleAnimation;
  bool inverted = false;

  int velX = 150;

  @override
  void onLoad() async {
    print("teste");
    //sprite = await gameRef.loadSprite('person.png');
    position = gameRef.size / 2;
    size = Vector2(72.0, 72.0);
    if(inverted){
      scale = Vector2(-0.5, 0.5);
    } else {
      scale = Vector2(0.5, 0.5);
    }
    anchor = Anchor.center;

    //debugMode = true;
    idleSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('arrow.png'),
      srcSize: Vector2.all(72.0),
    );


    idleAnimation = idleSpriteSheet.createAnimation(
        row: 0, stepTime: 0.2, from: 0, to: 1, loop: true);

    //define a animação atual
    animation = idleAnimation;
    add(RectangleHitbox(isSolid: true, size: Vector2(72,72),position: Vector2(position.x, position.y),collisionType: CollisionType.active));

    position.y = 200;

    super.onLoad();
  }

  bool isCollidingWith(PositionComponent other) {
    return this.toRect().overlaps(other.toRect());
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    position.y = -10000;
    removeFromParent();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    position.x = position.x + (velX * dt);
    position.y = 330;
    // setStates de teste

    // ------

    //vy += ay * dt;

    //position.x += vx * dt;
    //position.y += vy * dt;

  }

}