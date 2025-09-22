// To parse this JSON data, do
//
//     final OTPModel = requstOtpModelFromJson(jsonString);

import 'dart:convert';

OTPModel OTPModelFromJson(String str) => OTPModel.fromJson(json.decode(str));

String OTPModelToJson(OTPModel data) => json.encode(data.toJson());

class OTPModel {
  String? message;

  OTPModel({this.message});

  factory OTPModel.fromJson(Map<String, dynamic> json) =>
      OTPModel(message: json["message"]);

  Map<String, dynamic> toJson() => {"message": message};
}
