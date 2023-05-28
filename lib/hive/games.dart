import 'package:hive/hive.dart';

part 'games.g.dart';

const String gamesBoxName = 'gamesBox';

@HiveType(typeId: 1)
class Games {
  Games({
    this.teamA = '',
    this.teamB = '',
    this.goalsA = 0,
    this.goalsB = 0,
    this.times = 2,
    this.duration = '',
  });

  @HiveField(0)
  String teamA;

  @HiveField(1)
  String teamB;

  @HiveField(3)
  int goalsA;
  
  @HiveField(4)
  int goalsB;

  @HiveField(5)
  String duration;

  @HiveField(6)
  int times;
}