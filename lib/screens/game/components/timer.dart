import 'package:flutter/material.dart';
import 'dart:async';

class Countdown extends StatefulWidget {
  final String durationString;
  final Function() timeEnded;

  const Countdown({
    required Key key,
    required this.durationString,
    required this.timeEnded,
  }) : super(key: key);

  @override
  CountdownState createState() => CountdownState();
}

class CountdownState extends State<Countdown> {
  late Duration initialDuration;
  late Duration currentDuration;
  late Timer timer;
  bool isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    initialDuration = parseDurationString(widget.durationString);
    currentDuration = initialDuration;
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    if (isTimerRunning) return; // Prevent starting multiple timers
    isTimerRunning = true;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (currentDuration.inSeconds > 0) {
          currentDuration = currentDuration - const Duration(seconds: 1);
        } else {
          timer.cancel();
          widget.timeEnded(); // Call the provided timeEnded function
        }
      });
    });
  }

  void pauseTimer() {
    if (!isTimerRunning) return;
    isTimerRunning = false;
    timer.cancel();
  }

  void resumeTimer() {
    if (isTimerRunning) return; // Prevent resuming when the timer is already running
    isTimerRunning = true;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (currentDuration.inSeconds > 0) {
          currentDuration = currentDuration - const Duration(seconds: 1);
        } else {
          timer.cancel();
          widget.timeEnded(); // Call the provided timeEnded function
        }
      });
    });
  }

  void addTime(Duration timeToAdd) {
    setState(() {
      currentDuration = currentDuration + timeToAdd;
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
            formatDuration(currentDuration),
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