import 'package:flutter/material.dart';
import '';

class GameView extends StatefulWidget {
  final int playerHealth;
  final int enemyHealth;
  const GameView({Key? key, required this.playerHealth, required this.enemyHealth}) : super(key: key);

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
          Container(
            color: Colors.green,
            height: 100,
            alignment: Alignment.centerLeft,
          ),
          Container(
            color: Colors.brown,
            height: 20,
            alignment: Alignment.bottomCenter,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Player(health: widget.playerHealth),
              Enemy(health: widget.enemyHealth),
            ],
          )

        ]
    );
  }
}

class Player extends StatefulWidget {
  final health;
  const Player({Key? key,
    required this.health}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {

  List<Image> healthDisplay() {
    return List.generate(widget.health, (i) => Image.asset('assets/images/heart.png')).toList(); // replace * with your rupee or use Icon instead
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
  final health;
  const Enemy({Key? key,
    required this.health}) : super(key: key);

  @override
  State<Enemy> createState() => _EnemyState();
}

class _EnemyState extends State<Enemy> {
  void nextEnemy() {
    return;
  }

  List<Image> healthDisplay() {
    return List.generate(widget.health, (i) => Image.asset('assets/images/heart.png')).toList(); // replace * with your rupee or use Icon instead
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


