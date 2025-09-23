import 'dart:convert';
import 'dart:io';

import 'package:attendance_project/endpoint/endpoint.dart';
import 'package:attendance_project/model/list_batch.dart';
import 'package:attendance_project/model/list_kejuruan.dart';
import 'package:attendance_project/model/login_model.dart';
import 'package:attendance_project/model/profile_model.dart';
import 'package:attendance_project/model/register_model.dart';
import 'package:attendance_project/share_preferences/share_preferences.dart';
import 'package:http/http.dart' as http;

class AuthenticationAPI {
  static Future<Register> registerUser({
    required String name,
    required String email,
    required String password,
    required String jenisKelamin,
    required File profilePhoto,
    required int batchId,
    required int trainingId,
  }) async {
    final url = Uri.parse(Endpoint.register);

    // baca file -> bytes -> base64
    final readImage = profilePhoto.readAsBytesSync();
    final b64 = base64Encode(readImage);

    // tambahkan prefix agar dikenali backend
    final imageWithPrefix = "data:image/png;base64,$b64";

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "jenis_kelamin": jenisKelamin,
        "profile_photo": imageWithPrefix,
        "batch_id": batchId,
        "training_id": trainingId,
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      return Register.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to Register");
    }
  }

  static Future<ListBatchModel> getAllBatch() async {
    final url = Uri.parse(Endpoint.batches);
    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    print("STATUS BATCH: ${response.statusCode}");
    print("BODY BATCH: ${response.body}");

    if (response.statusCode == 200) {
      return ListBatchModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Gagal mengambil data batch");
    }
  }

  static Future<ListTrainingModel> getAllKejuruan() async {
    final url = Uri.parse(Endpoint.trainings);
    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    print("STATUS TRAINING: ${response.statusCode}");
    print("BODY TRAINING: ${response.body}");

    if (response.statusCode == 200) {
      return ListTrainingModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Gagal mengambil data kejuruan");
    }
  }

  static Future<RegisterUserModel> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Endpoint.login);
    final response = await http.post(
      url,
      body: {"email": email, "password": password},
      headers: {"Accept": "application/json"},
    );

    print("Login Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = RegisterUserModel.fromJson(json.decode(response.body));
      await PreferenceHandler.saveToken(data.data?.token ?? "");
      await PreferenceHandler.saveLogin();

      final userId = data.data?.user?.id;
      if (userId != null) {
        await PreferenceHandler.saveUserId(userId);
        print("UserId saved: $userId");
      } else {
        print("UserId tidak ada di response");
      }

      return data;
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Something went wrong");
    }
  }

  static Future<GetProfileModel> getProfile() async {
    final url = Uri.parse(Endpoint.profile);
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("Profile Status: ${response.statusCode}");

    if (response.statusCode == 200) {
      return GetProfileModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      print(error);
      throw Exception(error["message"] ?? "Gagal mengambil profil");
    }
  }
}
