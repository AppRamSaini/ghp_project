// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:ghp_society_management/constants/snack_bar.dart';
//
// class OtpLoginScreen extends StatefulWidget {
//   @override
//   _OtpLoginScreenState createState() => _OtpLoginScreenState();
// }
//
// class _OtpLoginScreenState extends State<OtpLoginScreen> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//   String verificationId = '';
//   bool isOtpSent = false;
//
//   void _showSnackBar(String message, IconData icon, Color color) {
//     snackBar(context, message, icon, color);
//   }
//
//   void verifyOtp() async {
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: verificationId,
//       smsCode: otpController.text,
//     );
//
//     try {
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       showSnackbar("Phone number verified!");
//     } catch (e) {
//       showSnackbar("Invalid OTP");
//     }
//   }
//
//   void showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Login via OTP")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: phoneController,
//               decoration: InputDecoration(labelText: "Mobile Number"),
//               keyboardType: TextInputType.phone,
//             ),
//             if (isOtpSent) ...[
//               SizedBox(height: 16),
//               TextField(
//                 controller: otpController,
//                 decoration: InputDecoration(labelText: "Enter OTP"),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: isOtpSent ? verifyOtp : sendOtp,
//               child: Text(isOtpSent ? "Verify OTP" : "Send OTP"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
