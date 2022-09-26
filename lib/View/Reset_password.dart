import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:senpai/Common/Button.dart';
import 'package:senpai/Common/InputField.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/DashBord.dart';
import 'package:senpai/View/Forgot_password.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/View/Verification.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  FocusNode? myFocusNode;
  TextEditingController newPasswordCon = TextEditingController();
  TextEditingController reEnterpasswordCon = TextEditingController();
  final FocusNode newPasswordFocus = FocusNode();
  final FocusNode reEnterpasswordFocus = FocusNode();
  // Initially password is obscure
  bool _obscureTextnew = true;
  bool? _isLoading = false;

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
            "Reset Password",
            style: btnWhite(context),
          ),
        ),
        body: Stack(
          children: [allFiled(), LoaderIndicator(_isLoading!)],
        ));
  }

  Widget allFiled() {
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
          Text("Reset Password", style: header(context)),
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
          child: Column(
              children: [enterNewPassword(), reEnterPassword(), resetBtn()]),
        ),
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
        hintText: 'Enter a new password  *',
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
              _obscureTextnew ? Icons.visibility : Icons.visibility_off,
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
        hintText: 'Re - enter new password  *',
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
              _obscureText ? Icons.visibility : Icons.visibility_off,
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
    if (newPasswordCon.text.toString().isEmpty) {
      return showToastMessage("Enter new password", context);
    } else if (newPasswordCon.text.toString().length < 6) {
      return showToastMessage("Password at least 6 characters", context);
    } else if (reEnterpasswordCon.text.toString().isEmpty) {
      return showToastMessage("Enter confirm password", context);
    } else if (newPasswordCon.text.toString() !=
        reEnterpasswordCon.text.toString()) {
      return showToastMessage("Password not match.", context);
    } else {
      forgotchangePasswordApi();
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

  forgotchangePasswordApi() async {
    setState(() {
      _isLoading = true;
    });
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST', Uri.parse("${APIConstants.senpaiBaseUrl}user/forgotPassword"));
    request.bodyFields = {
      'mobile_number': Preference().getString(Preference.MOBILE)!,
      'password': newPasswordCon.text.trim().toString()
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
      } else if (responseData['status'] == 0) {}
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
