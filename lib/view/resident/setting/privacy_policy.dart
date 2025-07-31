import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final WebViewController controller;
  bool isLoading = true;

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
      appBar: appbarWidget(title: 'Privacy Policy'),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading) notificationShimmerLoading(),
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
