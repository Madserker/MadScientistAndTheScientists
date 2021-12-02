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
  List deadUsers = [];
  List aliveUsers = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: clubs.doc("battleroyale").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            users = data['users'];
            aliveUsers = users;
            phrases = data['phrases'];
            weapons = data['weapons'];
          }
          return Column(
            children: [
              SingleChildScrollView(
                child: _buildLogs(),
              ),
              ElevatedButton(onPressed: _nextLog, child: Text("NEXT"))
            ],
          );
        });
  }

  Widget _buildLogs() {
    return Column(children: logs.map((e) => Text(e)).toList());
  }

  void _nextLog() {
    var rng = Random();
    var phraseIndex = rng.nextInt(phrases.length);
    var aliveIndex = rng.nextInt(aliveUsers.length);
    var infoIndex = rng.nextInt(aliveUsers.length);
    var deadIndex = rng.nextInt(aliveUsers.length);
    //var resurrectedIndex = rng.nextInt(deadUsers.length);
    var weaponIndex = rng.nextInt(weapons.length);

    var phrase = phrases[phraseIndex];

    if (phrase.contains("#ud1")) {
      phrase = phrase.replaceAll("#ud1", users[deadIndex]);
      deadUsers.add(users[deadIndex]);
      aliveUsers.remove(users[deadIndex]);
    }
    if (phrase.contains("#ui1")) {
      phrase = phrase.replaceAll("#ui1", users[infoIndex]);
    }
    if (phrase.contains("#w1")) {
      phrase = phrase.replaceAll("#w1", weapons[weaponIndex]);
    }

    logs.add(phrase);
    setState(() {});
  }
}
