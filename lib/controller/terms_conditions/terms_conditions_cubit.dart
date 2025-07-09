import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/terms_conditions_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';

part 'terms_conditions_state.dart';

class TermsConditionsCubit extends Cubit<TermsConditionsState> {

  TermsConditionsCubit() : super(InitialTermsConditions());
  ApiManager apiManager = ApiManager();

  /// Fetch Terms and Conditions
  Future<void> fetchTermsConditionsAPI() async {
    if (state is TermsConditionsLoading) return;

    emit(TermsConditionsLoading());
    try {
      // Fetching the response from the API
      final response = await apiManager.getRequest("${Config.baseURL}${Routes.termsOfConditions}");
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Parse the data from the response
        final termsConditionsModel = TermsConditionsModel.fromJson(responseData);
        // Emit the loaded state with the parsed data
        emit(TermsConditionsLoaded(termsConditionsModel: termsConditionsModel));
      } else {
        emit(TermsConditionsFailed(errorMessage: "Failed to load data."));
      }
    } on SocketException {
      emit(TermsConditionsInternetError(errorMessage: "No internet connection."));
    } catch (e) {
      emit(TermsConditionsFailed(errorMessage: "An error occurred: $e"));
    }
  }
}
