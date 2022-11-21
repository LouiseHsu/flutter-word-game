import 'package:flutter/material.dart';
import 'package:dictionaryx/dictionary_sa.dart';
import 'package:tuple/tuple.dart';
import 'dart:math';


const letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];
const letterPoints = [1, 2, 2, 2, 1, 2, 2, 2, 1, 3, 3, 1, 2, 1, 1, 2, 5, 1, 1, 1, 1, 2, 1, 3, 3, 3];
const List<Tuple2> enemyList = [
  Tuple2(5, 'assets/images/blue-slime.gif'),
  Tuple2(10, 'assets/images/pink-slime.gif'),
  Tuple2(15, 'assets/images/green-slime.gif')
];

const int playerMaxHealth = 5;


final dMSAJson = DictionarySA();

class CurrentAttackDisplay extends StatefulWidget {
  final int currentDamage;
  const CurrentAttackDisplay({Key? key, required this.currentDamage}) : super(key: key);

  @override
  State<CurrentAttackDisplay> createState() => _CurrentAttackDisplayState();
}

class _CurrentAttackDisplayState extends State<CurrentAttackDisplay> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
        maintainSize: true,
        maintainState: true,
        maintainAnimation: true,
        visible: widget.currentDamage == 0 ? false : true,
        child: Text(
            style: const TextStyle(
                fontSize: 20,
                color: Colors.red
            ),
            '${widget.currentDamage} DMG'
        )
    );
  }
}

class WordPuzzleState extends StatefulWidget {
  final playerAttack;
  final enemyAttack;
  const WordPuzzleState({Key? key,
    required this.playerAttack,
    required this.enemyAttack}) : super(key: key);

  @override
  State<WordPuzzleState> createState() => _WordPuzzleState();
}

class _WordPuzzleState extends State<WordPuzzleState> {
  // var dMSAJson = DictionaryMSA();

  static const cols = 4;
  static const rows = 4;
  var currentWord = "";
  var currentDamage = 0;
  var validWord = false;

  void updateCurrentWord(String char) {
    setState(() {
      currentWord = '$currentWord$char';
    });
    checkIfStringIsWord(currentWord);
  }

  bool checkIfStringIsWord(String candidate) {
    if (candidate.length < 3) {
      return validWord;
    }
    setState(() {
      validWord = dMSAJson.hasEntry(candidate);
      if (validWord) {
        calculateDamage(candidate);
      }
    });
    return validWord;
  }

  int calculateDamage(String candidate) {
    setState(() {
      currentDamage = candidate.length~/1;
      print(currentDamage);
    });
    return currentDamage;
  }

  void submitAttack() {
    widget.playerAttack(-currentDamage);
  }

  static Random random = Random();

  var tiles = List.generate(rows,
          (i) => List.generate(cols, (j) => Tuple2(random.nextInt(25), -1), // Tuple<Character, Position in Word>
          growable: false),growable: false);

  static Tuple2<int, int> convert1dTo2dIndex(int index){
    // eg. 15 -> 3, 3
    var one = index / 4;
    var two = index % 4;
    return Tuple2(two.toInt(), one.toInt());
  }

  resetTiles() {
    setState(() {
      currentWord = "";
      validWord = false;
      currentDamage = 0;
      for (var x = 0; x < tiles.length; x++) {
        for (var y = 0; y < tiles[0].length; y++) {
          tiles[x][y] = Tuple2(tiles[x][y].item1, -1);
        }
      }
    });
  }

  shuffleTiles() {
    setState(() {
      currentWord = "";
      validWord = false;
      currentDamage = 0;
      for (var x = 0; x < tiles.length; x++) {
        for (var y = 0; y < tiles[0].length; y++) {
          tiles[x][y] = Tuple2(random.nextInt(25), -1);
        }
      }
    });
    widget.enemyAttack();
  }

  loadNewTiles() {
    setState(() {
      currentWord = "";
      validWord = false;
      currentDamage = 0;
      for (var x = 0; x < tiles.length; x++) {
        for (var y = 0; y < tiles[0].length; y++) {
          if (tiles[x][y].item2 != -1) {
            tiles[x][y] = Tuple2(random.nextInt(25), -1);
          }
        }
      }
    });
  }

  static Color getTileColor(int value) {
    if (value == 1) {
      return Colors.greenAccent;
    }
    if (value == 2) {
      return Colors.yellowAccent;
    }
    if (value == 3) {
      return Colors.pinkAccent;
    }
    return Colors.transparent; //default
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          CurrentAttackDisplay(currentDamage: currentDamage),
          GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(30.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  crossAxisCount: 4,
                  mainAxisSpacing: 10),
              itemCount: 16,
              itemBuilder: (BuildContext ctx, index) {
                var matrixIndex = convert1dTo2dIndex(index);
                int tileValue = tiles[matrixIndex.item1][matrixIndex.item2].item1;
                int tilePressed = tiles[matrixIndex.item1][matrixIndex.item2].item2;

                return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      disabledBackgroundColor: Colors.transparent,
                      padding: EdgeInsets.all(0.0),
                      animationDuration: Duration.zero,
                      alignment: Alignment.center,
                      // backgroundColor:
                      //     MaterialStatePropertyAll<Color>(getTileColor(letterPoints[tileValue]))
                    ),
                    onPressed: tiles[matrixIndex.item1][matrixIndex.item2].item2 == -1 ? () {
                      setState(() {
                        updateCurrentWord(letters[tileValue]);
                        print('hi1');
                        tiles[matrixIndex.item1][matrixIndex.item2] = Tuple2(tileValue, currentWord.length - 1);
                        print('hi2');
                      });
                    } : null,
                    child: Container(
                        padding: const EdgeInsets.all(0.0),
                        constraints: BoxConstraints.expand(),
                        // decoration: const BoxDecoration(
                        //   image: DecorationImage(
                        //     image: AssetImage('assets/images/tile.png'),
                        //     fit: BoxFit.cover
                        //   )
                        // ),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(letters[tileValue].toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ))
                        )
                    ));
              }),

          LetterChoices(
              currentWord: currentWord,
              resetTiles: resetTiles,
              shuffleTiles: shuffleTiles,
              validWord: validWord,
              submitWord: submitAttack,
              loadNewTiles: loadNewTiles)]
    );
  }
}


class LetterChoices extends StatefulWidget {
  final String currentWord;
  final bool validWord;
  final Function resetTiles;
  final Function loadNewTiles;
  final Function shuffleTiles;
  final Function submitWord;
  const LetterChoices({Key? key,
    required this.currentWord,
    required this.resetTiles,
    required this.shuffleTiles,
    required this.validWord,
    required this.submitWord,
    required this.loadNewTiles}) : super(key: key);

  @override
  State<LetterChoices> createState() => _LetterChoicesState();
}

class _LetterChoicesState extends State<LetterChoices> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(50.0),
        child: Stack(
            children: [
              Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 2, color: Colors.grey)
                      )
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                          text: TextSpan (
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0
                              ),
                              text: widget.currentWord
                          )
                      )
                  )
              ),
              Row (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      style: IconButton.styleFrom(

                        padding: EdgeInsets.all(0.0),
                        backgroundColor: Color(0xff0c4438)
                      ),
                      onPressed: () {
                        widget.resetTiles();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      )
                    )
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          style: IconButton.styleFrom(
                              padding: EdgeInsets.all(0.0),
                              backgroundColor: Color(0xff0c4438)
                          ),
                          onPressed: () {
                            widget.shuffleTiles();
                          },
                          icon: const Icon(
                            Icons.shuffle,
                            color: Colors.white,
                          )
                      )
                  ),
                ]
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton( // Submit Button
                      style: ButtonStyle(
                          backgroundColor: widget.validWord ? const MaterialStatePropertyAll(Colors.green) : const MaterialStatePropertyAll(Colors.red)
                      ),
                      onPressed: () {
                        widget.submitWord();
                        widget.loadNewTiles();
                      },
                      child: const Icon(
                          Icons.check
                      )
                  )
              )
            ]
        )
    );
  }
}