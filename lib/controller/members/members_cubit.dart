import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/members_model.dart';
import 'package:meta/meta.dart';
import '../../network/api_manager.dart';
part 'members_state.dart';

class MembersCubit extends Cubit<MembersState> {
  MembersCubit() : super(MembersInitial());

  ApiManager apiManager = ApiManager();

  SocietyMembersModel memberList = SocietyMembersModel();

  fetchMembers(String blockName, String floorId, String type) async {
    emit(MembersLoading());
    try {
      var response = await apiManager.getRequest(
          "${Config.baseURL}${Routes.members(blockName, floorId, type)}");
      var responseData = json.decode(response.body.toString());
      if (response.statusCode == 200) {
        if (responseData['status']) {
          memberList = SocietyMembersModel.fromJson(responseData);
          emit(MembersLoaded(membersList: memberList));
          return responseData;
        } else {
          emit(MembersFailed(errorMessage: responseData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(MembersLogout());
        return null;
      } else {
        emit(MembersFailed(errorMessage: responseData['message'].toString()));
        return null;
      }
    } on SocketException {
      emit(MembersInternetError());
    } catch (e) {
      emit(MembersFailed(errorMessage: e.toString()));
      return null;
    }
  }

  /// SEARCH MEMEBRS
  void searchMembers(String query) {
    // print("🔍 Searching for: $query"); // 🟢 Debugging log
    // if (memberList.data == null || memberList.data!.properties == null) {
    //   print("⚠️ No properties found!"); // 🟠 Debugging log
    //   emit(MembersSearchedLoaded(propertyMember: SocietyData(properties: [])));
    //   return;
    // }
    // Filter properties based on the member search
    List<Property> filteredProperties = memberList.data!.properties!
        .map((property) {
          List<PropertyNumber> filteredPropertyNumbers = property
              .propertyNumbers!
              .where((propertyNumber) =>
                  propertyNumber.memberInfo != null &&
                  propertyNumber.memberInfo!.name != null &&
                  propertyNumber.memberInfo!.name!
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .toList();

          if (filteredPropertyNumbers.isNotEmpty) {
            return Property(
                floor: property.floor,
                propertyNumbers: filteredPropertyNumbers,
                totalUnits: filteredPropertyNumbers.length,
                occupied: filteredPropertyNumbers
                    .where((e) => e.memberInfo != null)
                    .length,
                vacant: 0);
          } else {
            return null;
          }
        })
        .whereType<Property>()
        .toList(); // Remove nulls

    // Create a new SocietyData object with filtered properties
    SocietyData filteredSocietyData = SocietyData(
      totalUnits: filteredProperties.fold(
          0, (sum, property) => sum! + (property.totalUnits ?? 0)),
      occupied: filteredProperties.fold(
          0, (sum, property) => sum! + (property.occupied ?? 0)),
      vacant: filteredProperties.fold(
          0, (sum, property) => sum! + (property.vacant ?? 0)),
      properties: filteredProperties,
    );

    print('✅ Total members found: ${filteredProperties.length}');

    // Emit the new SocietyData with filtered results
    emit(MembersSearchedLoaded(propertyMember: filteredSocietyData));
  }
}
