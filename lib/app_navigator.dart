import 'package:flutter/material.dart';
import 'package:madscientistandthescientists/battle_royale.dart';
import 'package:madscientistandthescientists/club_detail.dart';
import 'package:madscientistandthescientists/login_page.dart';
import 'package:madscientistandthescientists/point_farm.dart';

class AppNavigatorRoutes {
  static const String login = "/login";
  static const String clubDetail = "/clubDetail";
  static const String pointFarm = "/pointFarm";
  static const String battleRoyale = "/battleRoyale";
}

class AppNavigator extends StatefulWidget {
  AppNavigator({
    Key? key,
  }) : super(key: key);

  @override
  _AppNavigatorState createState() => _AppNavigatorState();
}

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class _AppNavigatorState extends State<AppNavigator> {
  bool? onBoardingShown;
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {}

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: appNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case AppNavigatorRoutes.login:
                  return const LoginPage();
                case AppNavigatorRoutes.clubDetail:
                  return const ClubDetail();
                case AppNavigatorRoutes.pointFarm:
                  return const PointFarm();
                case AppNavigatorRoutes.battleRoyale:
                  return const BattleRoyale();
                default:
                  return const LoginPage();
              }
            });
      },
    );
  }
}
