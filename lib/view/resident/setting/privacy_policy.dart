import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/controller/privacy_policy/privacy_policy_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final WebViewController controller;
  bool isLoading = true; // 🟢 loader state

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(Routes.privacyPolicyPage)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(Routes.privacyPolicyPage));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Privacy Policy',
              style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600)))),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.deepPurpleAccent,
              ),
            ),
        ],
      ),


      /*Padding(
        padding: const EdgeInsets.all(10.0),
        child:




        BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyState>(
          builder: (context, state) {
            if (state is PrivacyPolicyLoading) {
              return const Center(
                  child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.deepPurpleAccent));
            } else if (state is PrivacyPolicyLoaded) {
              final htmlData = state.privacyPolicyModel.data;
              return SingleChildScrollView(
                  child: Html(data: htmlData.privacyPolicy.content.toString()));
            } else if (state is PrivacyPolicyFailed) {
              return Center(
                  child: Text(state.errorMessage.toString(),
                      style: const TextStyle(color: Colors.red)));
            } else if (state is PrivacyPolicyInternetError) {
              return Center(
                  child: Text(state.errorMessage.toString(),
                      style: const TextStyle(color: Colors.red)));
            }
            return const SizedBox();
          },
        ),
      ),*/
    );
  }
}