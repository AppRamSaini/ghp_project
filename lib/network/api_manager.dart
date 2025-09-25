import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../model/outgoing_document_model.dart';

class ApiManager {
  Future<http.Response> getRequest(String url,
      {bool usePropertyID = false}) async {
    try {
      final token = LocalStorage.localStorage.getString('token');
      final propertyId = LocalStorage.localStorage.getString('property_id');

      if (kDebugMode) {
        print('API URL: $url');
        print('Token: $token');
        print('Property ID: $propertyId (usePropertyID: $usePropertyID)');
      }

      final headers = {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        if (usePropertyID && propertyId != null) 'x-property-id': propertyId,
      };

      final uri = Uri.parse(url);
      final response = await http.get(uri, headers: headers);

      // if (kDebugMode) {
      //   print('Status Code: ${response.statusCode}');
      //   print('Response Body: ${response.body}');
      // }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error in getRequest: $e');
      }
      rethrow;
    }
  }

  deleteRequest(var url, {bool usePropertyID = false}) async {
    var token = LocalStorage.localStorage.getString('token');
    var propertyId = LocalStorage.localStorage.getString('property_id');

    if (kDebugMode) {
      print('url--->$url');
    }
    if (kDebugMode) {
      print('token--- > $token');
    }
    if (kDebugMode) {
      print('id--> ${propertyId!}$usePropertyID');
    }
    var response;
    if (token == null) {
      response = await http.delete(Uri.parse(url));
    } else {
      response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          if (usePropertyID) 'x-property-id': '$propertyId',
        },
      );
    }

    return response;
  }

  postRequest(var body, var url, var header) async {
    var token = LocalStorage.localStorage.getString('token');
    // var propertyId = LocalStorage.localStorage.getString('property_id');
    if (kDebugMode) {
      print('url--->$url');
    }
    if (kDebugMode) {
      print('token--- > $token');
    }

    var response;
    if (body != null) {
      response = await http.post(Uri.parse(url), body: body, headers: header);
    } else {
      response = await http.post(Uri.parse(url), headers: header);
    }
    print(json.decode(response.body.toString()));
    return response;
  }

  Future<bool> downloadFiles(List<FileElement> documents) async {
    var random = Random();
    bool allDownloadsSuccessful = true;

    for (FileElement document in documents) {
      final http.Response response = await http.get(Uri.parse(document.path!));
      final dir = await getTemporaryDirectory();
      var filename;
      if (document.path!.toLowerCase().endsWith('.pdf')) {
        filename = '${dir.path}/SavePdf${random.nextInt(100)}.pdf';
      } else if (document.path!.toLowerCase().endsWith('.png')) {
        filename = '${dir.path}/SaveImage${random.nextInt(100)}.png';
      } else if (document.path!.toLowerCase().endsWith('.jpeg') ||
          document.path!.toLowerCase().endsWith('.jpg')) {
        filename = '${dir.path}/SaveImage${random.nextInt(100)}.jpeg';
      } else if (document.path!.toLowerCase().endsWith('.jpeg') ||
          document.path!.toLowerCase().endsWith('.jfif')) {
        filename = '${dir.path}/SaveImage${random.nextInt(100)}.jfif';
      } else {
        allDownloadsSuccessful = false;
        continue;
      }

      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath == null) {
        allDownloadsSuccessful = false;
      }
    }

    return allDownloadsSuccessful;
  }
}
