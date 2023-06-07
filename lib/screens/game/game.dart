import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futebol_app/hive/games.dart';
import 'package:hive/hive.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);
  static String routeName = '/game';

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  Map<String, dynamic>? args;
  late Box gamesBox;
  
  bool paused = false;
 
  int times = 2;
  int goalsA = 0;
  int goalsB = 0;
  String teamA = '';
  String teamB = '';
  String duration = '';

  void pause() {
    setState(() {
      paused = true;
    });
  }

  void getInfos() {
    if(args?['id'] != null) {
      Games currentGameInfos = gamesBox.get(args?['id'].toString());
      setState(() {
        times = currentGameInfos.times;
        goalsA = currentGameInfos.goalsA;
        goalsB = currentGameInfos.goalsB;
        teamA = currentGameInfos.teamA;
        teamB = currentGameInfos.teamB;
        duration = currentGameInfos.duration;
      });
    }
    else {
      // ignore: avoid_print
      print('[ ERROR: Missing game id on game start ]');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    getInfos();
  }

  @override
  void initState() {
    super.initState();
    gamesBox = Hive.box<Games>(gamesBoxName);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/soccer-field.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            SizedBox(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
            ),

            // PAUSE BTN
            Positioned(
              left: ScreenUtil().screenWidth * .03,
              top: ScreenUtil().screenWidth * .03,
              child: GestureDetector(
                onTap: pause,
                child: Container(
                  width: ScreenUtil().screenWidth * .05,
                  height: ScreenUtil().screenWidth * .05,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
                  child: Center(
                    child: FaIcon(
                      paused ? FontAwesomeIcons.play : FontAwesomeIcons.pause,
                      size: 18,
                    )
                  )
                ),
              )
            ),

            // UNDO BTN
            Positioned(
              right: ScreenUtil().screenWidth * .03,
              top: ScreenUtil().screenWidth * .03,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: ScreenUtil().screenWidth * .05,
                  height: ScreenUtil().screenWidth * .05,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.arrowRotateLeft,
                      size: 18,
                    )
                  )
                ),
              )
            ),

            // TIMER
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: ScreenUtil().screenWidth * .085,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: ScreenUtil().screenWidth * .2,
                  height: ScreenUtil().screenWidth * .06,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    )
                  ),
                  child: const Center(
                    child: Text(
                      '00:35',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ),
                )
              )
            ),
            
            // TEAMS ROW
            Positioned(
              left: 0,
              right: 0,
              top: ScreenUtil().screenWidth * .04,
              bottom: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    Container(
                      width: ScreenUtil().screenWidth * 0.7,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [ Colors.red[800]!, Colors.red, Colors.blue, Colors.blue[800]!],
                          stops: const [0.0, 0.35, 0.65, 1.0],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        )
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: SizedBox(
                        width: ScreenUtil().screenWidth * 0.7,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 40),
                              child: Text(
                                teamA,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 40),
                              child: Text(
                                teamB,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ],
                )
              ),
            ),
            
            // SCORE
            Positioned(
              left: 0,
              right: 0,
              top: ScreenUtil().screenWidth * .01,
              bottom: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: ScreenUtil().screenWidth * .15,
                  height: ScreenUtil().screenWidth * .05,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: Center(
                    child: Text(
                      '$goalsA X $goalsB',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ),
                )
              )
            ),

            // GOAL TEAM A BTN
            Positioned(
              left: ScreenUtil().screenWidth * .03,
              bottom: ScreenUtil().screenWidth * .03,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: ScreenUtil().screenWidth * .1,
                  height: ScreenUtil().screenWidth * .1,
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                    borderRadius: const BorderRadius.all(Radius.circular(50))
                  ),
                  child: const Center(
                    child: Text(
                      '+1',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  )
                ),
              )
            ),
            // GOAL TEAM B BTN
            Positioned(
              right: ScreenUtil().screenWidth * .03,
              bottom: ScreenUtil().screenWidth * .03,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: ScreenUtil().screenWidth * .1,
                  height: ScreenUtil().screenWidth * .1,
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: const BorderRadius.all(Radius.circular(50))
                  ),
                  child: const Center(
                    child: Text(
                      '+1',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    )
                  )
                ),
              )
            )
          ],
        )
      ),
    );
  }
}
