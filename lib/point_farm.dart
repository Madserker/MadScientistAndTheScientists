import 'package:flutter/material.dart';

class PointFarm extends StatefulWidget {
  const PointFarm({Key? key}) : super(key: key);

  @override
  _PointFarmState createState() => _PointFarmState();
}

class _PointFarmState extends State<PointFarm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("images/monster_01.png"),
      ],
    );
  }
}
