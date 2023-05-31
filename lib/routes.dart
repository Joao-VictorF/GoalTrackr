import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:futebol_app/screens/home/home.dart';
import 'package:futebol_app/screens/settings/settings.dart';
import 'package:futebol_app/screens/history/history.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => const HomeScreen(),
  Settings.routeName: (context) => const Settings(),
  History.routeName: (context) => const History(),
};