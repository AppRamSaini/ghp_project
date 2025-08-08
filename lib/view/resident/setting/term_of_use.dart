import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/terms_conditions/terms_conditions_cubit.dart';

class TermOfUseScreen extends StatefulWidget {
  const TermOfUseScreen({super.key});

  @override
  State<TermOfUseScreen> createState() => _TermOfUseScreenState();
}

class _TermOfUseScreenState extends State<TermOfUseScreen> {
  late TermsConditionsCubit _termsConditionsCubit;

  @override
  void initState() {
    super.initState();
    _termsConditionsCubit = TermsConditionsCubit()..fetchTermsConditionsAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(title: 'Terms & Conditions'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<TermsConditionsCubit, TermsConditionsState>(
          bloc: _termsConditionsCubit,
          builder: (context, state) {
            if (state is TermsConditionsLoading) {
              return notificationShimmerLoading();
            } else if (state is TermsConditionsLoaded) {
              final htmlData = state.termsConditionsModel.data;
              return SingleChildScrollView(
                  child: Html(data: htmlData.termsOfUse!.content.toString()));
            } else if (state is TermsConditionsFailed) {
              return Center(
                  child: Text(state.errorMessage.toString(),
                      style: const TextStyle(color: Colors.red)));
            } else if (state is TermsConditionsInternetError) {
              return Center(
                  child: Text(state.errorMessage.toString(),
                      style: const TextStyle(color: Colors.red)));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
