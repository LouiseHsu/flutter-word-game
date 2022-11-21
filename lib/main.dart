// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'dart:math';
import 'package:dictionaryx/dictionary_sa.dart';
import 'game.dart';
import 'grid-puzzle.dart';
import 'package:audioplayers/audioplayers.dart';


const letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];
const letterPoints = [1, 2, 2, 2, 1, 2, 2, 2, 1, 3, 3, 1, 2, 1, 1, 2, 5, 1, 1, 1, 1, 2, 1, 3, 3, 3];
const List<Tuple2> enemyList = [
  Tuple2(4, 'assets/images/blue-slime.gif'),
  Tuple2(8, 'assets/images/pink-slime.gif'),
  Tuple2(12, 'assets/images/green-slime.gif')
];

const int playerMaxHealth = 5;

final dMSAJson = DictionarySA();

void main() {
  runApp(const MyApp());
  dMSAJson.hasEntry(""); // load the dict into memory to avoid lag - is there a better way to do this?
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: PuzzleContainerState(),
      ),
    );
  }
}

class PuzzleContainerState extends StatefulWidget {
  const PuzzleContainerState({Key? key}) : super(key: key);
  @override
  State<PuzzleContainerState> createState() => _PuzzleContainerState();
}

class _PuzzleContainerState extends State<PuzzleContainerState> {
  var score = 0;
  var playerHealth = playerMaxHealth;
  int numEnemyIndex = 0;
  Tuple2 currEnemy = enemyList[0];
  var enemyHealth = enemyList[0].item1;

  bool playerAttacking = false;
  bool enemyAttacking = false;

  void enemyAttack() {
    Future.delayed(const Duration(milliseconds: 500), ()
    async {
      setState(() {
        enemyAttacking = true;
      });
      var audioPlayer = AudioPlayer();
      await audioPlayer.play(
        AssetSource('sounds/hit.mp3'),
        volume: 0.5
      );
      Future.delayed(const Duration(milliseconds: 200), () {
        changePlayerHealthBy(-1);
      });
    });
  }

  void playerAttack(int damage) {

    setState(() {
      playerAttacking = true;
      score += damage.abs() * 100;
    });
    var audioPlayer = AudioPlayer();
    audioPlayer.play(
        AssetSource('sounds/hit.mp3'),
        volume: 0.5
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      changeEnemyHealthBy(damage);
    });
  }

  int changePlayerHealthBy(int delta) {
    enemyAttacking = false;
    if (playerHealth + delta > 0) {
      setState(() {
        playerHealth += delta;
      });
    } else {
      // initiate game over
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => GameOverScreen(score: score)));
    }
    return playerHealth;
  }

  int changeEnemyHealthBy(int delta) {
    playerAttacking = false;
    if (enemyHealth + delta > 0) {
      setState(() {
        enemyHealth += delta;
      });
      enemyAttack();
    } else {
      setState(() {
        enemyHealth = 0;
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            numEnemyIndex = (numEnemyIndex += 1) % enemyList.length;
            currEnemy = enemyList[numEnemyIndex];
            enemyHealth = currEnemy.item1;
            playerHealth = playerMaxHealth;
          });
        });
      });
    }
    return enemyHealth;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xff0c4438),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                GameView(playerHealth: playerHealth, enemyHealth: enemyHealth, enemyImage: currEnemy.item2, playerAttacking: playerAttacking, enemyAttacking: enemyAttacking,),
                Positioned(
                  top: 75,
                  child:
                    Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white
                      ),
                    ),
                )
              ]
            ),
            WordPuzzleState(playerAttack: playerAttack, enemyAttack: enemyAttack)
          ],
        )
    );
  }
}
class GameOverScreen extends StatefulWidget {
  final int score;
  const GameOverScreen({Key? key,
    required this.score}) : super(key: key);

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "YOU DIED",
                style: TextStyle(
                    color: Colors.red,
                    letterSpacing: 3.0,
                    fontSize: 30.0
                ),
              ),
              Text(
                "Score: ",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 30.0
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyApp()));
                  },
                  child: Text(
                    'Retry?',
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red
                  )),
            ]
        ),
      ),
    );
  }
}



