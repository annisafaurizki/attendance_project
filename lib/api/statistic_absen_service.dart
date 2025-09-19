import 'dart:convert';

import 'package:attendance_project/endpoint/endpoint.dart';
import 'package:attendance_project/model/statistik_absen_model.dart';
import 'package:attendance_project/share_preferences/share_preferences.dart';
import 'package:http/http.dart' as http;

class StatsAPI {
  static Future<StatsModel> getStats() async {
    final url = Uri.parse(Endpoint.stats);
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("Profile Status: ${response.statusCode}");

    if (response.statusCode == 200) {
      return StatsModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      print(error);
      throw Exception(error["message"] ?? "Gagal mengambil profil");
    }
  }
}
