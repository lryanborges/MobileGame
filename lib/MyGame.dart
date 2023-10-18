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
  late TextComponent tt;
  late ParallaxComponent para = ParallaxComponent();

  double enemyX = -300;
  double intervaloX = 200;
  double invertedEnemyX = 1000;
  int qtdInimigos = 0;
  int pontos = 0;
  bool gameOver = false;
  int timer = 0;

  final tStyle = TextPaint(
    style: TextStyle(
        fontSize: 36.0,
        color: BasicPalette.white.color,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold
    ),
  );

  final tStyle2 = TextPaint(
    style: TextStyle(
        fontSize: 36.0,
        color: BasicPalette.black.color,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold
    ),
  );

    @override
    Future<void> onLoad() async {

      final images = [
        loadParallaxImage('background.png', repeat: ImageRepeat.repeat),
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

      para = parallaxComponent;

      add(parallaxComponent);

      _enemy = Enemy();

      _player = Player();
      add(_player);

      _arrow = Arrow();

      tt = TextComponent(
        text: "> press anywhere to start <",
        textRenderer: tStyle,
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2 + 25),
      );

      add(tt);

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
    para.parallax?.baseVelocity = Vector2.zero();
    if(!_player.gameOver){
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
    }

  }

  @override
  void update(double dt) {
    super.update(dt);
    gameOver = _player.gameOver;

    tc.text = "Score: " + pontos.toString();

    if(para.parallax?.baseVelocity == Vector2.zero()){
      tt.text = "";
      if (qtdInimigos < 50) {
        qtdInimigos++;
        if(qtdInimigos == 20){
          intervaloX =  150;
        }
        if(qtdInimigos == 40){
          intervaloX = 100;
        }
        if(qtdInimigos % 2 == 0){
          enemyX = enemyX - intervaloX;
          _enemy = Enemy();
          enemies.add(_enemy);
          _enemy.enX = enemyX;
        } else {
          invertedEnemyX = invertedEnemyX + intervaloX;
          _enemy = Enemy();
          enemies.add(_enemy);
          _enemy.enX = invertedEnemyX;
          _enemy.scale = Vector2(-1.0, 1.0);
        }
        add(_enemy);
    }

    } else {
      timer++;
      if(timer % 30 == 0){
        tt.textRenderer = tStyle2;
      }
      if(timer % 61 == 0){
        tt.textRenderer = tStyle;
      }
    }

    if(!gameOver){
      for (Enemy enemy in enemies) {
        if (_player.isCollidingWith(enemy)) {
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
    }

    if(_player.gameOver == true){
      tt.text = "Game Over";
      tt.textRenderer = tStyle;
    }

  }

}