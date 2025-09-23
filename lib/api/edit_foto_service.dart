import 'dart:convert';
import 'dart:io';

import 'package:attendance_project/endpoint/endpoint.dart';
import 'package:attendance_project/model/edit_foto_model.dart';
import 'package:attendance_project/share_preferences/share_preferences.dart';
import 'package:http/http.dart' as http;

class PhotoAPI {
  static Future<EditFotoModel> updatePhotoProfile({
    required File profilePhoto,
  }) async {
    final url = Uri.parse(Endpoint.photo);

    // ambil token di dalam fungsi async
    final token = await PreferenceHandler.getToken();

    // baca file dan encode ke base64
    final readImage = await profilePhoto.readAsBytes();
    final b64 = base64Encode(readImage);
    final imageWithPrefix = "data:image/png;base64,$b64";

    final response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "profile_photo": imageWithPrefix,
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      return EditFotoModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to update profile photo");
    }
  }
}
