// ignore_for_file: unused_import, file_names, non_constant_identifier_names, prefer_if_null_operators
import 'dart:convert';
import 'package:senpai/model/Language.dart';

class UserModel {
  String name = "";
  String email_id = "";
  String mobile_number = "";
  String country_id = "";
  String state_id = "";
  String city_id = "";
  String language_id = "";
  String interest_id = "";
  String device_type = "";
  String device_token = "";
  String user_image = "";
  String user_id = "";
  String user_unique_id = "";
  String security_code = "";
  List<dynamic> language = [];
  List<dynamic> interest = [];
  String rate_amount = "";
  String start_time = "";
  String end_time = "";
  UserModel({
    required this.user_id,
    required this.user_unique_id,
    required this.security_code,
    required this.name,
    required this.email_id,
    required this.mobile_number,
    // required this.password,
    required this.country_id,
    required this.state_id,
    required this.city_id,
    required this.language_id,
    required this.interest_id,
    required this.device_type,
    required this.device_token,
    required this.user_image,
    required this.language,
    required this.interest,
    required this.rate_amount,
    required this.start_time,
    required this.end_time,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        user_id: json['user_id'],
        user_unique_id:
            json['user_unique_id'] == null ? "" : json['user_unique_id'],
        security_code:
            json['security_code'] == null ? "" : json['security_code'],
        name: json['name'] == null ? "" : json['name'],
        email_id: json['email_id'] == null ? "" : json['email_id'],
        mobile_number:
            json['mobile_number'] == null ? "" : json['mobile_number'],
        country_id: json['country_id'] == null ? "" : json['country_id'],
        state_id: json['state_id'] == null ? "" : json['state_id'],
        city_id: json['city_id'] == null ? "" : json['city_id'],
        language_id: json['language_id'] == null ? "" : json['language_id'],
        interest_id: json['interest_id'] == null ? "" : json['interest_id'],
        device_type: json['device_type'] != null ? "" : "",
        device_token: json['device_token'] != null ? "" : "",
        user_image: json['user_image'] != null ? json['user_image'] : "",
        language: json['language'] != null ? (json["language"]) : [],
        interest: json['interest'] != null ? (json["interest"]) : [],
        rate_amount: json['rate_amount'] == null ? "" : (json["rate_amount"]),
        start_time: json['start_time'] == null ? "" : (json["start_time"]),
        end_time: json['end_time'] == null ? "" : (json["end_time"]));
  }
  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'user_unique_id': user_unique_id,
      'security_code': security_code,
      'name': name,
      'email_id': email_id,
      'mobile_number': mobile_number,
      'country_id': country_id,
      'state_id': state_id,
      'city_id': city_id,
      'language_id': language_id,
      'interest_id': interest_id,
      'device_type': device_type,
      'device_token': device_token,
      'user_image': user_image,
      'language': language,
      'interest': interest,
      'rate_amount': rate_amount,
      'start_time': start_time,
      'end_time': end_time
    };
  }
}
