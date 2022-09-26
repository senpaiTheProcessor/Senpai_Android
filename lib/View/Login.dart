// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:senpai/Common/Button.dart';
import 'package:senpai/Common/InputField.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/DashBord.dart';
import 'package:senpai/View/Forgot_password.dart';
import 'package:senpai/View/bottomTabs/Home.dart';
import 'package:senpai/View/Registion.dart';
import 'package:senpai/View/Reset_password.dart';
import 'package:senpai/View/Verification.dart';

import 'package:senpai/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Prefrence/network.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FocusNode? myFocusNode;
   dynamic app_setting = "";
  TextEditingController mobCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  final FocusNode moblieNumberFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool? _isLoading = false;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
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
    getAppSetting();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: blueCom,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Log-in",
            style: btnWhite(context),
          ),
        ),
        body: Stack(
          children: [
            inputsfiled(),
            LoaderIndicator(_isLoading!),
          ],
        ));
  }

  Widget inputsfiled() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      headers(),
      inputs(),
      registionText(),
    ]);
  }

  Widget headers() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 10),
            child: Image.asset(
              "assets/logo/logo_senpai.png",
            ),
          ),
          Text("Sign-in", style: header(context)),
          Text("Login to your account", style: subheader(context))
        ],
      ),
    );
  }

  Widget inputs() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 17),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: Color(0xffF4F4F4)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Column(children: [
            mobileInput(),
            passwordInput(),
            forgotPass(),
            loginBtn()
          ]),
        ),
      ),
    );
  }

  Widget mobileInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: TextFieldDesign(
        key: Key("Mobile"),
        textInputAction: TextInputAction.next,
        controller: mobCon,
        maxlength: 14,
        keyBoardType: TextInputType.phone,
        focusNode: moblieNumberFocus,
        hintText: 'Mobile',
        prefixIcon: Icon(
          Icons.call_outlined,
          color: black,
          size: 20,
        ),
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () =>
            {FocusScope.of(context).requestFocus(passwordFocus)},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: TextFieldDesign(
        obsecureText: _obscureText,
        key: Key("Password"),
        textInputAction: TextInputAction.done,
        controller: passwordCon,
        focusNode: passwordFocus,
        hintText: 'Password',
        prefixIcon: Icon(
          Icons.lock_outline,
          color: black,
          size: 20,
        ),

        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
              color: black, size: 20),
        ),
        //  controller: passwordCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {FocusScope.of(context).unfocus()},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget forgotPass() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ForgotPassword()));
      },
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 5),
          child: Text(
            "Forgot Password?",
            style: bottomheader(context),
          ),
        ),
      ),
    );
  }

  onPresedLogin() {
    if (mobCon.text.toString().trim().isEmpty) {
      return showToastMessage("Enter Mobile Number", context);
    } else if (mobCon.text.length < 10 || mobCon.text.length > 14) {
      return showToastMessage("Enter a valid Mobile Number", context);
    } else if (passwordCon.text.toString().isEmpty) {
      return showToastMessage("Enter your Password", context);
    } else if (passwordCon.text.toString().length < 6) {
      return showToastMessage("Password at least 6 characters", context);
    } else {
      _lOGINAPI();
    }
  }

  Widget loginBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Button(
          key: Key('login_button'),
          buttonName: "Login",
          onPressed: () {
            onPresedLogin();
          },
        ),
      ),
    );
  }

  Widget registionText() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Registion(),
            ),
          );
        },
        child: RichText(
          text: TextSpan(
            text: 'Don’t have an account?',
            style: bottomheader(context),
            children: [
              TextSpan(text: ' SignUp', style: blueheader(context)),
            ],
          ),
        ),
      ),
    );
  }

  _lOGINAPI() async {
    setState(() {
      _isLoading = true;
    });
    //log(">>>>>>>>>>$otp_ID,,,,,,,,,,$otpCon");
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/userLogin'),
      body: {
        "email_id": mobCon.text,
        "password": passwordCon.text,
        "device_type": "1",
        "device_token": Preference().getString(Preference.DEVICE_TOKEN)
      },
    ).then(
      (response) {
        setState(() {
          _isLoading = false;
        });
        log("Login...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          // login

          saveUserData(result1);

          log("wallet_balance...${result1['user']['user_wallet_balance']}");
          log("wallet_balance...${result1['user']['experience']}");
          log("wallet_balance...${result1['user']['study_field']}");
          log("wallet_balance...${result1['user']['location']}");
          log("wallet_balance...${result1['user']['occupation']}");
          double walletAmount = 0.0;
          int editPercentage = 0;
          int experienceUser = 0;
          int studyfieldUser = 0;
          int locationUser = 0;
          int occupationUser = 0;
          String is_blue_tick = '';
          String is_notification ='';
          String is_request = '';
          String is_blog = '';
          String start_time = '';
          String end_time = '';
          dynamic rate_ammount = "";

          try {
            rate_ammount = result1['user']['rate_amount'].toString();
          } catch (e) {}

          try {
            walletAmount =
                double.parse(result1['user']['user_wallet_balance'].toString());
          } catch (e) {}

          try {
            editPercentage = result1['user']['user_image'].toString().length;
          } catch (e) {}
          try {
            experienceUser = result1['user']['experience'].length;
          } catch (e) {}
          try {
            studyfieldUser = result1['user']['study_field'].length;
          } catch (e) {}
          try {
            locationUser = result1['user']['location'].length;
          } catch (e) {}
          try {
            occupationUser = result1['user']['occupation'].length;
          } catch (e) {}
          try {
            is_blue_tick = result1['user']['is_blue_tick'];
          } catch (e) {}
          try {
            is_notification = result1['user']['new_notification'];
          } catch (e) {}
          try {
            is_request = result1['user']['new_request'];
          } catch (e) {}
          try {
            is_blog = result1['user']['new_blog'];
          } catch (e) {}
          try {
            start_time = result1['user']['start_time'];
          } catch (e) {}
          try {
            end_time = result1['user']['end_time'];
          } catch (e) {}
          Preference().setString(Preference.IS_BLUE_TICK, is_blue_tick);
          Preference().setString(Preference.START_TIME, start_time);
          Preference().setString(Preference.END_TIME, end_time);
          Preference().setString(Preference.RATE_AMMOUNT, rate_ammount);
          Preference().setString(Preference.NEW_NOTIFICATION, is_notification);
            Preference().setString(Preference.NEW_NOTIFICATION, is_blog);
              Preference().setString(Preference.NEW_NOTIFICATION, is_request);


          if (editPercentage > 0) {
            Preference().setString(Preference.EDIT_PROFILE_PRETANCE, "10");
          }
          if (walletAmount > 0) {
            Preference().setString(Preference.WALLET_PROFILE_PRETANCE, "30");
          }
          if (experienceUser > 0) {
            Preference().setString(Preference.EXPERIANCE_PRETANCE, "15");
          }
          if (studyfieldUser > 0) {
            Preference().setString(Preference.EDUCATION_PRETANCE, "10");
          }
          if (occupationUser > 0) {
            Preference().setString(Preference.OCCUPATION_PRETANCE, "10");
          }
          if (locationUser > 0) {
            Preference().setString(Preference.LOCATION_PRETANCE, "5");
          }
          Preference().setString(Preference.SIGNUP_PROFILE_PRETANCE, "20");

          Preference().setString(Preference.CURRENT_BALANCE,
              result1['user']['user_wallet_balance']);

          Preference().setLoginBool(Preference.IS_LOGIN, true);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     backgroundColor: Colors.green,
          //     content: Text("Login Successful."),
          //   ),
          // );
          showToastMessage(mgs, context);

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        } else if (result1['status'] == 3) {
          var baseDialog = BaseAlertDialog(
            title: "Your account has been blocked by the Senpai admin.",
            content: "Please connect with the Senapi support",
            yesOnPressed: () async {
              Navigator.pop(context);
              // Navigator.pop(context);
              // //  Navigator.pop(context);
              // Preference().setLoginBool(Preference.IS_LOGIN, false);
              // //  Preference().setString(Preference.CURRENT_BALANCE, "00");
              // SharedPreferences userData =
              //     await SharedPreferences.getInstance();
              // await userData.clear();
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => Login(),
              //   ),
              //   (route) => false,
              // );
            },
            noOnPressed: () {
              // Navigator.pop(context);
            },
            yes: "Ok ",
            no: " ",
          );
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => baseDialog);
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     backgroundColor: Colors.red,
          //     content: Text(mgs),
          //   ),
          // );
          showToastMessage(mgs, context);
        }
      },
    );
  }

  void saveUserData(dynamic userResponse) {
    dynamic userJsonObject = userResponse['user'];
    UserModel userModel = UserModel.fromJson(userJsonObject);
    String userModelStr = jsonEncode(userModel);
    print(userModelStr);
    Preference().setString(Preference.USER_MODEL, userModelStr);
    getUserModel();
  }

  void getUserModel() async {
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    var user = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print(user.name);
    }
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
            Preference().setString(
                Preference.AGORA_APP_ID, setting['app_key'].toString());
          } else if (setting['key_name'].toString() == "agora_channel_key") {
            Preference().setString(
                Preference.AGORA_CHANNET_ID, setting['app_key'].toString());
          } else if (setting['key_name'].toString() ==
              "agora_channel_auth_token") {
            Preference().setString(
                Preference.AGORA_TOKEN_ID, setting['app_key'].toString());
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
