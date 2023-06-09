import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futebol_app/hive/games.dart';
import 'package:futebol_app/screens/home/home.dart';
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'components/timer.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);
  static String routeName = '/game';

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  final GlobalKey<CountdownState> _timerKey = GlobalKey<CountdownState>();
  Map<String, dynamic>? args;
  late Box gamesBox;
  
  bool paused = false;
  int currentTime = 1;

  int times = 2;
  int goalsA = 0;
  int goalsB = 0;
  String teamA = '';
  String teamB = '';
  String duration = '';
  List<String> lastActions = [];

  void pause() {
    setState(() {
      paused = true;
    });
    _timerKey.currentState?.pauseTimer();
    showMenu('Menu', true);
  }

  void resume() {
    Navigator.pop(context);
    setState(() {
      paused = false;
    });
    _timerKey.currentState?.resumeTimer();
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

  void showMenu(String title, bool showClose) {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,

      builder: (context) => Center(
        child: Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                top: ScreenUtil().screenHeight * .20/2,
                left: ScreenUtil().screenWidth * .25,
                child: Container(
                  width: ScreenUtil().screenWidth * .5,
                  height: ScreenUtil().screenHeight * .75,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          if(showClose)
                            GestureDetector(
                              onTap: resume,
                              child: const SizedBox(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.xmark,
                                  ),
                                ),
                              ),
                            )
                          else
                            const SizedBox(
                              width: 50,
                              height: 50,
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 80),
                        child: ElevatedButton(
                          onPressed: addTimer,
                          child: const Text(
                            '+1 min acréscimo',
                            style: TextStyle(
                              fontSize: 18
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 20
                        ),
                        child: OutlinedButton(
                          onPressed: () {
                            confirmFinishGameMenu(false);
                          },
                          style: ButtonStyle(
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(
                                width: 2.0,
                                color: Colors.red
                              )
                            ),
                          ),
                          child: const Text(
                            'Encerrar Partida',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void confirmFinishGameMenu(bool startSecondTime) {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,

      builder: (context) => Center(
        child: Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                top: ScreenUtil().screenHeight * .20/2,
                left: ScreenUtil().screenWidth * .25,
                child: Container(
                  width: ScreenUtil().screenWidth * .5,
                  height: ScreenUtil().screenHeight * .75,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            startSecondTime ? 'Iniciar 2o tempo?' : 'Deseja encerrar a partida?',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          if(!startSecondTime)
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const SizedBox(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.xmark,
                                  ),
                                ),
                              ),
                            )
                          else 
                            const SizedBox(
                              width: 50,
                              height: 50,
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 80),
                        child: ElevatedButton(
                          onPressed: startSecondTime ? resume : finishGame,
                          child: const Text(
                            'Sim',
                            style: TextStyle(
                              fontSize: 18
                            ),
                          ),
                        ),
                      ),
                      if(!startSecondTime)
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical: 20
                          ),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                  width: 2.0,
                                  color: Colors.red
                                )
                              ),
                            ),
                            child: const Text(
                              'Não',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.red
                              ),
                            ),
                          ),
                        )
                    ],
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void finishGame() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      HomeScreen.routeName,
      (Route<dynamic> route) => false,
    );
  }

  void addTimer() {
    _timerKey.currentState?.addTime(const Duration(minutes: 1));
    resume();
  }

  void goal(String team) {
    Games game = gamesBox.get(args?['id'].toString());
    lastActions.add(team);

    gamesBox.put(args?['id'].toString(), Games(
      duration: game.duration,
      goalsA: game.goalsA + (team == 'A' ? 1 : 0),
      goalsB: game.goalsB + (team == 'B' ? 1 : 0),
      times: game.times,
      teamA: game.teamA,
      teamB: game.teamB,
    ));
    if (team == 'A') {
      setState(() {
        goalsA = goalsA + 1;
      });
    } else {
      setState(() {
        goalsB = goalsB + 1;
      });
    }
  }

  void undo() {
    final lastIndex = lastActions.length - 1;
    if (lastIndex >= 0) {
      Games game = gamesBox.get(args?['id'].toString());
      String lastActionTeam = lastActions[lastIndex];

      gamesBox.put(args?['id'].toString(), Games(
        duration: game.duration,
        goalsA: game.goalsA - (lastActionTeam == 'A' ? 1 : 0),
        goalsB: game.goalsB - (lastActionTeam == 'B' ? 1 : 0),
        times: game.times,
        teamA: game.teamA,
        teamB: game.teamB,
      ));
      if (lastActionTeam == 'A') {
        setState(() {
          goalsA = goalsA - 1;
        });
      } else {
        setState(() {
          goalsB = goalsB - 1;
        });
      }
      lastActions.removeAt(lastIndex);
    }
  }

  void timerEndedHandle() {
    if (currentTime == 1) {
      setState(() {
        currentTime = 2;
      });
      _timerKey.currentState?.addTime(parseDurationString(duration));
      _timerKey.currentState?.pauseTimer();
      setState(() {
        paused = true;
      });
      confirmFinishGameMenu(true);
    } else {
      setState(() {
        paused = true;
      });
      _timerKey.currentState?.pauseTimer();
      showMenu('2o Tempo Encerrado', false);
    }
  } 

  Duration parseDurationString(String durationString) {
    final parts = durationString.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = double.parse(parts[2]).toInt();
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
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
                onTap: undo,
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
                  child: Center(
                    child: Countdown(
                      key: _timerKey,
                      durationString: duration,
                      timeEnded: timerEndedHandle,
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
                          colors: currentTime == 1
                          ? [Colors.red[800]!, Colors.red, Colors.blue, Colors.blue[800]!]
                          : [Colors.blue[800]!, Colors.blue, Colors.red, Colors.red[800]!],
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
                                currentTime == 1 ? teamA : teamB,
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
                                currentTime == 1 ? teamB : teamA,
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
                  height: ScreenUtil().screenWidth * .07,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentTime == 1 ? '$goalsA X $goalsB' : '$goalsB X $goalsA',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800
                        ),
                      ),
                      Text(
                        '${currentTime}o Tempo',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  )
                )
              )
            ),

            // GOAL TEAM A BTN
            Positioned(
              left: currentTime == 1 ? ScreenUtil().screenWidth * .03 : null,
              right: currentTime == 1 ? null : ScreenUtil().screenWidth * .03,
              bottom: ScreenUtil().screenWidth * .03,
              child: GestureDetector(
                onTap: () => {
                  goal('A')
                },
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
              left: currentTime == 2 ? ScreenUtil().screenWidth * .03 : null,
              right: currentTime == 2 ? null : ScreenUtil().screenWidth * .03,
              bottom: ScreenUtil().screenWidth * .03,
              child: GestureDetector(
                onTap: () => {
                  goal('B')
                },
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
