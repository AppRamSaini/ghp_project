
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/privacy_policy_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
part 'privacy_policy_state.dart';

class PrivacyPolicyCubit extends Cubit<PrivacyPolicyState> {
  PrivacyPolicyCubit() : super(InitialPrivacyPolicy());
  ApiManager apiManager = ApiManager();

  /// Fetch Terms and Conditions
  Future<void> fetchPrivacyPolicyAPI() async {
    if (state is PrivacyPolicyLoading) return;
    emit(PrivacyPolicyLoading());
    try {
      // Fetching the response from the API
      final response = await apiManager.getRequest(Routes.privacyPolicy);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Parse the data from the response
        final privacyPolicyModel = PrivacyPolicyModel.fromJson(responseData);
        // Emit the loaded state with the parsed data
        emit(PrivacyPolicyLoaded(privacyPolicyModel: privacyPolicyModel));
      } else {
        emit(PrivacyPolicyFailed(errorMessage: "Failed to load data."));
      }
    } on SocketException {
      emit(PrivacyPolicyInternetError(errorMessage: "No internet connection."));
    } catch (e) {
      emit(PrivacyPolicyFailed(errorMessage: "An error occurred: $e"));
    }
  }
}
