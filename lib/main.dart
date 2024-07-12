import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '집중 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        fontFamily: 'ShillaCulture',
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ConcentrationPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // 로고 이미지로 교체하세요
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

class ConcentrationPage extends StatefulWidget {
  @override
  _ConcentrationPageState createState() => _ConcentrationPageState();
}

class _ConcentrationPageState extends State<ConcentrationPage> {
  bool isConcentrating = false;
  DateTime? startTime;
  Duration elapsedTime = Duration.zero;
  Timer? timer;
  Timer? midnightTimer;

  @override
  void initState() {
    super.initState();
    scheduleMidnightReset();
  }

  void scheduleMidnightReset() {
    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day + 1);
    Duration timeUntilMidnight = midnight.difference(now);

    midnightTimer = Timer(timeUntilMidnight, resetAtMidnight);
  }

  void resetAtMidnight() {
    setState(() {
      isConcentrating = false;
      startTime = null;
      elapsedTime = Duration.zero;
    });
    scheduleMidnightReset();
  }

  void toggleConcentration() {
    setState(() {
      isConcentrating = !isConcentrating;
      if (isConcentrating) {
        startTime = DateTime.now();
        startTimer();
      } else {
        elapsedTime += DateTime.now().difference(startTime!);
        timer?.cancel();
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      setState(() {});
    });
  }

  String getConcentrationTime() {
    Duration currentTime = elapsedTime;
    if (isConcentrating && startTime != null) {
      currentTime += DateTime.now().difference(startTime!);
    }
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');
    return '${currentTime.inHours} : ${twoDigits(currentTime.inMinutes.remainder(60))} : ${twoDigits(currentTime.inSeconds.remainder(60))} : ${threeDigits(currentTime.inMilliseconds.remainder(1000))}';
  }

  @override
  void dispose() {
    timer?.cancel();
    midnightTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String time = getConcentrationTime();
    List<String> timeParts = time.split(':');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isConcentrating ? '집중중' : '집중',
              style: TextStyle(
                  fontSize: 70,
                  color: Colors.white,
                  fontFamily: 'ShillaCulture'), // 폰트 스타일 추가
            ),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 48, color: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                    text: '${timeParts[0]} : ${timeParts[1]} : ${timeParts[2]}',
                    style: TextStyle(fontFamily: 'ShillaCulture'), // 폰트 스타일 추가
                  ),
                  TextSpan(
                    text: ' : ${timeParts[3]}',
                    style: TextStyle(
                        fontSize: 24, fontFamily: 'ShillaCulture'), // 폰트 스타일 추가
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: toggleConcentration,
              child: Icon(
                Icons.whatshot, // 불 아이콘
                size: 150,
                color: isConcentrating ? Colors.red : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
