import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/accept_request/accept_request_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/not_responding/not_responde_cubit.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/model/incoming_visitors_request_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:vibration/vibration.dart';

class VisitorsIncomingRequestPage extends StatefulWidget {
  final RemoteMessage? message;
  final IncomingVisitorsModel? incomingVisitorsRequest;
  final bool fromForegroundMsg;
  final String? from;
  final Function(bool values) setPageValue;

  const VisitorsIncomingRequestPage({
    super.key,
    this.message,
    this.from,
    this.incomingVisitorsRequest,
    required this.setPageValue,
    this.fromForegroundMsg = false,
  });

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
  String? visitorTypes;
  String? visitorVehicle;
  String? visitorDescription;

  static const int timeoutDurationSeconds = 50;
  late BuildContext dialogueContext;

  @override
  void initState() {
    super.initState();
    widget.setPageValue(true);
    _setVisitorData();
    _startAlerts();
    _setupTimers();
  }

  void _setVisitorData() {
    try {
      if (widget.message != null) {
        final data = widget.message!.data;
        visitorName = data['name']?.toString();
        visitorsID = data['visitor_id']?.toString();
        visitorPhone = data['mob']?.toString();
        visitorImg = data['img']?.toString();
        visitorTypes = data['type_of_visit']?.toString();
        visitorDescription = data['description']?.toString();
        visitorVehicle = data['vehicle_number']?.toString();
      } else if (widget.incomingVisitorsRequest != null) {
        visitorName = widget.incomingVisitorsRequest!.visitorName.toString();
        visitorsID = widget.incomingVisitorsRequest!.id.toString();
        visitorPhone = widget.incomingVisitorsRequest!.phone.toString();
        visitorImg = widget.incomingVisitorsRequest!.image.toString();
        visitorTypes = widget.incomingVisitorsRequest!.typeOfVisitor.toString();
        visitorDescription =
            widget.incomingVisitorsRequest!.purposeOfVisit.toString();
        visitorVehicle =
            widget.incomingVisitorsRequest!.vehicleNumber.toString();
      }
    } catch (e) {
      print("Error setting visitor data: $e");
    }
  }

  void _startAlerts() {
    try {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
      FlutterRingtonePlayer().playRingtone();
      vibrationTimer = Timer.periodic(const Duration(seconds: 5),
          (_) => Vibration.vibrate(pattern: [500, 1000]));
    } catch (e) {
      print("Error starting alerts: $e");
    }
  }

  void _setupTimers() {
    // Action timeout
    actionTimeoutTimer =
        Timer(Duration(seconds: timeoutDurationSeconds), _onTimeout);
    // Not responding timer
    notRespondingTimer =
        Timer(Duration(seconds: timeoutDurationSeconds), _onNotResponding);
  }

  void _onTimeout() {
    if (!isActioned && mounted) {
      _stopAlerts();
      _safePop();
    }
  }

  void _onNotResponding() {
    if (!isActioned && mounted) {
      _handleNotResponding(visitorsID ?? "");
    }
  }

  void _stopAlerts() {
    try {
      vibrationTimer?.cancel();
      actionTimeoutTimer?.cancel();
      notRespondingTimer?.cancel();
      FlutterRingtonePlayer().stop();
    } catch (_) {}
  }

  void _handleAction(String id, String action) {
    if (!isActioned && mounted) {
      setState(() => isActioned = true);
      _stopAlerts();

      final requestBody = {"visitor_id": id, "status": action};
      context
          .read<AcceptRequestCubit>()
          .acceptRequestAPI(statusBody: requestBody)
          .then((_) => print("Accept API done"))
          .catchError((e) => print("Accept API error: $e"));
    }
  }

  void _handleNotResponding(String visitorsId) {
    if (visitorsId.isEmpty || !mounted) return;

    _stopAlerts();
    final requestBody = {"visitor_id": visitorsId};
    context
        .read<NotRespondingCubit>()
        .notRespondingAPI(statusBody: requestBody)
        .then((_) => _safePop())
        .catchError((e) => print("Not Responding API error: $e"));
  }

  void _safePop() {
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _stopAlerts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.resolvedButtonColor,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AcceptRequestCubit, AcceptRequestState>(
            listener: (context, state) {
              if (!mounted) return;
              if (state is AcceptRequestLoading) {
                showLoadingDialog(context, (ctx) => dialogueContext = ctx);
              } else if (state is AcceptRequestSuccessfully) {
                snackBar(context, state.successMsg ?? '', Icons.done,
                    AppTheme.guestColor);
                Navigator.of(dialogueContext).pop();
                _safePop();
              } else if (state is AcceptRequestFailed ||
                  state is AcceptRequestInternetError) {
                snackBar(
                    context,
                    state is AcceptRequestFailed
                        ? state.errorMsg ?? ''
                        : 'Internet connection failed',
                    Icons.warning,
                    AppTheme.redColor);
                Navigator.of(dialogueContext).pop();
              } else {
                Navigator.of(dialogueContext).pop();
              }
            },
          ),
          BlocListener<NotRespondingCubit, NotRespondingState>(
            listener: (context, state) {
              if (!mounted) return;
              if (state is NotRespondingLoading) {
                showLoadingDialog(context, (ctx) => dialogueContext = ctx);
              } else if (state is NotRespondingSuccessfully) {
                snackBar(context, state.successMsg ?? '', Icons.done,
                    AppTheme.guestColor);
                Navigator.of(dialogueContext).pop();
                _safePop();
              } else if (state is NotRespondingFailed ||
                  state is NotRespondingInternetError) {
                snackBar(
                    context,
                    state is NotRespondingFailed
                        ? state.errorMsg ?? ''
                        : 'Internet connection failed',
                    Icons.warning,
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
            _buildVisitorsDataInfo(),
            const Spacer(flex: 4),
            _buildVisitorInfo(),
            const Spacer(flex: 4),
            _buildActionButtons(visitorsID ?? ""),
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
              image: NetworkImage(visitorImg ?? ''),
              imageErrorBuilder: (_, __, ___) => Image.asset(
                'assets/images/dummy.jpg',
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(visitorName ?? '',
            style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500)),
        Text("Visitor Mob : +91 ${visitorPhone ?? ''}",
            style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildVisitorsDataInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.3))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Visitor type - ",
                  style: GoogleFonts.montserrat(
                      color: Colors.white, fontSize: 16)),
              Text(visitorTypes ?? '',
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          5.verticalSpace,
          Text("Visitor Vehicle No - ${visitorVehicle ?? ''}" ?? '',
              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16)),
          5.verticalSpace,
          Text("Purpose of visiting - ${visitorDescription ?? ''}",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildVisitorInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
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

  Widget _buildActionButtons(String visitorId) {
    return Padding(
      padding: globalBottomPadding(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            label: "Decline",
            color: Colors.red,
            icon: Icons.clear,
            onPressed: () => _handleAction(visitorId, "not_allowed"),
          ),
          _buildActionButton(
            label: "Accept",
            color: Colors.green,
            icon: Icons.check,
            onPressed: () => _handleAction(visitorId, "allowed"),
          ),
        ],
      ),
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
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }
}
