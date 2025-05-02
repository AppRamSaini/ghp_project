import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/sos_management/sos_acknowledge/sos_acknowledged_cubit.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:vibration/vibration.dart';

class SosIncomingAlert extends StatefulWidget {
  final RemoteMessage? message;
  bool fromForegroundMsg;
  final Function(bool values) setPageValue;
  SosIncomingAlert(
      {super.key,
      this.message,
      required this.setPageValue,
      this.fromForegroundMsg = false});

  @override
  State<SosIncomingAlert> createState() => SosIncomingAlertState();
}

class SosIncomingAlertState extends State<SosIncomingAlert> {
  bool isActioned = false;
  Timer? vibrationTimer;
  Timer? actionTimeoutTimer;

  String? name;
  String? mobile;
  String? sosId;
  String? type;
  String? description;

  static const int timeoutDurationSeconds = 50;

  @override
  void initState() {
    super.initState();
    widget.setPageValue(true);
    setData();
    _startAlerts();
    _setupTimeouts();
  }

  void _startAlerts() {
    try {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
      FlutterRingtonePlayer().playRingtone();
      vibrationTimer =
          Timer(const Duration(seconds: timeoutDurationSeconds), _stopAlerts);
    } catch (e) {
      print("Error starting alerts: $e");
    }
  }

  void _setupTimeouts() {
    actionTimeoutTimer = Timer(Duration(seconds: timeoutDurationSeconds), () {
      print('✅ Timer completed, executing _stopAlerts()');
      _stopAlerts();
    });
  }

  void _stopAlerts() {
    try {
      vibrationTimer?.cancel();
      actionTimeoutTimer?.cancel();
      FlutterRingtonePlayer().stop();
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 200), () {
          try {
            Navigator.pop(context);
          } catch (e) {}
        });
      } else {}
    } catch (e) {}
  }

  void _handleAction(String id) {
    if (!isActioned) {
      setState(() => isActioned = true);
      actionTimeoutTimer?.cancel();
      context
          .read<AcknowledgedCubit>()
          .acknowledgedAPI(statusBody: {"sos_id": id}).then((_) {
        _stopAlerts();
      }).catchError((error) {
        print("Accept Request API Call Error: $error");
      });
    }
  }

  void setData() {
    try {
      if (widget.message != null) {
        var data = widget.message!.data;

        setState(() {
          name = data['name']?.toString();
          sosId = data['sos_id']?.toString();
          mobile = data['mob']?.toString();
          type = widget.message!.notification!.title.toString();
          description = widget.message!.notification!.body.toString();
        });
      }
    } catch (e) {
      print("${DateTime.now()} - Error setting data: $e");
    }
  }

  late BuildContext dialogueContext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.resolvedButtonColor,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AcknowledgedCubit, AcknowledgedState>(
            listener: (context, state) {
              if (state is AcknowledgedLoading) {
                showLoadingDialog(context, (ctx) {
                  dialogueContext = ctx;
                });
              } else if (state is AcknowledgedSuccessfully) {
                snackBar(context, state.successMsg.toString(), Icons.done,
                    AppTheme.guestColor);
                Future.delayed(const Duration(milliseconds: 10), () {
                  Navigator.of(dialogueContext).pop();
                });
              } else if (state is AcknowledgedFailed) {
                snackBar(context, state.errorMsg.toString(), Icons.warning,
                    AppTheme.redColor);
                Future.delayed(const Duration(milliseconds: 10), () {
                  Navigator.of(dialogueContext).pop();
                });
              } else if (state is AcknowledgedInternetError) {
                snackBar(context, 'Internet connection failed', Icons.wifi_off,
                    AppTheme.redColor);
                Future.delayed(const Duration(milliseconds: 10), () {
                  Navigator.of(dialogueContext).pop();
                });
              } else {
                Future.delayed(const Duration(milliseconds: 10), () {
                  Navigator.of(dialogueContext).pop();
                });
              }
            },
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            _buildRippleAnimation(),
            const Spacer(flex: 4),
            _buildVisitorInfo(),
            const Spacer(flex: 4),
            _buildActionButtons(sosId.toString()),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildRippleAnimation() {
    return Column(
      children: [
        RippleAnimation(
            color: Colors.deepOrange,
            delay: const Duration(milliseconds: 300),
            repeat: true,
            minRadius: 75,
            maxRadius: 140,
            ripplesCount: 6,
            duration: const Duration(milliseconds: 1800),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: FadeInImage(
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage('assets/images/sosi.png'),
                  image: const NetworkImage(''),
                  imageErrorBuilder: (_, child, stackTrack) => Image.asset(
                      'assets/images/sosi.png',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover)),
            )),
        const SizedBox(height: 20),
        Text(name.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        Text(
          mobile.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildVisitorInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(type.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 5),
          Text(
            '"$description"',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(String visitorsID) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          label: "Acknowledged ",
          color: Colors.green,
          icon: Icons.check,
          onPressed: () => _handleAction(visitorsID),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      {required String label,
      required Color color,
      required IconData icon,
      required VoidCallback onPressed}) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 30,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, size: 30, color: Colors.white),
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
