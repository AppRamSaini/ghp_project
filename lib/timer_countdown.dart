import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:ghp_society_management/constants/export.dart';

/// VIEW MEMBER DETAILS DIALOG
void timerCountdownDialog(
    {required BuildContext context,
    required Function setDialogueContext,
    void Function()? onComplete,
    void Function(String)? onChange}) {
  const int duration = 59;
  final CountDownController controller = CountDownController();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) {
      setDialogueContext(ctx);
      return WillPopScope(
        onWillPop: () async => false, // Disable back button
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  children: [
                    Center(
                        child: CircularCountDownTimer(
                            duration: duration,
                            initialDuration: 0,
                            controller: controller,
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 3,
                            ringColor: Colors.grey[300]!,
                            ringGradient: null,
                            fillColor: Colors.purpleAccent[100]!,
                            fillGradient: null,
                            backgroundColor: Colors.purple[500],
                            backgroundGradient: null,
                            strokeWidth: 8.0,
                            strokeCap: StrokeCap.round,
                            textStyle: const TextStyle(
                                fontSize: 33.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textFormat: CountdownTextFormat.S,
                            isReverse: true,
                            isReverseAnimation: true,
                            isTimerTextShown: true,
                            autoStart: true,
                            onStart: () {
                              debugPrint('Countdown Started');
                            },
                            onComplete: onComplete,
                            onChange: onChange)),
                    const Text("Please wait...",
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                    const Text(
                        "Confirmation request send to resident.\nPlease do not press back button",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87, fontSize: 14)),
                    const SizedBox(height: 60)
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
