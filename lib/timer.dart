// import 'dart:async';
// import 'package:flutter/material.dart';


// class Timer extends StatefulWidget {
//   @override
//   _TimerState createState() => _TimerState();
// }

// class _TimerState extends State<Timer> {
//   late Timer _timer;
//   late int _seconds;

//   @override
//   void initState() {
//     super.initState();
//     _seconds = DateTime.now().second;
//     _startTimer();
//   }

//   void _startTimer() {
//     const updateInterval = Duration(seconds: 1);
//     _timer = Timer.periodic(updateInterval, (Timer timer) {
//       setState(() {
//         _seconds = DateTime.now().second;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Circular Progress Indicator"),
//       ),
//       body: Center(
//         child: Container(
//           width: 120,
//           height: 120,
//           child: Stack(
//             children: [
//               CircularProgressIndicator(
//                 value: (_seconds % 60) / 60,
//                 strokeWidth: 10.0,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//               ),
//               Center(
//                 child: Text(
//                   '$_seconds',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
