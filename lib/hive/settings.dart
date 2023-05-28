// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';

part 'settings.g.dart';

const String settingsBoxName = 'settingsBox';

@HiveType(typeId: 2)
class Settings {
  Settings({
    this.duration = '',
    this.times = 2,
  });

  @HiveField(0)
  String duration;

  @HiveField(1)
  int times;
}