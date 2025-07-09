import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../model/outgoing_document_model.dart';

class ApiManager {
  getRequest(var url) async {
    var token = LocalStorage.localStorage.getString('token');
    print(url);
    print(token);
    var response;
    if (token == null) {
      response = await http.get(
        Uri.parse(url),
      );
    } else {
      response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
    }

    return response;
  }

  deleteRequest(var url) async {
    var token = LocalStorage.localStorage.getString('token');
    print(url);
    print(token);
    var response;
    if (token == null) {
      response = await http.delete(Uri.parse(url));
    } else {
      response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
    }

    return response;
  }

  putRequest(var alertBody, var url) async {
    var response = await http.put(Uri.parse(url), body: alertBody);
    return response;
  }

  postRequest(var body, var url, var header) async {
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
