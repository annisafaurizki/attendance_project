import 'dart:convert';

import 'package:attendance_project/endpoint/endpoint.dart';
import 'package:attendance_project/model/otp_model.dart';
import 'package:http/http.dart' as http;

class OTPService {
  static Future<OTPModel> requestOtp(String email) async {
    final url = Uri.parse(Endpoint.otp);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return OTPModel.fromJson(data);
    } else {
      throw Exception(
        'Gagal mengirim permintaan OTP. Status: ${response.statusCode}',
      );
    }
  }

  static Future<OTPModel> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final url = Uri.parse(Endpoint.reset);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'otp': otp, 'password': newPassword}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return OTPModel.fromJson(data);
    } else {
      throw Exception('Gagal reset password. Status: ${response.statusCode}');
    }
  }
}
