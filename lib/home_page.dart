import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _progressValue = 0.0;
  late Timer _timer;
  final int _timerDuration = 5;
  int _widget2Value = 0;
  DateTime _tappedTime = DateTime.now();
  int _successScore = 0;
  int _failureScore = 0;
  int _totalAttempts = 0;

  @override
  void initState() {
    super.initState();
    _loadValues();
    _startTimer();
  }

  void _loadValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _successScore = prefs.getInt('successScore') ?? 0;
    _failureScore = prefs.getInt('failureScore') ?? 0;
    _totalAttempts = prefs.getInt('totalAttempts') ?? 0;
  }

  void _saveValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('successScore', _successScore);
    prefs.setInt('failureScore', _failureScore);
    prefs.setInt('totalAttempts', _totalAttempts);
  }

  void _startTimer() {
    const updateInterval = Duration(seconds: 1);
    _timer = Timer.periodic(updateInterval, (Timer timer) {
      setState(() {
        _progressValue += (updateInterval.inSeconds / _timerDuration);
        if (_progressValue >= 1.0) {
          _progressValue = 0.0;
          _onFailure(); // Reset timer and consider as failure
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _saveValues();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Welcome to KJBN",
            style: TextStyle(
              fontSize: 20,
              color: Colors.blue,
              letterSpacing: 3,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                width: 160,
                height: 160,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xF5F8F9ff),
                ),
                child: Center(
                  child: Text(
                    ' Rndom Number\n..........................\n           $_widget2Value',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Widget 1 - Show seconds from current time
              Container(
                width: 160,
                height: 160,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0Xf8f3eaff),
                ),
                child: StreamBuilder<int>(
                  stream: _secondsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Text(
                          " Current Seconds\n...........................\n              ${snapshot.data}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              const Spacer(),

              // Widget 2 - Show random number between 0 - 59
            ],
          ),

          // Widget 3 - Show success or failure message with score & attempts
          Container(
            width: 380,
            height: 160,
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.lightGreen,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _widget2Value == _tappedTime.second ? "Success" : "Failure",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Success Score: $_successScore / $_totalAttempts",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  "Failure Score: $_failureScore / $_totalAttempts",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Widget 4 - Circular countDown timer indicator
          Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              value: _progressValue,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.lightBlue),
              strokeWidth: 10.0,
            ),
          ),
          const SizedBox(
            height: 80,
          ),

          // Widget 5 - Tappable Button
          ElevatedButton(
            onPressed: () {
              _onWidget5Tap();
              debugPrint("tapped");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent, // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
            ),
            child: const Text(
              "click",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Stream<int> _secondsStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield DateTime.now().second;
    }
  }

  void _onWidget5Tap() {
    setState(() {
      _widget2Value = _generateRandomNumber();
      _tappedTime = DateTime.now();
      _totalAttempts++;

      if (_widget2Value == _tappedTime.second) {
        _onSuccess();
      } else {
        _onFailure();
      }
    });
  }

  void _onSuccess() {
    _successScore++;
    _resetTimer();
  }

  void _onFailure() {
    _failureScore++;
    _resetTimer();
  }

  void _resetTimer() {
    _progressValue = 0.0;
  }

  int _generateRandomNumber() {
    return Random().nextInt(60);
  }
}
