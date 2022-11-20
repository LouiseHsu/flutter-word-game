import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '';

class GameView extends StatefulWidget {
  final int playerHealth;
  final int enemyHealth;
  final String enemyImage;
  final bool playerAttacking;
  final bool enemyAttacking;
  const GameView({Key? key,
    required this.playerHealth,
    required this.enemyHealth,
    required this.enemyImage,
    required this.playerAttacking,
    required this.enemyAttacking
  }) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
        children : [
          Container(
            color: Colors.blue,
            height: 300
          ),
          Stack(
            children: [
              Container(
                  color: Color(0xff0c4438),
                  height: 100,
              ),
              Positioned(
                height: 30,
                child: Image.asset(
                  'assets/images/grass-tile.png',
                  width: 500,
                  repeat: ImageRepeat.repeatX,
                  scale: 0.25,
                )
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Player(health: widget.playerHealth),
              Enemy(enemyHealth: widget.enemyHealth, enemyImage: widget.enemyImage),
            ],
          )
        ]
    );
  }
}

class Player extends StatefulWidget {
  final int health;
  const Player({Key? key,
    required this.health}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {

  List<Image> healthDisplay() {
    return widget.health > 0 ?
    List.generate(widget.health, (i) => Image.asset('assets/images/heart.png')).toList() :
    []; // replace * with your rupee or use Icon instead
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: healthDisplay(),
          ),
        ),
        Container (
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(bottom: 90, left: 50, right: 50),
          child: Image.asset('assets/images/fox.gif')
        ),
      ]
    );
  }
}

class Enemy extends StatefulWidget {
  final enemyHealth;
  final enemyImage;
  const Enemy({Key? key,
    required this.enemyHealth,
    required this.enemyImage}) : super(key: key);

  @override
  State<Enemy> createState() => _EnemyState();
}

class _EnemyState extends State<Enemy> {
  void nextEnemy() {
    return;
  }

  List<Image> healthDisplay() {
    return List.generate(widget.enemyHealth, (i) => Image.asset('assets/images/heart.png')).toList(); // replace * with your rupee or use Icon instead
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: healthDisplay(),
            ),
          ),
          Container (
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 50, left: 50, right: 50),
              child: Image.asset(
                widget.enemyImage,
                scale: 0.75,
              )
          )
        ]
    );
  }
}


