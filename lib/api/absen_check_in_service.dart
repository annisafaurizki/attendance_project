import 'dart:convert';

import 'package:attendance_project/endpoint/endpoint.dart';
import 'package:attendance_project/model/absen_keluar_model.dart';
import 'package:attendance_project/model/absen_model.dart';
import 'package:attendance_project/share_preferences/share_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AttendanceAPI {
  static Future<AbsenCheckInModel?> checkInUser({
    required double checkInLat,
    required double checkInLng,
    required String checkInLocation,
    required String checkInAddress,
  }) async {
    try {
      final token = await PreferenceHandler.getToken();

      final now = DateTime.now();
      final attendanceDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final checkInTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      final response = await http.post(
        Uri.parse(Endpoint.checkIn),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "attendance_date": attendanceDate,
          "check_in": checkInTime,
          "check_in_lat": checkInLat.toString(),
          "check_in_lng": checkInLng.toString(),
          "check_in_location": checkInLocation,
          "check_in_address": checkInAddress,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return AbsenCheckInModel.fromJson(jsonResponse);
      } else {
        print("CheckIn Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error CheckIn: $e");
      return null;
    }
  }

  static Future<AbsenCheckOutModels> checkOut({
    required double checkOutLat,
    required double checkOutLng,
    required String checkOutLocation,
    required String checkOutAddress,
  }) async {
    final url = Uri.parse(Endpoint.checkOut);
    final token = await PreferenceHandler.getToken();

    final now = DateTime.now();
    final attendanceDate = DateFormat('yyyy-MM-dd').format(now);
    final checkOutTime = DateFormat('HH:mm').format(now);

    final response = await http.post(
      url,
      body: {
        'attendance_date': attendanceDate,
        'check_out': checkOutTime,
        'check_out_lat': checkOutLat.toString(),
        'check_out_lng': checkOutLng.toString(),
        'check_out_address': checkOutAddress,
      },
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("Check-Out Status: ${response.statusCode}");
    print("Check-Out Response: ${response.body}");

    if (response.statusCode == 200) {
      return AbsenCheckOutModels.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      final errorMessage = error["message"] ?? "Gagal melakukan check-out";

      // Parse error details jika ada
      if (error["errors"] != null) {
        final errors = error["errors"] as Map<String, dynamic>;
        final errorDetails = errors.entries
            .map((e) => "${e.value[0]}")
            .join(", ");
        throw Exception("$errorMessage: $errorDetails");
      }

      throw Exception(errorMessage);
    }
  }
}
