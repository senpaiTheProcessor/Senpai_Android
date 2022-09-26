// ignore_for_file: prefer_const_constructors, nullable_type_in_catch_clause

import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/DashBord.dart';
import 'package:senpai/View/Login.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/onboarding/home_onboradind.dart';
import 'package:senpai/onboarding/useAPP.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  dynamic app_setting = "";
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  var time;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _devicsToken() {
    _firebaseMessaging.getToken().then((token) {
      print('token...$token}');
      Preference().setString(Preference.DEVICE_TOKEN, token!);
    });
  }

  @override
  void initState() {
    super.initState();
    app_setting = "";
    _devicsToken();
    initConnectivity();
    getAppSetting();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);
    time = Timer.periodic(const Duration(seconds: 3), (time) {
      time.cancel();
      setState(() {});
      Preference().getLoginBool(Preference.IS_LOGIN) == true
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(
                  selectedTab: 0,
                  tabBarIndex: 0,
                ),
              ),
            )
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UseApp(),
              ),
            );
    });
  }

  @override
  Future<void>? dispose() {
    _connectivitySubscription.cancel();
    time.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Error Occurred: ${e.toString()} ");
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _UpdateConnectionState(result);
  }

  Future<void> _UpdateConnectionState(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      // showStatus(result, true);
    } else {
      showStatus(result, false);
      // walletpopupBox(result, false);
    }
  }

  void showStatus(ConnectivityResult result, bool status) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content:
            Text("${status ? 'ONLINE\n' : 'OFFLINE\n'}${result.toString()} "),
        backgroundColor: status ? Colors.green : Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Tween<double> _scaleTween = Tween<double>(begin: 0, end: 6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Container(
          //     height: MediaQuery.of(context).size.height,
          //     width: MediaQuery.of(context).size.width,
          //   ),

          // Text(lastPosition),
          TweenAnimationBuilder(
            tween: _scaleTween,
            duration: Duration(seconds: 3),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale as double,
                child: child,
              );
            },  child: Center(
              child: Container(
                width:  MediaQuery.of(context).size.width*0.05,
                height:  MediaQuery.of(context).size.height*0.06,
              
                child: Center(
                  child: Image.asset('assets/logo/logo_senpai.png',
                  width: 500,
                  ),
                ),
              ),
            ),
            // child: Center(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 90),
            //     child: Image.asset(
            //       'assets/logo/logo_senpai.png',
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }

  Widget walletpopupBox(ConnectivityResult result, bool status) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 16,
                  left: 16,
                  right: 16,
                ),
                margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    Text(
                      "${status ? 'ONLINE\n' : 'OFFLINE\n'}${result.toString()} ",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Dashboard(),
                        //   ),
                        // );
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  getAppSetting() {
    //log(">>>>>>>>>>$otp_ID,,,,,,,,,,$otpCon");
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/getAppSetting'),
      body: {},
    ).then(
      (response) {
        dynamic res = json.decode(response.body);
        app_setting = res['setting'];

        for (var setting in app_setting) {
          if (setting['key_name'].toString() == "agora_app_id") {
            // Preference().setString(
            //     Preference.AGORA_APP_ID, setting['app_key'].toString());
          } else if (setting['key_name'].toString() == "agora_channel_key") {
            // Preference().setString(
            //     Preference.AGORA_CHANNET_ID, setting['app_key'].toString());
          } else if (setting['key_name'].toString() ==
              "agora_channel_auth_token") {
            // Preference().setString(
            //     Preference.AGORA_TOKEN_ID, setting['app_key'].toString());
          } else if (setting['key_name'].toString() == "razor_test_key") {
            Preference().setString(
                Preference.REZORPAY_KEY, setting['app_key'].toString());
          }
        }

        print("app seting..${res}");
        String mgs = res['message'];
        if (res['status'] == 1) {
          // login

          // log("wallet_balance...${result1['user']['user_wallet_balance']}");

          // Preference().setString(Preference.CURRENT_BALANCE,
          //     result1['user']['user_wallet_balance']);

        } else {}
      },
    );
  }
}
