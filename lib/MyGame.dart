import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'Enemy.dart';
import 'Player.dart';
import 'Arrow.dart';

class MyGame extends FlameGame with TapCallbacks {

  List<Enemy> enemies = [];
  List<Arrow> arrows = [];

  late Player _player;
  late Enemy _enemy;
  late Arrow _arrow;
  late TextComponent tc;

  double enemyX = -300;
  double invertedEnemyX = 1000;
  int qtdInimigos = 0;
  int pontos = 0;

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
      enemies.add(_enemy);
      _enemy.position.x = enemyX;
      add(_enemy);
      qtdInimigos++;

      _player = Player();
      add(_player);

      _arrow = Arrow();

      final scoreStyle = TextPaint(
        style: TextStyle(
          fontSize: 24.0,
          color: BasicPalette.black.color,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold
        ),
      );

      tc = TextComponent(
        text: pontos.floor().toString(),
        textRenderer: scoreStyle,
        anchor: Anchor.topCenter,
        position: Vector2(size.x / 2, 40),
      );
      add(tc);

    }

  @override
  void onTapUp(TapUpEvent event) async {
    // Do something in response to a tap event
    //sprite = await gameRef.loadSprite('person2.png');
    //scale = Vector2(1, -2);
    _player.animation = _player.idleAnimation;
    _player.animation = _player.hitAnimation;
    _player.size = Vector2(50.0, 50.0);

    if (event.localPosition.x < size.x / 2) {
      _player.scale = Vector2(-1.8, 1.8);
      _arrow = Arrow();
      arrows.add(_arrow);
      _arrow.velX = -_arrow.velX;
      add(_arrow);
    } else {
      _arrow = Arrow();
      _player.scale = Vector2(1.8, 1.8);
      _arrow.inverted = true;
      arrows.add(_arrow);
      _arrow.velX = _arrow.velX;
      add(_arrow);
    }
    print("tocou person");
  }

  @override
  void update(double dt) {
    super.update(dt);

    tc.text = "Score: " + pontos.toString();

    if (qtdInimigos < 15) {
      qtdInimigos++;
      if(qtdInimigos % 2 == 0){
        enemyX = enemyX - 100;
        _enemy = Enemy();
        enemies.add(_enemy);
        _enemy.enX = enemyX;
      } else {
        invertedEnemyX = invertedEnemyX + 100;
        _enemy = Enemy();
        enemies.add(_enemy);
        _enemy.enX = invertedEnemyX;
        _enemy.scale = Vector2(-1.0, 1.0);
      }
      add(_enemy);
    }

    for (Enemy enemy in enemies) {
      if (_player.isCollidingWith(enemy)) {
        // Colisão entre o jogador e o inimigo ocorreu
        // Faça algo em resposta à colisão
        _player.onCollision(Set(), enemy);
        enemy.onCollision(Set(), _player);
      }
    }

    for(Enemy enemy in enemies){
      for(Arrow arrow in arrows){
        if(arrow.isCollidingWith(enemy)){
          arrow.onCollision(Set(), enemy);
          enemy.onCollision(Set(), arrow);
        }
      }
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