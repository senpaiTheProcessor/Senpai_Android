// ignore_for_file: file_names, unused_element, prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:senpai/Common/Button.dart';
import 'package:senpai/Common/InputField.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/Login.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  FocusNode? myFocusNode;
  TextEditingController oldPasswordCon = TextEditingController();

  TextEditingController newPasswordCon = TextEditingController();
  TextEditingController reEnterpasswordCon = TextEditingController();
  final FocusNode oldPasswordFocus = FocusNode();

  final FocusNode newPasswordFocus = FocusNode();
  final FocusNode reEnterpasswordFocus = FocusNode();
  // Initially password is obscure
  bool _obscureTextnew = true;
  bool? _isLoading = false;
  bool _obscureTextold = true;

  void _toggleold() {
    setState(() {
      _obscureTextold = !_obscureTextold;
      // _obscureText = !_obscureText;
    });
  }

  // Toggles the password show status
  void _toggle1() {
    setState(() {
      _obscureTextnew = !_obscureTextnew;
      // _obscureText = !_obscureText;
    });
  }

  // Initially password is obscure
  bool _obscureText = true;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: blueCom,
          centerTitle: true,
          title: Text(
            "Change Password",
            style: btnWhite(context),
          ),
        ),
        body: Stack(
          children: [allFiled(), LoaderIndicator(_isLoading!)],
        ));
  }

  Widget allFiled() {
    return SingleChildScrollView(
      child: Column(children: [
        headers(),
        inputs(),
        SizedBox(
          height: 300,
        )
      ]),
    );
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
          Text("Change Password", style: header(context)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 37),
            child: Text(
                "Set the new password for your account so you can login and access all the feature",
                textAlign: TextAlign.center,
                style: subheader(context)),
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
            oldPassword(),
            enterNewPassword(),
            reEnterPassword(),
            resetBtn()
          ]),
        ),
      ),
    );
  }

  Widget oldPassword() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: TextFieldDesign(
        key: Key("Enter a new password"),
        textInputAction: TextInputAction.next,
        focusNode: oldPasswordFocus,
        obsecureText: _obscureTextold,
        hintText: 'Enter a old password*',
        prefixIcon: Icon(
          Icons.lock_outline,
          color: black,
          size: 20,
        ),
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureTextold = !_obscureTextold;
            });
          },
          child: new Icon(
              _obscureTextold ? Icons.visibility_off : Icons.visibility,
              color: black,
              size: 20),
        ),
        controller: oldPasswordCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () =>
            {FocusScope.of(context).requestFocus(newPasswordFocus)},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget enterNewPassword() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: TextFieldDesign(
        key: Key("Enter a new password"),
        textInputAction: TextInputAction.next,
        focusNode: newPasswordFocus,
        obsecureText: _obscureTextnew,
        hintText: 'Enter a new password*',
        prefixIcon: Icon(
          Icons.lock_outline,
          color: black,
          size: 20,
        ),
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureTextnew = !_obscureTextnew;
            });
          },
          child: new Icon(
              _obscureTextnew ? Icons.visibility_off : Icons.visibility,
              color: black,
              size: 20),
        ),
        controller: newPasswordCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () =>
            {FocusScope.of(context).requestFocus(reEnterpasswordFocus)},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget reEnterPassword() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: TextFieldDesign(
        obsecureText: _obscureText,
        key: Key("Re - enter new password"),
        textInputAction: TextInputAction.next,
        focusNode: reEnterpasswordFocus,
        hintText: 'Re - enter new password*',
        prefixIcon: Icon(
          Icons.lock_outline,
          color: black,
          size: 20,
        ),
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: new Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: black,
              size: 20),
        ),
        controller: reEnterpasswordCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {FocusScope.of(context).unfocus()},
        onSaved: (String? newValue) {},
      ),
    );
  }

  onPresedSignUp() {
    if (oldPasswordCon.text.toString().isEmpty) {
      return showToastMessage("Enter old password", context);
    } else if (newPasswordCon.text.toString().isEmpty) {
      return showToastMessage("Enter new password", context);
    } else if (newPasswordCon.text.toString().length < 6) {
      return showToastMessage("Password at least 6 characters", context);
    } else if (reEnterpasswordCon.text.toString().isEmpty) {
      return showToastMessage("Enter confirm password", context);
    } else if (newPasswordCon.text.toString() !=
        reEnterpasswordCon.text.toString()) {
      return showToastMessage("Password not match.", context);
    } else {
      changePasswordApi();
    }
  }

  Widget resetBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Button(
          key: Key('Reset Password'),
          buttonName: "Reset Password",
          onPressed: () {
            onPresedSignUp();
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => Dashboard()));
          },
        ),
      ),
    );
  }

  changePasswordApi() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    var user = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print(user.name);
    }
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST', Uri.parse("${APIConstants.senpaiBaseUrl}user/changePassword"));
    request.bodyFields = {
      "user_id": user.user_id,
      "old_password": oldPasswordCon.text,
      "new_password": newPasswordCon.text,
      "security_code": user.security_code
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
      print(responseData);

      if (responseData['status'] == 1) {
        forgotchangePasswordDialogAlert(context);
      }else if (responseData['status'] == 6) {
          var baseDialogTwo = BaseAlertDialog(
            title: "Your account has been login by another device.",
            content: "Please logout account another device",
            yesOnPressed: () async {
              Preference().setLoginBool(Preference.IS_LOGIN, false);
              SharedPreferences userData =
                  await SharedPreferences.getInstance();
              await userData.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Login(),
                ),
                (route) => false,
              );
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
              builder: (BuildContext context) => baseDialogTwo);
         
        }
    } else {
      print(response.reasonPhrase);
    }
  }

  forgotchangePasswordDialogAlert(responseData) {
    var baseDialog = BaseAlertDialog(
      title: "Change Password",
      content: "Change Password Sucessfully",
      yesOnPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      },
      yes: "Ok",
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => baseDialog);
  }
}
