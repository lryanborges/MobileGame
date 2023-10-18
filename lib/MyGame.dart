import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'Enemy.dart';
import 'Player.dart';

class MyGame extends FlameGame with TapCallbacks {

  late Player _player;
  late Enemy _enemy;

    @override
    Future<void> onLoad() async {

      final images = [
        loadParallaxImage('background.png', repeat: ImageRepeat.repeat),
        //loadParallaxImage(
        //'terrain.png',
        //repeat: ImageRepeat.repeatX,
        //alignment: Alignment.bottomCenter,
        //fill: LayerFill.none,
        //)
      ];

      final layers = images.map((image) async =>
          ParallaxLayer(
            await image,
            velocityMultiplier: Vector2((images.indexOf(image) + 1) * 2.0, 0),
          ));
      final parallaxComponent = ParallaxComponent(
        parallax: Parallax(
          await Future.wait(layers),
          baseVelocity: Vector2(50, 0),
        ),
      );
      add(parallaxComponent);

      _enemy = Enemy();
      add(_enemy);

      _player = Player();
      add(_player);

    }

  @override
  void onTapUp(TapUpEvent event) async {
    // Do something in response to a tap event
    //sprite = await gameRef.loadSprite('person2.png');
    //scale = Vector2(1, -2);
    _player.animation = _player.hitAnimation;
    _player.size = Vector2(50.0, 50.0);

    if (event.localPosition.x < size.x / 2) {
      _player.scale = Vector2(-1.8, 1.8);
    } else {
      _player.scale = Vector2(1.8, 1.8);
    }
    print("tocou person");
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_player.isCollidingWith(_enemy)) {
      // Colisão entre o jogador e o inimigo ocorreu
      // Faça algo em resposta à colisão
      _player.onCollision(Set(), _enemy);
      _enemy.onCollision(Set(), _player);
    }

    /*if (_enemy.gameOver == true) {
      tc.text = "GAME OVER\n" + score.floor().toString() + " Pontos";
      _spike.vx = 0;
      _spike.omega = 0;
      _apple.vx = 0;

    } else {
      tc.text = score.floor().toString();
      score += velocityScore * dt;
    }*/
  }

}