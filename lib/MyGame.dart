import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';
import 'Enemy.dart';

class MyGame extends FlameGame with TapCallbacks {

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

    }

  @override
  void update(double dt) {
    super.update(dt);
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