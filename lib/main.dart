import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wear/wear.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:animator/animator.dart';

void main() {
  runApp(const MyApp());
}

//////  Cronometro
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFFFFFFF),
        lightSource: LightSource.topLeft,
        depth: 10,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Color(0x1a1a1a),
        accentColor: Color.fromARGB(255, 84, 255, 81),
        lightSource: LightSource.bottomLeft,
        depth: 4,
        intensity: 5,
        shadowDarkColor: Color.fromARGB(255, 0, 0, 0),
        shadowLightColor: Color.fromARGB(126, 107, 107, 107),
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  // const TimerScreen({super.key});

  final WearMode mode;

  const TimerScreen(this.mode, {super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late int _count;
  late String _strCount;
  late String _status;

  @override
  void initState() {
    _count = 0;
    _strCount = "00:00:00";
    _status = "Start";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.mode == WearMode.active
          ? Color.fromARGB(255, 26, 26, 26)
          : Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _icono(),
            const SizedBox(height: 10.0),
            Center(
              child: Text(
                _strCount,
                style: TextStyle(
                    color: widget.mode == WearMode.active
                        ? Color.fromARGB(255, 84, 255, 81)
                        : Color.fromARGB(117, 84, 255, 81)),
              ),
            ),
            const SizedBox(height: 10.0),
            _buildWidgetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetButton() {
    if (widget.mode == WearMode.active) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          NeumorphicButton(
            style: NeumorphicStyle(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(20))),
            // color: Colors.blue,
            // textColor: Colors.white,
            onPressed: () {
              if (_status == "Start") {
                _startTimer();
              } else if (_status == "Stop") {
                _timer.cancel();
                setState(() {
                  _status = "Continue";
                });
              } else if (_status == "Continue") {
                _startTimer();
              }
            },
            child: Center(
              child: NeumorphicIcon(
                _estado(_status),
                size: 15,
                style: NeumorphicStyle(
                  color: widget.mode == WearMode.active
                      ? Color.fromARGB(255, 84, 255, 81)
                      : Color.fromARGB(117, 84, 255, 81),
                  shape: NeumorphicShape.concave,
                  surfaceIntensity: 0.2,
                  depth: 1,
                  intensity: 0.90,
                  shadowDarkColor: Color(0x111111),
                  shadowLightColor: Color(0x232323),
                ),
              ),
            ),
          ),
          NeumorphicButton(
            style: NeumorphicStyle(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(20))),
            // color: Colors.blue,
            // textColor: Colors.white,
            onPressed: () {
              // ignore: unnecessary_null_comparison
              if (_timer != null) {
                _timer.cancel();
                setState(() {
                  _count = 0;
                  _strCount = "00:00:00";
                  _status = "Start";
                });
              }
            },
            child: NeumorphicIcon(
              Icons.restart_alt,
              size: 15,
              style: NeumorphicStyle(
                color: widget.mode == WearMode.active
                    ? Color.fromARGB(255, 84, 255, 81)
                    : Color.fromARGB(117, 84, 255, 81),
                shape: NeumorphicShape.concave,
                surfaceIntensity: 0.2,
                depth: 1,
                intensity: 0.90,
                shadowDarkColor: Color(0x111111),
                shadowLightColor: Color(0x232323),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  void _startTimer() {
    _status = "Stop";
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count += 1;
        int hour = _count ~/ 3600;
        int minute = (_count % 3600) ~/ 60;
        int second = (_count % 3600) % 60;
        _strCount = hour < 10 ? "0$hour" : "$hour";
        _strCount += ":";
        _strCount += minute < 10 ? "0$minute" : "$minute";
        _strCount += ":";
        _strCount += second < 10 ? "0$second" : "$second";
      });
    });
  }

  IconData _estado(status) {
    if (status == "Start") {
      return Icons.play_arrow;
    } else if (status == "Stop") {
      return Icons.pause;
    }
    return Icons.play_arrow;
  }

  Widget _icono() {
    return Neumorphic(
      style: const NeumorphicStyle(
        shape: NeumorphicShape.convex,
        boxShape: NeumorphicBoxShape.circle(),
        depth: 4,
        intensity: 5,
        shadowDarkColor: Color.fromARGB(255, 0, 0, 0),
        shadowLightColor: Color.fromARGB(126, 107, 107, 107),
      ),
      child: Container(
        width: 50,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Animator<double>(
                cycles: 0,
                curve: Curves.elasticIn,
                tween: Tween<double>(begin: 35.0, end: 25.0),
                duration: Duration(seconds: 1),
                builder: (context, animatorstate, child) => NeumorphicIcon(
                  Icons.timer,
                  size: animatorstate.value,
                  style: NeumorphicStyle(
                    color: widget.mode == WearMode.active
                        ? Color.fromARGB(255, 84, 255, 81)
                        : Color.fromARGB(117, 84, 255, 81),
                    shape: NeumorphicShape.concave,
                    surfaceIntensity: 0.2,
                    depth: 1,
                    intensity: 0.90,
                    shadowDarkColor: Color(0x111111),
                    shadowLightColor: Color(0x232323),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
