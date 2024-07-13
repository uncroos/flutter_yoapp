import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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
    loadConcentrationState();
    scheduleMidnightReset();
  }

  Future<void> loadConcentrationState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isConcentrating = prefs.getBool('isConcentrating') ?? false;
      elapsedTime = Duration(milliseconds: prefs.getInt('elapsedTime') ?? 0);
      if (isConcentrating) {
        startTime = DateTime.parse(
            prefs.getString('startTime') ?? DateTime.now().toIso8601String());
        startTimer();
      }
    });
  }

  Future<void> saveConcentrationState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isConcentrating', isConcentrating);
    prefs.setInt('elapsedTime', elapsedTime.inMilliseconds);
    if (startTime != null) {
      prefs.setString('startTime', startTime!.toIso8601String());
    }
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
    saveConcentrationState();
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
    saveConcentrationState();
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
    saveConcentrationState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String time = getConcentrationTime();
    List<String> timeParts = time.split(':');

    return WillPopScope(
      onWillPop: () async {
        if (isConcentrating) {
          showConcentrationAlert();
          return false; // Prevent back navigation
        }
        return true; // Allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (!isConcentrating) {
                navigateBack();
              } else {
                showConcentrationAlert();
              }
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isConcentrating ? '집중중' : '집중',
                style: TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontFamily: 'ShillaCulture', // 폰트 스타일 추가
                ),
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 48, color: Colors.white),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          '${timeParts[0]} : ${timeParts[1]} : ${timeParts[2]}',
                      style:
                          TextStyle(fontFamily: 'ShillaCulture'), // 폰트 스타일 추가
                    ),
                    TextSpan(
                      text: ' : ${timeParts[3]}',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'ShillaCulture', // 폰트 스타일 추가
                      ),
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
      ),
    );
  }

  void showConcentrationAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('집중 중'),
          content: Text('현재 집중 중입니다. 시간을 멈추시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text(
                '아니오',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                '예',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  elapsedTime += DateTime.now().difference(startTime!);
                  isConcentrating = false;
                  timer?.cancel();
                });
                saveConcentrationState();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void navigateBack() {
    Navigator.pop(context);
  }
}
