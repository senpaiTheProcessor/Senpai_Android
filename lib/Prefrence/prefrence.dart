// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static const String DEVICE_TOKEN = "DEVICE_TOKEN";
  static const String AUTHORIZATION = 'Authorization';
  static const String FCM_TOKEN = 'FCM_TOKEN';
  static const String IS_LOGIN = 'IS_LOGIN';
  static const String USER_ID = 'USER_ID';
  static const String MOBILE = 'MOBILE';
  static const String OTP_ID = 'OTP_ID';
  static const String NAME = 'NAME';
  static const String EMAIL = 'EMAIL';
  static const String PASSWORD = 'PASSWORD';
  static const String SECURITY_CODE = 'SECURITY_CODE';
  static const String USER_UNIQUE_ID = 'USER_UNIQUE_ID';
  static const String USER_MODEL = 'USER_MODEL';
  
  static const String SIGNUP_PROFILE_PRETANCE = 'SIGNUP_PROFILE_PRETANCE';
  static const String EDIT_PROFILE_PRETANCE = 'EDIT_PROFILE_PRETANCE';
  static const String WALLET_PROFILE_PRETANCE = 'WALLET_PROFILE_PRETANCE';
  static const String EXPERIANCE_PRETANCE = 'EXPERIANCE_PRETANCE';
  static const String EDUCATION_PRETANCE = 'EDUCATION_PRETANCE';
  static const String LOCATION_PRETANCE = 'LOCATION_PRETANCE';
  static const String OCCUPATION_PRETANCE = 'OCCUPATION_PRETANCE';

  static const String START_TIME = 'START_TIME';
  static const String END_TIME = 'END_TIME';
  static const String CURRENT_BALANCE = 'CURRENT_BALANCE';
  static const String CALL_SETTING = 'CALL_SETTING';
  static const String RATE_AMMOUNT = 'RATE_AMMOUNT';
  static const String AGORA_APP_ID = 'AGORA_APP_ID';
  static const String AGORA_CHANNET_ID = 'AGORA_CHANNET_ID';
  static const String AGORA_TOKEN_ID = 'AGORA_TOKEN_ID';
  static const String AGORA_CERTIFICATE = 'AGORA_CERTIFICATE';
  static const String REZORPAY_KEY = 'REZORPAY_KEY';
  static const String IS_BLUE_TICK = 'IS_BLUE_TICK';
  static const String NEW_NOTIFICATION = 'NEW_NOTIFICATION';
  static const String NEW_BLOG = 'NEW_BLOG';
  static const String NEW_REQUEST = 'NEW_REQUEST';
  static const String Call_commission = "Call_commission";

  static final Preference _preference = Preference._internal();

  factory Preference() {
    return _preference;
  }

  Preference._internal();

  static Preference get shared => _preference;

  static SharedPreferences? _pref;

  /* make connection with preference only once in application */
  Future<SharedPreferences?> instance() async {
    if (_pref != null) return _pref;
    await SharedPreferences.getInstance().then((onValue) {
      _pref = onValue;
    }).catchError((onError) {
      _pref = null;
    });
    return _pref;
  }

  bool? getLoginBool(String key) {
    return _pref!.getBool(key);
  }

  setLoginBool(String key, bool vBoo) {
    _pref!.setBool(key, vBoo);
  }

  bool? getRememberMeBool(String key) {
    return _pref!.getBool(key);
  }

  setRememberMeBool(String key, bool vBoo) {
    _pref!.setBool(key, vBoo);
  }

  clearSession() {
    _pref!.remove(Preference.IS_LOGIN);
  }

  setString(String key, String value) {
    _pref!.setString(key, value);
  }

  setDouble(String key, double value) {
    _pref!.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _pref!.getDouble(key);
  }

  String? getString(String key) {
    return _pref!.getString(key);
  }
}
