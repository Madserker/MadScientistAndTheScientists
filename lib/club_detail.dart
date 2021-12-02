import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClubDetail extends StatefulWidget {
  const ClubDetail({Key? key}) : super(key: key);

  @override
  _ClubDetailState createState() => _ClubDetailState();
}

class _ClubDetailState extends State<ClubDetail> {
  CollectionReference clubs = FirebaseFirestore.instance.collection('clubs');

  @override
  void initState() {
    super.initState();
    print("aaaaa");
    print(clubs);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: clubs.doc("choto").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          int points = 0;

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            points = data['points'];
          }

          return Column(
            children: [
              const Text("Bienvenido choto de mierda"),
              ElevatedButton(
                  onPressed: () {},
                  child: const Text("GET SOME POINTS YOU LOSER")),
              ElevatedButton(
                  onPressed: () {}, child: const Text("ENTER THE STORE")),
              ElevatedButton(
                  onPressed: () {},
                  child: const Text("SEND EMAIL TO OTHER CLAN")),
              Text("you have $points points"),
              Text("you have 0 cards"),
            ],
          );
        });
  }
}
