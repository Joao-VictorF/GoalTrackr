// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:futebol_app/screens/settings/components/settings_form.dart';
import 'package:futebol_app/utils/size_config.dart';
import 'package:futebol_app/utils/theme.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  static String routeName = '/settings';
  
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late StreamSubscription subscription;
  final double imageBackgroundHeight = 241.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container (
        constraints: BoxConstraints(
          minWidth: ScreenUtil().screenWidth,
          maxWidth: double.infinity,
          minHeight: ScreenUtil().screenHeight,
          maxHeight: double.infinity
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Column( 
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: imageBackgroundHeight.h,
                    width: SizeConfig.screenWidth,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/soccer-field.png',
                      width: SizeConfig.screenWidth,
                      height: imageBackgroundHeight.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 80,
                    left: 10,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                        iconSize: 18,
                        color: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 96.w,
                          height: 3,
                          margin: const EdgeInsets.only(top: 50, bottom: 10),
                          decoration: const BoxDecoration(
                            color: appPrimaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                        ),
                        Container(
                          width: appComponentsWidth,
                          margin: const EdgeInsets.only(bottom: 40),
                          child: Column(
                            children: [
                              Text(
                                'Iniciar partida',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Primeiro, configure o comportamento da partida',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: appTextLightColor,
                                ),
                              ),
                            ],
                          )
                        ),
                        SizedBox(
                          width: appComponentsWidth,
                          child: const SettingsForm()
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      )
    );
  }
}