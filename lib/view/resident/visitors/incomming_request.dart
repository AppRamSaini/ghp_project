import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/accept_request/accept_request_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/not_responding/not_responde_cubit.dart';
import 'package:ghp_society_management/model/incoming_visitors_request_model.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:vibration/vibration.dart';

class VisitorsIncomingRequestPage extends StatefulWidget {
  final RemoteMessage? message;
  IncomingVisitorsModel? incomingVisitorsRequest;
  bool fromForegroundMsg;
  String? from;
  final Function(bool values) setPageValue;

  VisitorsIncomingRequestPage(
      {super.key,
      this.message,
      this.from,
      this.incomingVisitorsRequest,
      required this.setPageValue,
      this.fromForegroundMsg = false});

  @override
  State<VisitorsIncomingRequestPage> createState() =>
      _VisitorsIncomingRequestPageState();
}

class _VisitorsIncomingRequestPageState
    extends State<VisitorsIncomingRequestPage> {
  bool isActioned = false;
  Timer? vibrationTimer;
  Timer? actionTimeoutTimer;
  Timer? notRespondingTimer;

  String? visitorName;
  String? visitorPhone;
  String? visitorsID;
  String? visitorImg;

  static const int timeoutDurationSeconds = 55; // Timeout duration constant

  @override
  void initState() {
    super.initState();
    widget.setPageValue(true);
    setData();
    _startAlerts();
    _setupTimeouts();
  }

  void setData() {
    try {
      if (widget.message != null) {
        var data = widget.message!.data;
        setState(() {
          visitorName = data['name']?.toString();
          visitorsID = data['visitor_id']?.toString();
          visitorPhone = data['mob']?.toString();
          visitorImg = data['img']?.toString();
        });
      } else {
        setState(() {
          visitorName = widget.incomingVisitorsRequest!.visitorName.toString();
          visitorsID = widget.incomingVisitorsRequest!.id.toString();
          visitorPhone = widget.incomingVisitorsRequest!.phone.toString();
          visitorImg = widget.incomingVisitorsRequest!.image.toString();
        });
      }
      print(
          "${DateTime.now()} - Visitor Data: $visitorName, $visitorsID, $visitorPhone");
    } catch (e) {
      print("${DateTime.now()} - Error setting data: $e");
    }
  }

  void _startAlerts() {
    try {
      print("${DateTime.now()} - Starting Alerts...");
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
      FlutterRingtonePlayer().playRingtone();
      vibrationTimer =
          Timer(const Duration(seconds: timeoutDurationSeconds), () {
        _stopAlerts();
      });
    } catch (e) {
      print("${DateTime.now()} - Error starting alerts: $e");
    }
  }

  void _setupTimeouts() {
    print("${DateTime.now()} - Setting up timeouts...");

    actionTimeoutTimer =
        Timer(const Duration(seconds: timeoutDurationSeconds), () {
      if (!isActioned) {
        print("${DateTime.now()} - Action Timeout Reached. Stopping Alerts...");
        _stopAlerts();
      }
    });

    notRespondingTimer =
        Timer(const Duration(seconds: timeoutDurationSeconds), () {
      print("${DateTime.now()} - Not responding timer triggered.");
      if (!isActioned) {
        _handleNotResponding(visitorsID ?? "");
      }
    });

    print(
        "${DateTime.now()} - Timeouts Initialized. Action Timer Active: ${actionTimeoutTimer?.isActive}, Not Responding Timer Active: ${notRespondingTimer?.isActive}");
  }

  void _handleNotResponding(String visitorsId) {
    if (visitorsId.isEmpty) {
      print(
          "${DateTime.now()} - Error: Visitor ID is empty, skipping API call.");
      return;
    }
    _stopAlerts();
    var requestBody = {"visitor_id": visitorsId};
    print("${DateTime.now()} - Not Responding API Call: $requestBody");

    context
        .read<NotRespondingCubit>()
        .notRespondingAPI(statusBody: requestBody)
        .then((_) {
      print("${DateTime.now()} - Not Responding API Call Completed.");
    }).catchError((error) {
      print("${DateTime.now()} - API Call Error: $error");
    });
  }

  void _stopAlerts() {
    try {
      vibrationTimer?.cancel();
      actionTimeoutTimer?.cancel();
      FlutterRingtonePlayer().stop();
    } catch (e) {}
  }

  void _handleAction(String id, String action) {
    if (!isActioned) {
      setState(() => isActioned = true);
      _stopAlerts();
      actionTimeoutTimer?.cancel();
      notRespondingTimer?.cancel();

      var requestBody = {"visitor_id": id, "status": action};
      print(
          "${DateTime.now()} - Action Taken: $action, API Call: $requestBody");

      context
          .read<AcceptRequestCubit>()
          .acceptRequestAPI(statusBody: requestBody)
          .then((_) {
        print("${DateTime.now()} - Accept Request API Call Completed.");
      }).catchError((error) {
        print("${DateTime.now()} - Accept Request API Call Error: $error");
      });
    }
  }

  @override
  void dispose() {
    vibrationTimer?.cancel();
    actionTimeoutTimer?.cancel();
    notRespondingTimer?.cancel();
    super.dispose();
  }

  late BuildContext dialogueContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.resolvedButtonColor,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AcceptRequestCubit, AcceptRequestState>(
            listener: (context, state) {
              if (state is AcceptRequestLoading) {
                showLoadingDialog(context, (ctx) {
                  dialogueContext = ctx;
                });
              } else if (state is AcceptRequestSuccessfully) {
                snackBar(context, state.successMsg.toString(), Icons.done,
                    AppTheme.guestColor);
                Navigator.of(dialogueContext).pop();
                Navigator.pop(context);
              } else if (state is AcceptRequestFailed) {
                snackBar(context, state.errorMsg.toString(), Icons.warning,
                    AppTheme.redColor);
                Navigator.of(dialogueContext).pop();
              } else if (state is AcceptRequestInternetError) {
                snackBar(context, 'Internet connection failed', Icons.wifi_off,
                    AppTheme.redColor);
                Navigator.of(dialogueContext).pop();
              } else {
                Navigator.of(dialogueContext).pop();
              }
            },
          ),
          BlocListener<NotRespondingCubit, NotRespondingState>(
            listener: (context, state) {
              if (state is NotRespondingLoading) {
                showLoadingDialog(context, (ctx) {
                  dialogueContext = ctx;
                });
              } else if (state is NotRespondingSuccessfully) {
                snackBar(context, state.successMsg.toString(), Icons.done,
                    AppTheme.guestColor);
                Navigator.of(dialogueContext).pop();
                Navigator.pop(context);
                _stopAlerts();
              } else if (state is NotRespondingFailed) {
                snackBar(context, state.errorMsg.toString(), Icons.warning,
                    AppTheme.redColor);
                Navigator.of(dialogueContext).pop();
              } else if (state is NotRespondingInternetError) {
                snackBar(context, 'Internet connection failed', Icons.wifi_off,
                    AppTheme.redColor);
                Navigator.of(dialogueContext).pop();
              } else {
                Navigator.of(dialogueContext).pop();
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
            _buildActionButtons(visitorsID.toString()),
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
                  placeholder: const AssetImage('assets/images/dummy.jpg'),
                  image: NetworkImage(visitorImg.toString()),
                  imageErrorBuilder: (_, child, stackTrack) => Image.asset(
                      'assets/images/dummy.jpg',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover)),
            )),
        const SizedBox(height: 20),
        Text(visitorName.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        Text(
          visitorPhone.toString(),
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
          Text(
              "Incoming Visitors Request from GHP Society Management App"
                  .toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 5),
          Text(
            '"If you wish to allow this visitor to enter the society, click the "Accept" button. If you do not wish to allow, click "Decline" to reject the request."',
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
          label: "Decline",
          color: Colors.red,
          icon: Icons.clear,
          onPressed: () => _handleAction(visitorsID, "not_allowed"),
        ),
        _buildActionButton(
          label: "Accept",
          color: Colors.green,
          icon: Icons.check,
          onPressed: () => _handleAction(visitorsID, "allowed"),
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
