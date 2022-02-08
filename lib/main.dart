import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

enum Results { initial, user, ai, draw }
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicTac Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'TicTac Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //State
  var tiles = List.filled(9, 0);
  int round = 1;
  Results screen = Results.initial;
  int yourScore = 0;
  int aiScore = 0;
  @override
  Widget build(BuildContext context) {
    if (screen == Results.initial) {
      checkWinner(tiles);
    }
    switch (screen) {
      case Results.user:
        //User won Screen
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Result",
                      style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.normal)),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("You Won!",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                      onPressed: () => setState(() {
                            yourScore += 1;
                            resetGame();
                            round += 1;
                            screen = Results.initial;
                          }),
                      child: const Text("Continue",
                          style: TextStyle(fontSize: 20)))
                ],
              ),
            ],
          ),
        );
      case Results.ai:
        //AI won Screen
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Result",
                      style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.normal)),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("You Lost!",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                      onPressed: () => setState(() {
                            aiScore += 1;
                            resetGame();
                            round += 1;
                            screen = Results.initial;
                          }),
                      child: const Text("Continue",
                          style: TextStyle(fontSize: 20)))
                ],
              ),
            ],
          ),
        );
      case Results.draw:
        //Draw Screen
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Result",
                      style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.normal)),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Draw",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                      onPressed: () => setState(() {
                            resetGame();
                            round += 1;
                            screen = Results.initial;
                          }),
                      child: const Text("Continue",
                          style: TextStyle(fontSize: 20)))
                ],
              ),
            ],
          ),
        );
      default:
        //Main Game Screen
        return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("Round $round",
                      style: const TextStyle(fontSize: 20)),
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: [
                      for (int i = 0; i < 9; i++)
                        InkWell(
                          onTap: () {
                            if(tiles[i]!=0){
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Please select another grid"),
                              ));
                              return;
                            }
                            setState(() {
                              tiles[i] = 1;
                              gameEngine();
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1)),
                              child: Text(
                                tiles[i] == 0
                                    ? ''
                                    : tiles[i] == 1
                                        ? "X"
                                        : "O",
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              )),
                        )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Your Score: $yourScore",
                          style: const TextStyle(fontSize: 20)),
                      Text("AI Score: $aiScore",
                          style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            tiles = List.filled(9, 0);
                            yourScore = 0;
                            aiScore = 0;
                            round = 1;
                          });
                        },
                        child: const Text("Restart")),
                    ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Row(
                                      children: const [
                                        Icon(Icons.warning),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: Text("Quit game?"),
                                        ),
                                      ],
                                    ),
                                    content: const Text(
                                        "Are you sure you want to quit game?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            exit(0);
                                          },
                                          child: const Text(
                                            "Yes",
                                            style: TextStyle(color: Colors.red),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "No",
                                          ))
                                    ],
                                  ));
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red)),
                        child: const Text("End Game")),
                  ],
                )
              ],
            ));
    }
  }

  void gameEngine() async {
    await Future.delayed(const Duration(milliseconds: 500));
    int? winning;
    int? blocking;
    int? normal;

    for (int i = 0; i < 9; i++) {
      var val = tiles[i];
      //check if tile is played
      if (val > 0) {
        continue;
      }
      //get winning positions
      var possibleWins = [...tiles]..[i] = 2;

//if AI is play winning tile
      if (isWinning(2, possibleWins)) {
        winning = i;
      }

//if user is winning block winning tile
      possibleWins[i] = 1;
      if (isWinning(1, possibleWins)) {
        blocking = i;
      }
      //AI selected tile in normal plays
      var wantTile = selectTile(tiles);
      normal = wantTile == 404 ? i : wantTile;
    }
    var move = winning ?? blocking ?? normal;

    if (move != null) {
      setState(() {
        tiles[move] = 2;
      });
    }
  }

//Check tiles available
  int selectTile(List<int> tiles) {
    //what AI want to play
    var possPlay = Random().nextInt(9);
    //if user has played that tile
    if (tiles[possPlay] == 1) {
      //can't play tile
      return 404;
    } else {
      return possPlay;
    }
  }

  bool isWinning(int who, List<int> tiles) {
    //check who is winning
    return (tiles[0] == who && tiles[1] == who && tiles[2] == who) ||
        (tiles[3] == who && tiles[4] == who && tiles[5] == who) ||
        (tiles[6] == who && tiles[7] == who && tiles[8] == who) ||
        (tiles[0] == who && tiles[3] == who && tiles[6] == who) ||
        (tiles[1] == who && tiles[4] == who && tiles[7] == who) ||
        (tiles[2] == who && tiles[5] == who && tiles[8] == who) ||
        (tiles[0] == who && tiles[4] == who && tiles[8] == who) ||
        (tiles[2] == who && tiles[4] == who && tiles[6] == who);
  }

  void checkWinner(List<int> titles) async {
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    if (isWinning(1, tiles)) {
      //User won
      setState(() {
        screen = Results.user;
      });
    } else if (isWinning(2, tiles)) {
      //AI won
      setState(() {
        screen = Results.ai;
      });
    } else {
      if (tiles.every((tile) => tile > 0)) {
        //check all tiles are played
        setState(() {
          screen = Results.draw;
        });
      }
      return;
    }
  }

  void resetGame() {
    setState(() {
      tiles = List.filled(9, 0);
    });
  }
}
