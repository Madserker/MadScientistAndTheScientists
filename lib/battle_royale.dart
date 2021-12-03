import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:madscientistandthescientists/models/battle_royale_user.dart';

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

    for (String user in data['users']) {
      users.add(BattleRoyaleUser(name: user));
    }
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, //,Center Column contents vertically,
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

      phrase = killUser(phrase);

      if (phrase.contains("#ui1")) {
        int index = rng.nextInt(aliveUsers.length);
        phrase = phrase.replaceAll("#ui1", aliveUsers[index]);
        if (phrase.contains("#ui2")) {
          int index2 = rng.nextInt(aliveUsers.length);
          while (index == index2) {
            index2 = rng.nextInt(aliveUsers.length);
          }
          phrase = phrase.replaceAll("#ui2", aliveUsers[index2]);
        }
      }

      phrase = resurrectUser(phrase);

      return phrase;
    }
  }

  String killUser(String phrase) {
    var rng = Random();

    if (phrase.contains("#ud1") && phrase.contains("#ui1")) {
      List<int> probs = [];
      int userIndex = 0;
      for (BattleRoyaleUser user in aliveUsers) {
        for (int i = 0; i <= user.attack; i++) {
          probs.add(userIndex);
        }
        userIndex++;
      }

      int index = rng.nextInt(probs.length);
      phrase = phrase.replaceAll("#ui1", aliveUsers[probs[index]].name);

      List<int> probs2 = [];
      int userIndex2 = 0;
      for (BattleRoyaleUser user in aliveUsers) {
        for (int i = 0; i <= user.defense; i++) {
          if (user != aliveUsers[probs[index]]) {
            probs.add(userIndex2);
          }
        }
        userIndex2++;
      }

      int index2 = rng.nextInt(probs2.length);
      phrase = phrase.replaceAll("#ud1", aliveUsers[probs2[index2]].name);
      deadUsers.add(aliveUsers[probs2[index2]]);
      aliveUsers.remove(aliveUsers[probs2[index2]]);
    }

    if (phrase.contains("#ud1")) {
      int index = rng.nextInt(aliveUsers.length);
      phrase = phrase.replaceAll("#ud1", aliveUsers[index]);
      deadUsers.add(aliveUsers[index]);
      aliveUsers.remove(aliveUsers[index]);
    }

    if (phrase.contains("#ud2")) {
      int index = rng.nextInt(aliveUsers.length);
      phrase = phrase.replaceAll("#ud2", aliveUsers[index]);
      deadUsers.add(aliveUsers[index]);
      aliveUsers.remove(aliveUsers[index]);
    }
    return phrase;
  }

  String resurrectUser(String phrase) {
    var rng = Random();

    if (phrase.contains("#ur1")) {
      List<int> probs = [];
      int userIndex = 0;
      for (BattleRoyaleUser user in deadUsers) {
        for (int i = 0; i <= user.luck; i++) {
          probs.add(userIndex);
        }
        userIndex++;
      }

      int index = rng.nextInt(probs.length);
      phrase = phrase.replaceAll("#ur1", deadUsers[probs[index]].name);
      aliveUsers.add(deadUsers[index]);
      deadUsers.remove(deadUsers[index]);
    }

    if (phrase.contains("#ur2")) {
      List<int> probs = [];
      int userIndex = 0;
      for (BattleRoyaleUser user in deadUsers) {
        for (int i = 0; i <= user.luck; i++) {
          probs.add(userIndex);
        }
        userIndex++;
      }

      int index = rng.nextInt(probs.length);
      phrase = phrase.replaceAll("#ur2", deadUsers[probs[index]].name);
      aliveUsers.add(deadUsers[index]);
      deadUsers.remove(deadUsers[index]);
    }
    return phrase;
  }

  void _scrollToEnd() async {
    controller.animateTo(controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}
