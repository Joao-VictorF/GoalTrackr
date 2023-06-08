import 'package:flutter/material.dart';
import 'dart:async';

class Countdown extends StatefulWidget {
  final String durationString;

  const Countdown({
    required Key key,
    required this.durationString
  }) : super(key: key);

  @override
  CountdownState createState() => CountdownState();
}

class CountdownState extends State<Countdown> {
  late Duration duration;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    duration = parseDurationString(widget.durationString);
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (duration.inSeconds > 0) {
          duration = duration - const Duration(seconds: 1);
        } else {
          timer.cancel();
        }
      });
    });
  }

  void pauseTimer() {
    timer.cancel();
  }

  void resumeTimer() {
    startTimer();
  }

  void addTime(Duration timeToAdd) {
    setState(() {
      duration = duration + timeToAdd;
    });
  }

  Duration parseDurationString(String durationString) {
    final parts = durationString.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = double.parse(parts[2]).toInt();
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatDuration(duration),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24
            ),
          )
        ]
      )
    );
  }
}