import 'package:flutter/material.dart';

class ClubDetail extends StatefulWidget {
  const ClubDetail({Key? key}) : super(key: key);

  @override
  _ClubDetailState createState() => _ClubDetailState();
}

class _ClubDetailState extends State<ClubDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Bienvenido choto de mierda"),
        ElevatedButton(
            onPressed: () {}, child: const Text("GET SOME POINTS YOU LOSER")),
        ElevatedButton(onPressed: () {}, child: const Text("ENTER THE STORE")),
        ElevatedButton(
            onPressed: () {}, child: const Text("SEND EMAIL TO OTHER CLAN")),
      ],
    );
  }
}
