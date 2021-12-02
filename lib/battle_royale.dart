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
        left: 30,
        top: 30,
        child: Column(
          children: [
            ElevatedButton(onPressed: _nextLog, child: Text("NEXT")),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: _resetGame, child: Text("RESET"))
          ],
        ),
      )
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
                  Text(
                    e,
                    style: const TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ]))
            .toList());
  }

  void _nextLog() {
    if (aliveUsers.length > 1) {
      var phrase = getPhrase();
      logs.add(phrase);
      logs.add("personas vivas: ${aliveUsers.map((e) => e)}");
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

      if (phrase.contains("#ui1")) {
        int index = rng.nextInt(aliveUsers.length);
        phrase = phrase.replaceAll("#ui1", aliveUsers[index]);
        if (phrase.contains("#ui2")) {
          int index2 = rng.nextInt(deadUsers.length);
          if (index == index2) {
            getPhrase();
          }
          phrase = phrase.replaceAll("#ui2", aliveUsers[index2]);
        }
      }
      return phrase;
    }
  }

  void _scrollToEnd() async {
    controller.animateTo(controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}
