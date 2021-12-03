import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class BattleRoyale extends StatefulWidget {
  const BattleRoyale({Key? key}) : super(key: key);

  @override
  _BattleRoyaleState createState() => _BattleRoyaleState();
}

class _BattleRoyaleState extends State<BattleRoyale> {
  CollectionReference clubs = FirebaseFirestore.instance.collection('games');
  List users = [];
  List phrases = [];
  List weapons = [];

  List logs = [];
  List aliveUsers = [];
  List deadUsers = [];

  bool showDeads = true;

  ScrollController controller = ScrollController();

  Future<void> getData() async {
    var snap = await clubs.doc("battleroyale").get();
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    users = data['users'];
    aliveUsers = List.from(users);
    phrases = data['phrases'];
    weapons = data['weapons'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _scrollToEnd();
    });
    return Column(
        mainAxisAlignment:
            MainAxisAlignment.center, //,Center Column contents vertically,
        crossAxisAlignment: CrossAxisAlignment.center, //Center
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, //,Center Column contents vertically,
            crossAxisAlignment: CrossAxisAlignment.center, //Center
            children: users.map((e) {
              if (aliveUsers.contains(e)) {
                return Image.asset("images/$e.jpg", height: 70);
              } else {
                return Container(
                  child: const SizedBox(
                    child: Text(
                      "DEAD",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    height: 70,
                    width: 70,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.red.withOpacity(0.3), BlendMode.dstATop),
                      image: AssetImage(
                        "images/$e.jpg",
                      ),
                    ),
                  ),
                );
              }
            }).toList(),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  _buildLogs(),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, //,Center Column contents vertically,
            crossAxisAlignment: CrossAxisAlignment.center, //Center
            children: [
              ElevatedButton(onPressed: _nextLog, child: Text("NEXT")),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(onPressed: _resetGame, child: Text("RESET")),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  onPressed: () {
                    showDeads = !showDeads;
                    setState(() {});
                  },
                  child: Text("DEADS"))
            ],
          ),
        ]);
    /*
    return Stack(children: [
      Center(
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              _buildLogs(),
            ],
          ),
        ),
      ),
      Positioned(
        left: 0,
        top: 0,
        child: Column(
          children: [
            ElevatedButton(onPressed: _nextLog, child: Text("NEXT")),
            SizedBox(
              height: 5,
            ),
            ElevatedButton(onPressed: _resetGame, child: Text("RESET")),
            SizedBox(
              height: 5,
            ),
            ElevatedButton(
                onPressed: () {
                  showDeads = !showDeads;
                  setState(() {});
                },
                child: Text("DEADS"))
          ],
        ),
      ),
      showDeads
          ? Positioned(
              top: 30,
              right: 30,
              child: Column(
                children: users.map((e) {
                  if (aliveUsers.contains(e)) {
                    return Image.asset("images/$e.jpg", height: 70);
                  } else {
                    return Container(
                      child: const SizedBox(
                        child: Text(
                          "DEAD",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        height: 70,
                        width: 70,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.red.withOpacity(0.3), BlendMode.dstATop),
                          image: AssetImage(
                            "images/$e.jpg",
                          ),
                        ),
                      ),
                    );
                  }
                }).toList(),
              ),
            )
          : Container(),
    ]);*/
  }

  void _resetGame() {
    logs = [];
    aliveUsers = List.from(users);
    deadUsers = [];
    setState(() {});
  }

  Widget _buildLogs() {
    return Column(
        children: logs
            .map((e) => Column(children: [
                  e,
                  const SizedBox(
                    height: 10,
                  ),
                ]))
            .toList());
  }

  void _nextLog() {
    if (aliveUsers.length > 1) {
      var phrase = getPhrase();
      logs.add(Text(
        phrase,
        style: const TextStyle(fontSize: 25),
      ));
      logs.add(Text(
        "personas vivas: ${aliveUsers.map((e) => e)}",
        style: const TextStyle(fontSize: 15, color: Colors.grey),
      ));
      setState(() {});
    }
  }

  String getPhrase() {
    var rng = Random();
    var phraseIndex = rng.nextInt(phrases.length);
    String phrase = phrases[phraseIndex];

    if (deadUsers.length == 0 && phrases[phraseIndex].contains("#ur1")) {
      return getPhrase();
    } else if (deadUsers.length < 2 && phrases[phraseIndex].contains("#ur2")) {
      return getPhrase();
    } else if (aliveUsers.length < 2 && phrases[phraseIndex].contains("#ui2")) {
      return getPhrase();
    } else if (aliveUsers.length < 2 && phrases[phraseIndex].contains("#ud2")) {
      return getPhrase();
    } else {
      phrase = phrase.replaceAll("#w1", weapons[rng.nextInt(weapons.length)]);
      phrase = phrase.replaceAll("#w2", weapons[rng.nextInt(weapons.length)]);

      if (phrase.contains("#ud1")) {
        int index = rng.nextInt(aliveUsers.length);
        phrase = phrase.replaceAll("#ud1", aliveUsers[index]);
        deadUsers.add(aliveUsers[index]);
        aliveUsers.remove(aliveUsers[index]);
      }

      if (phrase.contains("#ui1")) {
        int index = rng.nextInt(aliveUsers.length);
        phrase = phrase.replaceAll("#ui1", aliveUsers[index]);
        if (phrase.contains("#ui2")) {
          int index2 = rng.nextInt(aliveUsers.length);
          while (index == index2) {
            index2 = rng.nextInt(aliveUsers.length);
            ;
          }
          phrase = phrase.replaceAll("#ui2", aliveUsers[index2]);
        }
      }

      if (phrase.contains("#ud2")) {
        int index = rng.nextInt(aliveUsers.length);
        phrase = phrase.replaceAll("#ud2", aliveUsers[index]);
        deadUsers.add(aliveUsers[index]);
        aliveUsers.remove(aliveUsers[index]);
      }

      if (phrase.contains("#ur1")) {
        int index = rng.nextInt(deadUsers.length);
        phrase = phrase.replaceAll("#ur1", deadUsers[index]);
        aliveUsers.add(deadUsers[index]);
        deadUsers.remove(deadUsers[index]);
      }

      if (phrase.contains("#ur2")) {
        int index = rng.nextInt(deadUsers.length);
        phrase = phrase.replaceAll("#ur2", deadUsers[index]);
        aliveUsers.add(deadUsers[index]);
        deadUsers.remove(deadUsers[index]);
      }
      return phrase;
    }
  }

  void _scrollToEnd() async {
    controller.animateTo(controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}
