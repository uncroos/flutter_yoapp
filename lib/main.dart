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
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'An4Days',
          style: TextStyle(
            fontSize: 40,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                '오늘의 일정',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• Python 수행', style: TextStyle(fontSize: 18)),
                    Text('• SPAM 일정', style: TextStyle(fontSize: 18)),
                    Text('• 4시 ~ 6시 커피챗', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                '집중',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConcentrationPage()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '집중딱',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'YO-PT',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.cloud, size: 50),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('바로가기'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                '달력',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2024년 6월',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '일 월 화 수 목 금 토',
                      style: TextStyle(fontSize: 18),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) {
                        return Center(child: Text('26'));
                      },
                      itemCount: 35,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '느긋하게 일정 확인하러 가자',
                          style: TextStyle(fontSize: 18),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('바로가기'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      backgroundColor: Colors.black,
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
                    text: '${timeParts[0]} : ${timeParts[1]} : ${timeParts[2]}',
                    style: TextStyle(fontFamily: 'ShillaCulture'), // 폰트 스타일 추가
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
    );
  }
}
