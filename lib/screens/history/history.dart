// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futebol_app/hive/games.dart';

import 'package:futebol_app/utils/theme.dart';
import 'package:hive/hive.dart';

import 'components/GameCard.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);
  static String routeName = '/history';
  
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late Box gamesBox;
  late Iterable<dynamic> games;

  void getGames() {
    gamesBox = Hive.box<Games>(gamesBoxName);
    setState(() {
      games = gamesBox.values;
    });
  }

  @override
  void initState() {
    super.initState();
    getGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container (
          margin: const EdgeInsets.only(top: 20.0),
          width: ScreenUtil().screenWidth,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Center(
                        child: FaIcon(FontAwesomeIcons.arrowLeft),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: appComponentsWidth,
                  margin: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    'Histórico',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                for(int i = games.length - 1; i >= 0; i--)
                  GameCard(game: games.elementAt(i))
              ],
            ),
          ),
        )
      ),
    );
  }
}