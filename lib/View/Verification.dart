// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:senpai/Common/Button.dart';
import 'package:senpai/Common/InputField.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/DashBord.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/model/UserModel.dart';
import 'package:url_launcher/url_launcher.dart';

class Verification extends StatefulWidget {
  final moblieKey;
  final dynamic verificationID;
  const Verification({
    Key? key,
    this.moblieKey,
    this.verificationID,
  }) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  var _otpValue = "";
  String vOtpID = "";
  String complete_Profile = " ";

  //----Timer variable------//

  int start = 60;
  bool wait = false;
  //-----Timer Function-------//
  void startTimer() {
    const onSec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onSec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("df..${widget.moblieKey}");
    //--------Timer--------//
    wait ? null : startTimer();
    setState(() {
      wait = true;
    });
    getUserModel();
  }

  bool? _isLoading = false;
  String verificationId = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: blueCom,
          centerTitle: true,
          title: Text(
            "Verification",
            style: btnWhite(context),
          ),
        ),
        body: Stack(
          children: [allFileds(), LoaderIndicator(_isLoading!)],
        ));
  }

  Widget allFileds() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      headers(),
      inputs(),
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
          Text("Verification", style: header(context)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: Text("Please Enter your OTP Sent to your number",
                textAlign: TextAlign.center, style: subheader(context)),
          )
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
            //  mobileInput(),
            otpBox(),
            // resetText(),
            _timer(),
            verifyBtn()
          ]),
        ),
      ),
    );
  }

  Widget _timer() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              right: MediaQuery.of(context).size.width * .1,
              //-----column--------------//
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //---------InkWell--------------//

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //---------Clock icon with ternary operator------//
                      Icon(
                        Icons.watch_later_outlined,
                        size: 18,
                        color: wait ? blueCom : Colors.transparent,
                      ),
                      //-------Rich text------------//
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: " $start sec",
                            style: TextStyle(
                                color: wait ? blueCom : Colors.transparent,
                                fontSize:
                                    MediaQuery.of(context).size.width * .04),
                          ),
                        ]),
                      ),
                    ],
                  ),

                  //-------Row-------------//
                  // InkWell(
                  //   onTap: wait
                  //       ? null
                  //       : () {
                  //           sendOTPSignUp();
                  //           startTimer();
                  //           setState(() {
                  //             start = 60;
                  //             wait = true;
                  //           });
                  //         },
                  //   //--------Container----------//
                  //   child: Container(
                  //     //-------Text with ternary operator-------//
                  //     child: Text(
                  //       "Resend OTP ?",
                  //       style: TextStyle(
                  //           color: wait ? Colors.transparent : blueCom),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
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
        //focusNode: passwordFocus,
        hintText: 'Mobile *',
        prefixIcon: Icon(
          Icons.call_outlined,
          color: black,
          size: 20,
        ),
        //  controller: passwordCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget otpBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container(
        // ignore: prefer_const_literals_to_create_immutables
        decoration: BoxDecoration(),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: OTPTextField(
            length: 6,
            otpFieldStyle: OtpFieldStyle(
                focusBorderColor: white,
                backgroundColor: white,
                enabledBorderColor: Colors.transparent),
            fieldStyle: FieldStyle.box,
            fieldWidth: 40,
            style: TextStyle(
              color: black,
              fontSize: 20,
            ),
            textFieldAlignment: MainAxisAlignment.spaceEvenly,
            onChanged: (String value) {
              _otpValue = value;
            },
            onCompleted: (pin) {
              print("Completed: " + pin);
            },
          ),
        ),
      ),
    );
  }

  Widget resetText() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 23, horizontal: 20),
      child: RichText(
        text: TextSpan(
          text: 'Didn’t  get code? ',
          style: bottomheader(context),
          children: [
            TextSpan(text: 'Resend OTP', style: blueheader(context)),
          ],
        ),
      ),
    );
  }

  Widget verifyBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Button(
          key: Key('Verify'),
          buttonName: "Verify",
          onPressed: () {
            //  _verifyOtp();
            //-----new changes
            verify();
          },
        ),
      ),
    );
  }

  //------------verifiy oTp

  Future<void> verify() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationID, smsCode: _otpValue);
    // _signUpApi();
    signInWithPhoneAuthCredential(phoneAuthCredential);
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);

      print("successful");

      _signUpApi();
      if (authCredential.user != null) {}
      return showToastMessage("Verify OTP successful", context);
    } on FirebaseAuthException catch (e) {
      print("faild");
      print(e);
      return showToastMessage("OTP not Verify Please enter the current", context);
    }
  }

  // //--------Api verifyotp----------//
  _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    var user = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print("userName...${user.name}");
      print("mobile_number..${user.mobile_number}");
      print("language_id...${user.language_id}");
      print("country_id...${user.country_id}");
      print("state_id...${user.state_id}");
      print("city_id...${user.city_id}");
      print("email_id...${user.email_id}");
      print("language...${user.language_id}");
      print("intrest...${user.interest_id}");
    }

    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/otpVerification'),
      body: {
        "mobile_number": user.mobile_number,
        "otp": _otpValue.toString(),
        "otp_id": Preference().getString(Preference.OTP_ID)
      },
    ).then(
      (response) {
        print("VerifyOtp==>\t\t${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          // setState(() {
          //   _isLoading = false;
          // });
//-----new changes
          //   _signUpApi();
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(mgs),
            ),
          );
        }
      },
    );
  }

//-----sendOtp----
  sendOTPSignUp() async {
    setState(() {
      _isLoading = true;
    });
    http.post(
      Uri.parse("${APIConstants.senpaiBaseUrl}user/sendOtp"),
      body: {
        "mobile_number": widget.moblieKey,
      },
    ).then(
      (response) {
        print("Optsend.....${response.body}");
        dynamic result = json.decode(response.body);
        String message = result['message'];
        if (result['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          showToastMessage("otp send sucessfully", context);
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(message),
            ),
          );
        }
      },
    );
  }

  _signUpApi() async {
    print("........");
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    var user = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print("mobileS...${user.name}");
      print("mobileS...${user.mobile_number}");
      print("languageS...${user.language_id}");
      print("intresetS...${user.interest_id}");
      print("mobileS...${user.email_id}");
      print("mobileS...${user.country_id}");
      print("languageS...${user.state_id}");
      print("intresetS...${user.city_id}");
      print("intresetS...${user.city_id}");
      print("intresetS...${Preference().getString(Preference.DEVICE_TOKEN)}");
      print("intresetS...${Preference().getString(Preference.PASSWORD)}");
    }
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/userRegister'),
      body: {
        "name": user.name,
        "email_id": user.email_id,
        "mobile_number": user.mobile_number,
        "password": Preference().getString(Preference.PASSWORD),
        "country_id": user.country_id,
        "state_id": user.state_id,
        "city_id": user.city_id,
        "language_id": user.language_id,
        "interest_id": user.interest_id,
        "device_type": "1",
        "device_token": Preference().getString(Preference.DEVICE_TOKEN),
        "user_image": "",
      },
    ).then(
      (response) {
        print("Registration...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          String user_id = result1['user']['user_id'].toString();
          String user_unique_id = result1['user']['user_unique_id'].toString();
          String name = result1['user']['name'].toString();
          String email_id = result1['user']['email_id'].toString();
          String security_code = result1['user']['security_code'].toString();
          String rate_ammount = result1['user']['rate_ammount'].toString();
          saveUserData(result1);
          Preference().setLoginBool(Preference.IS_LOGIN, true);
          Preference().setString(Preference.USER_ID, user_id);
          Preference().setString(Preference.NAME, name);
          Preference().setString(Preference.EMAIL, email_id);
          Preference().setString(Preference.USER_UNIQUE_ID, user_unique_id);
          Preference().setString(Preference.SECURITY_CODE, security_code);
          Preference().setString(Preference.SIGNUP_PROFILE_PRETANCE, '20');
          Preference().setString(Preference.RATE_AMMOUNT, rate_ammount);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text("Registration Successful."),
            ),
          );
          //  _showMyDialog();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(mgs),
            ),
          );
        }
      },
    );
  }

  void saveUserData(dynamic userResponse) {
    dynamic userJsonObject = userResponse['user'];
    UserModel userModel = UserModel.fromJson(userJsonObject);
    String userModelStr = jsonEncode(userModel);
    print("saveUserVerification $userModelStr");
    Preference().setString(Preference.USER_MODEL, userModelStr);
    getUserModel();
  }

  void getUserModel() async {
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    print("jsondatais...${jsondatais}");
    var user = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print("mobileV...${user.name}");
      print("mobileV...${user.mobile_number}");
      print("languageV...${user.language_id}");
      print("intresetV...${user.interest_id}");
      print("languageModel...${user.language.toString()}");
      print("intresetModel...${user.interest.toString()}");
    }
    if (jsondatais.isNotEmpty) {}
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            height: 30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: Center(
              child: Text(
                "Terms and Conditions".toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
          content: Container(
            height: 100,
            width: 90,
            decoration: BoxDecoration(
                // color: Colors.red,
                ),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    text:
                        "By accepting all terms and privacy and data security purprose, visit our link:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    // children: [
                    //   TextSpan(
                    //     text:
                    //         "https://swchspacs.com/index.php/UserLevelTwo/getPolicy/1",
                    //     style: TextStyle(color: Colors.blue, fontSize: 10),
                    //   ),
                    // ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    launch(
                        "https://swchspacs.com/index.php/UserLevelTwo/getPolicy/1");
                  },
                  child: Text(
                    "https://swchspacs.com/index.php/UserLevelTwo/getPolicy/1",
                    style: TextStyle(color: Colors.blue, fontSize: 10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Dashboard()));
                    },
                    child: Container(
                      height: 28,
                      width: MediaQuery.of(context).size.width * .3,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Agree',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
