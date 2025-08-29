// import 'dart:async';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// const String APP_ID = "dd3d67452114403fb5498b1dfd524386";
//
// // Home Page to choose role
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Select Role')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (_) =>
//                           CallPage(role: "staff", targetUserId: "resident1")),
//                 );
//               },
//               child: Text('Login as Staff'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (_) =>
//                           CallPage(role: "resident", targetUserId: "staff1")),
//                 );
//               },
//               child: Text('Login as Resident'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Call Page
// class CallPage extends StatefulWidget {
//   final String role;
//   final String targetUserId;
//
//   const CallPage({super.key, required this.role, required this.targetUserId});
//
//   @override
//   State<CallPage> createState() => _CallPageState();
// }
//
// class _CallPageState extends State<CallPage> {
//   RtcEngine? engine;
//   bool inCall = false;
//   String? currentChannel;
//   Timer? callTimer;
//   int secondsElapsed = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions();
//     initAgora();
//     setupFCM();
//   }
//
//   Future<void> requestPermissions() async {
//     await [Permission.microphone].request();
//   }
//
//   Future<void> initAgora() async {
//     engine = createAgoraRtcEngine();
//     await engine!.initialize(RtcEngineContext(appId: APP_ID));
//     await engine!.enableAudio();
//   }
//
//   void setupFCM() {
//     FirebaseMessaging.onMessage.listen((message) {
//       if (message.data['type'] == 'incoming_request') {
//         String channelName = message.data['channel'];
//         showIncomingCallDialog(channelName);
//       }
//     });
//   }
//
//   void showIncomingCallDialog(String channelName) {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (_) => WillPopScope(
//         onWillPop: () async => false,
//         child: AlertDialog(
//           title: Text('Incoming Call'),
//           content: Text(
//               'You have a call from ${widget.role == "staff" ? "Staff" : "Resident"}'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 joinChannel(channelName);
//                 Navigator.pop(context);
//               },
//               child: Text('Accept'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Decline'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> startCall() async {
//     String channelName =
//         "${widget.role}_${widget.targetUserId}_${DateTime.now().millisecondsSinceEpoch}";
//     currentChannel = channelName;
//
//     // TODO: Send FCM notification to targetUserId with channelName
//
//     await joinChannel(channelName);
//   }
//
//   Future<void> joinChannel(String channelName) async {
//     await engine!.joinChannel(
//       token: 'abc',
//       channelId: channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//
//     startTimer();
//
//     setState(() {
//       inCall = true;
//       currentChannel = channelName;
//     });
//   }
//
//   void startTimer() {
//     callTimer?.cancel();
//     secondsElapsed = 0;
//     callTimer = Timer.periodic(Duration(seconds: 1), (_) {
//       setState(() {
//         secondsElapsed++;
//       });
//     });
//   }
//
//   Future<void> endCall() async {
//     await engine!.leaveChannel();
//     callTimer?.cancel();
//     setState(() {
//       inCall = false;
//       currentChannel = null;
//       secondsElapsed = 0;
//     });
//   }
//
//   String formatTime(int seconds) {
//     int m = seconds ~/ 60;
//     int s = seconds % 60;
//     return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Voice Call (${widget.role})')),
//       body: Center(
//         child: inCall
//             ? Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text('In Call: $currentChannel'),
//                   SizedBox(height: 10),
//                   Text('Duration: ${formatTime(secondsElapsed)}'),
//                   SizedBox(height: 20),
//                   ElevatedButton(onPressed: endCall, child: Text('End Call')),
//                 ],
//               )
//             : ElevatedButton(onPressed: startCall, child: Text('Start Call')),
//       ),
//     );
//   }
// }
