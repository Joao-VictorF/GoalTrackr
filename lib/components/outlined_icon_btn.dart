import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OutlinedIconBtn extends StatelessWidget {
  const OutlinedIconBtn({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all<BorderSide>(const BorderSide(
          width: 0.0,
          color: Colors.white
        )),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        fixedSize: MaterialStateProperty.all<Size?>(Size(30.0.w, 50.0.h)),
      ),
      onPressed: () => onTap(),
      child: FaIcon(
        icon,
        size: 20.w,
        color: const Color(0xFF454D58),
      ),
    );
  }
}