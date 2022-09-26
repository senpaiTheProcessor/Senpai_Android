// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:senpai/Common/Button.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:senpai/newEditProfile/newInputFiled.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class summaryPage extends StatefulWidget {
  final dynamic bioKey;
  const summaryPage({Key? key, this.bioKey}) : super(key: key);

  @override
  State<summaryPage> createState() => _summaryPageState();
}

class _summaryPageState extends State<summaryPage> {
  String _enteredText = '';
  bool? _isLoading = false;
  String discription = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.bioKey;
    print("bio...${widget.bioKey}");
    bioCon.text = widget.bioKey;
  }

  TextEditingController bioCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: InkWell(
          onTap: (() {
            Navigator.pop(context);
          }),
          child: Icon(
            Icons.clear,
            color: black,
            size: 35,
          ),
        ),
      ),
      body: Stack(children: [
        allFiled(),
        LoaderIndicator(_isLoading!),
        Align(alignment: Alignment.bottomCenter, child: saveBtn())
      ]),
    );
  }

  Widget allFiled() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100, left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [addExperience(), input()],
        ),
      ),
    );
  }

  Widget input() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Column(
        children: [
          const Text(
            "You Can Write about your years of experience ,industry ,or skills.People also talk about their achievements of previous job experiences.",
            style: TextStyle(
              color: black,
              fontFamily: "PoppinsMedium",

              fontSize: 14,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.2,
              // fontFamily: "helvetica-light-587ebe5a59211",
            ),
          ),
          TextFormField(
            onChanged: (value) {
              setState(() {
                _enteredText = value;
              });
            },
            controller: bioCon,
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontFamily: "PoppinsMedium",
                    // fontFamily: sourceSansPro,
                    fontWeight: FontWeight.w500),
                hintMaxLines: 5,
                counterText: '${_enteredText.length.toString()} / 3500'),
          ),
        ],
      ),
    );
  }

  Widget addExperience() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's add your summary",
            style: headerexplore(context),
          ),
          Text(
            "*indicates required",
            style: smollheaderlight(context),
          ),
        ],
      ),
    );
  }

  onPresedLogin() {
    if (bioCon.text.toString().trim().isEmpty) {
      return showToastMessage("Add your Summary", context);
    }
    //  else if (bioCon.text.length < 50 || bioCon.text.length > 10) {
    //   return showToastMessage("Add bio atleast 50 chatechers", context);

    // }
    else {
      _addSummaryApi();
      // Navigator.pop(context, bioCon.text.toString());
    }
  }

  Widget saveBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Button(
          key: Key('save_button'),
          buttonName: "Save",
          onPressed: () {
            onPresedLogin();
          },
        ),
      ),
    );
  }

  _addSummaryApi() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    var user = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print(user.name);
    }
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/addUserSummary'),
      body: {
        "user_id": user.user_id,
        "security_code": user.security_code,
        "summary": bioCon.text
      },
    ).then(
      (response) {
        print("bioSummary...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context, bioCon.text.toString());

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(mgs),
            ),
          );
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Dashboard()));
        }else if (result1['status'] == 6) {
          var baseDialog1 = BaseAlertDialog(
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
              builder: (BuildContext context) => baseDialog1);
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
}
