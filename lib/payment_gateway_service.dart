import 'dart:convert';
import 'dart:io';

import 'package:ghp_society_management/config.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:ghp_society_management/view/dashboard/bottom_nav_screen.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

payBillFun(double amount, BuildContext context) {
  Razorpay razorpay = Razorpay();
  String? billId = LocalStorage.localStorage.getString('bill_id');

  var options = {
    'key': RazorpayConfig.razorpayKey,
    'amount': (amount * 100).toInt(),
    'name': 'GHP Society Management',
    'description': 'Maintenance Bill',
    'retry': {'enabled': true, 'max_count': 1},
    'send_sms_hash': true,
    'prefill': {}, // You can add 'email' and 'contact' here if available
    'notes': {'bill_id': billId ?? "unknown"},
    'theme': {'color': '#3399cc'},
    'external': {
      'wallets': ['paytm']
    }
  };

  razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
      (res) => handlePaymentErrorResponse(res, context));
  razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
      (res) => handlePaymentSuccessResponse(res, context));
  razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
      (res) => handleExternalWalletSelected(res, context));

  razorpay.open(options);
}

void handlePaymentErrorResponse(
    PaymentFailureResponse response, BuildContext context) async {
  String? billId = LocalStorage.localStorage.getString('bill_id');

  var errorData = jsonEncode({
    'code': response.code,
    'message': response.message,
    'error': response.error?.toString(),
  });

  var responseBody = {
    "bill_id": billId,
    "status": "failed",
    "response": errorData,
  };

  debugPrint("❌ Payment Failed Body: $responseBody");

  await _submitPaymentStatus(context, responseBody, false);
}

void handlePaymentSuccessResponse(
    PaymentSuccessResponse response, BuildContext context) async {
  String? billId = LocalStorage.localStorage.getString('bill_id');

  var successData = jsonEncode({
    'orderId': response.orderId,
    'razorpay_payment_id': response.paymentId,
    'signature': response.signature,
  });

  var responseBody = {
    "bill_id": billId,
    "status": "success",
    "response": successData,
  };

  debugPrint("✅ Payment Success Body: $responseBody");

  await _submitPaymentStatus(
    context,
    responseBody,
    true,
    billId: billId,
    paymentID: response.paymentId,
  );
}

void handleExternalWalletSelected(
    ExternalWalletResponse response, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("External Wallet Selected: ${response.walletName}"),
      backgroundColor: Colors.blue,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

Future<void> _submitPaymentStatus(
    BuildContext context, Map<String, dynamic> body, bool isSuccess,
    {String? billId, paymentID}) async {
  ApiManager apiManager = ApiManager();

  try {
    var token = LocalStorage.localStorage.getString('token');
    if (isSuccess == true) {
      debugPrint("Called -------------SUCCESS");
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.Request(
          'POST', Uri.parse('${Config.baseURL}${Routes.billPayment}'));
      request.body = json.encode({
        "bill_id": billId.toString(),
        "status": "success",
        "response": {
          "orderId": "",
          "razorpay_payment_id": paymentID.toString(),
          "signature": ""
        }
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var resData = json.decode(await response.stream.bytesToString());
      print('-----<<<<<<<<<<<<<<$resData');

      if (response.statusCode == 200) {
        if (resData['status']) {
          Future.delayed(Duration.zero, () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(resData['message'].toString()),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating));
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
                (route) => false);
          });
        }
      } else {
        print(response.reasonPhrase);
      }
    } else {
      debugPrint("Called -----ERROR");
      var response = await apiManager.postRequest(
        body,
        "${Config.baseURL}${Routes.billPayment}",
        {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          // 'Content-Type': 'application/json',
        },
      );

      final decodedData = json.decode(response.body.toString());
      debugPrint("📥 Payment Submission Response: $decodedData");

      if (response.statusCode == 200) {
        if (decodedData['status'] == false) {
          Future.delayed(Duration.zero, () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(decodedData['message'].toString()),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating));
          });
        }
      }
    }
  } on SocketException {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Internet connection error"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating));
  } catch (e) {
    debugPrint("💥 Error Submitting Payment Status: $e");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Something went wrong: $e"),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ));
  }
}
