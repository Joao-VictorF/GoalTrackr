import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:futebol_app/components/custom_suffix_icon.dart';

const appPrimaryColor = Color(0xFF226433);
const appSecondaryColor = Color(0xFF226433);
const appSecondaryLightColor = Color(0xFF339A4E);

const appTextColor = Color(0xFF101010);
const appTextLightColor = Color(0xFF858E9B);
const appBackgroundColor = Color(0xFFF8F8F8);
const appBlackIconsColor = Color(0xFF404040);
const appInputBackground = Color(0xFFEFF0F6);
const appInputTextColor = Color(0xFF6E7191);
const appBorderColors = Color(0xFFE5E5E5);
const appBlackOverlay = Color.fromRGBO(0, 0, 0, 0.3);
const appLighterBlackOverlay = Color.fromRGBO(0, 0, 0, 0.2);
const appPrimaryOverlay = Color.fromRGBO(120, 170, 0, 0.4);
const appDividerColor = Color(0xFFB4B4B4);

var appButtonHeight = 60.h;
var appComponentsWidth = 339.w;

ThemeData theme(context) {
  return ThemeData(
    primaryColor: appPrimaryColor,
    scaffoldBackgroundColor: appBackgroundColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size?>(Size(appComponentsWidth, appButtonHeight)),
        backgroundColor: MaterialStateProperty.all<Color>(appPrimaryColor),
        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        )),
        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0.sp
        ))
      )
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: MaterialStateProperty.all<BorderSide>(const BorderSide(
          width: 2.0,
          color: appPrimaryColor
        )),
        fixedSize: MaterialStateProperty.all<Size?>(Size(appComponentsWidth, appButtonHeight)),
        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        )),
        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0.sp
        ))
      )
    ),
    fontFamily: 'Aglet Sans'
  );
}

class CustomStyle {
  static InputDecoration textFieldStyle({
    required String labelTextStr,
    String hintTextStr = "",
    CustomIcon? icon,
    GestureTapCallback? press,
  }) {
    OutlineInputBorder normalBorder = OutlineInputBorder(
      borderSide: const BorderSide(width: .5, color: appBorderColors),
      borderRadius: BorderRadius.circular(11),
    );

    OutlineInputBorder errorBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 1),
      borderRadius: BorderRadius.circular(11),
    );

    return InputDecoration(
      hintText: hintTextStr,
      suffixIcon: icon != null ? GestureDetector(
        onTap: press,        
        child: icon,
      ) : null,
      fillColor: appInputBackground,
      filled: true,
      constraints: BoxConstraints(
        minHeight: 64.h,
        minWidth: 325.w,
      ),
      label: Text(
        labelTextStr,
        style: TextStyle(
          fontSize: 14.0.sp,
          fontWeight: FontWeight.w500,
          color: appInputTextColor
        ),
      ),
      
      focusedBorder: normalBorder,
      enabledBorder: normalBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      errorStyle: const TextStyle(height: 0)
    );
  }
}