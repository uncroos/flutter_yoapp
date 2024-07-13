import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: ConcentrationPage(),
  ));
}

class ConcentrationPage extends StatefulWidget {
  @override
  _ConcentrationPageState createState() => _ConcentrationPageState();
}

class _ConcentrationPageState extends State<ConcentrationPage> {
  bool isConcentrating = true; // For testing purpose, you can change this.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('집중 페이지'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (isConcentrating) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('집중 중입니다. 메인 화면으로 갈 수 없습니다.'),
                duration: Duration(seconds: 2),
              ),
            );
            return false; // Prevent back navigation
          }
          return true; // Allow back navigation
        },
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isConcentrating = false; // Change concentration state
              });
            },
            child: Text('집중 중 해제'),
          ),
        ),
      ),
    );
  }
}
