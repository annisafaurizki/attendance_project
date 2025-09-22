import 'dart:convert';

import 'package:attendance_project/endpoint/endpoint.dart';
import 'package:attendance_project/model/izin_model.dart';
import 'package:attendance_project/share_preferences/share_preferences.dart';
import 'package:http/http.dart' as http;

class IzinService {
  static Future<IzinModel> izinAbsen({
    required String date,
    required String alasanIzin,
  }) async {
    final url = Uri.parse(Endpoint.izin);
    final token = await PreferenceHandler.getToken();
    final response = await http.post(
      url,
      body: jsonEncode({"date": date, "alasan_izin": alasanIzin}),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      return IzinModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to Izin");
    }
  }
}
