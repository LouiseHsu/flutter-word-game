// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';
import 'package:dictionaryx/dictionary_sa.dart';
import 'game.dart';
import 'grid-puzzle.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_markdown/flutter_markdown.dart';



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

    SystemSound.play(SystemSoundType.click);

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
                ),
                Positioned(
                  top: 45,
                  right: 25,
                  child:
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InstructionScreen()));
                    },
                    icon: const Icon (
                      Icons.question_mark,
                      color: Colors.white,
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
                'Score: ${widget.score}',
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

const String instructions = """
Help Mr. Fox battle his way through legions of slimes by spelling words! 

1. To do damage, create words using letters on the board - words must be at least **3** letters in length and be a valid word in the Oxford dictionary.

2. Damage is calculated based off of length as well as rarity of letters: White = 0.5 DMG, Green = 1 DMG, Blue = 1.5 DMG.

3. If you get stuck, you can use your shuffle ability to rearrange the board, but be warned - you will sacrifice a turn and take some damage!

4. After you defeat an enemy, you regenerate health and gain some extra score. The words are unlimited, and the slimes, endless - how many can you take out before you're overwhelmed?
""";

class InstructionScreen extends StatelessWidget {
  const InstructionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        title: const Text('How To Play'),
      ),
      body : Markdown(
          data: instructions,
          shrinkWrap: true,
          styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(
              textTheme: const TextTheme(
                  bodyText2: TextStyle(
                      fontSize: 16.0, color: Colors.white70),
                  headline1: TextStyle(
                      color: Colors.white70)
            )
          )
        )
      ),

    );
  }
}



