import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
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
          Text(
            "Score: 200"
          ),
          Container(
            color: Colors.blue,
            height: 300
          ),
          Stack(
            children: [
              Container(
                  color: Color(0xff0c4438),
                  height: 30,
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
              Player(health: widget.playerHealth, enemyAttacking: widget.enemyAttacking),
              Enemy(enemyHealth: widget.enemyHealth, enemyImage: widget.enemyImage, playerAttacking: widget.playerAttacking),
            ],
          )
        ]
    );
  }
}

class Player extends StatefulWidget {
  final int health;
  final bool enemyAttacking;
  const Player({Key? key,
    required this.health,
    required this.enemyAttacking}) : super(key: key);

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
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column (
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
                padding: const EdgeInsets.only(bottom: 10, left: 50, right: 50),
                child: Image.asset('assets/images/fox.gif')
            ),
          ],
        ),
        Positioned(
          bottom: 10,
          child: Opacity(
              opacity: widget.enemyAttacking ? 1.0 : 0.0,
              child: Image.asset(
                'assets/images/attack-left.gif',
              )
          )
        )
      ]
    );
  }
}

class Enemy extends StatefulWidget {
  final enemyHealth;
  final enemyImage;
  final bool playerAttacking;
  const Enemy({Key? key,
    required this.enemyHealth,
    required this.enemyImage,
    required this.playerAttacking}) : super(key: key);

  @override
  State<Enemy> createState() => _EnemyState();
}

class _EnemyState extends State<Enemy> {
  void nextEnemy() {
    return;
  }

  List<Image> healthDisplay() {
    List<Image> list = [];
    for (int i  = 0; i < widget.enemyHealth - 1; i+=2 ) {
      list.add(Image.asset('assets/images/heart.png'));
    }

    if (widget.enemyHealth % 2 == 1) {
      list.add(Image.asset('assets/images/heart-half.png'));
    }

    return list;

    // return List.generate(widget.enemyHealth, (i) =>
    //
    //     Image.asset('assets/images/heart.png')).toList(); // replace * with your rupee or use Icon instead
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column (
          children: [
            Container(
              height: 30,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: healthDisplay(),
              ),
            ),
            Container (
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Image.asset(
                    widget.enemyImage,
                  scale: 0.75,

                )
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          child: Opacity(
            opacity: widget.playerAttacking ? 1.0 : 0.0,
            child: Image.asset(
              'assets/images/attack-right.gif',
              scale: 2.0,
            )
          )
        )
      ]
    );
  }
}



