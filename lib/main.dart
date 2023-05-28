import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:futebol_app/hive/settings.dart';
import 'package:futebol_app/hive/games.dart';

import 'package:futebol_app/screens/home/home.dart';
import 'package:futebol_app/utils/theme.dart';
import 'package:futebol_app/utils/size_config.dart';
import 'package:futebol_app/routes.dart';

Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle (
    const SystemUiOverlayStyle (
      statusBarColor: appPrimaryColor,
      systemNavigationBarColor: Colors.transparent,
    )
  );
  await Hive.initFlutter();

  Hive.registerAdapter(GamesAdapter());
  Hive.registerAdapter(SettingsAdapter());

  await Hive.openBox<Games>(gamesBoxName);
  await Hive.openBox<Settings>(settingsBoxName);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            title: 'Goal Trackr',
            routes: routes,
            theme: theme(context),
            home: const AppHome(),
            debugShowCheckedModeBanner: false,
          );
        }
      );
  }
}

class AppHome extends StatelessWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // ScreenUtil.init(context);
    // ScreenUtil.setContext(context);
    return const HomeScreen();
  }
}