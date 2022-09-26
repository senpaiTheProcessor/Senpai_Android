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
import 'package:senpai/model/Language.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SelectLaguage extends StatefulWidget {
  final List<String> languageIds;
  const SelectLaguage({Key? key, required this.languageIds}) : super(key: key);

  @override
  _SelectLaguageState createState() => _SelectLaguageState();
}

class _SelectLaguageState extends State<SelectLaguage>
    with SingleTickerProviderStateMixin {
  List<LanguageModel> _language = [];

  List vLIds = [];
  List vULIds = [];
  List<dynamic> LanguageData = [];
  var h, w;
  late UserModel userModel;
  String user_id = "0", security_code = "";
  bool? _isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserModel();
    getLanguageByUserID();
  }

  void getUserModel() async {
    if (Preference().getLoginBool(Preference.IS_LOGIN) == true) {
      Map<String, dynamic> jsondatais =
          jsonDecode(Preference().getString(Preference.USER_MODEL)!);
      userModel = UserModel.fromJson(jsondatais);
      user_id = userModel.user_id;
      security_code = userModel.security_code;
    } else {
      user_id = "0";
      security_code = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.clear),
          color: black,
        ),
      ),
      body: Stack(
        children: [
          _tagIcon(),
          LoaderIndicator(_isLoading!),
          Align(
            alignment: Alignment.bottomCenter,
            child: loginBtn(),
          ),
        ],
      ),
    );
  }

  Widget _tagIcon() {
    return Column(
      children: [
        _tagsWidget(),
      ],
    );
  }

  _displayTagWidget() {
    return _buildSuggestionWidget();
  }

  Widget _buildSuggestionWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(
          children: _language
              .map((languageModel) => tagChip(
                    languageModel: languageModel,
                    onTap: () {
                      if (languageModel.is_selected == "0") {
                        setState(() {
                          languageModel.is_selected = "1";
                        });
                      } else {
                        setState(() {
                          languageModel.is_selected = "0";
                        });
                      }
                    },
                    action: 'Add',
                    //
                  ))
              .toList(),
        ),
      ]),
    );
  }

  Widget tagChip({
    languageModel,
    onTap,
    action,
  }) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 5.0,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: (languageModel.is_selected == "1") ? Colors.green : white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                  color: (languageModel.is_selected == "0") ? black : white),
            ),
            child: Wrap(
              children: [
                Text(
                  '${languageModel.language_name}',
                  style: TextStyle(
                    color: (languageModel.is_selected == "0") ? black : white,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.add,
                  color: (languageModel.is_selected == "0") ? black : white,
                )
              ],
            ),
          ),
        ));
  }

  Widget _tagsWidget() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Select Laguages to showcase your expertise',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            _displayTagWidget(),
          ],
        ),
      ),
    );
  }

  Widget loginBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Button(
          key: Key('Save_button'),
          buttonName: "Save",
          onPressed: () {
            if (Preference().getLoginBool(Preference.IS_LOGIN) == true) {
              addLanguageByUserID();
            } else {
              Navigator.pop(
                context,
                _language,
              );
            }
          },
        ),
      ),
    );
  }

  void getLanguageByUserID() async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getLanguage');
    var response = await http.post(url, body: {"user_id": user_id});
    dynamic res = json.decode(response.body.toString());
    LanguageData = res['language'];
    _language = (res['language'] as List)
        .map((itemWord) => LanguageModel.fromJson(itemWord))
        .toList();
    for (var i = 0; i < _language.length; i++) {
      if (widget.languageIds.contains(_language[i].language_id)) {
        _language[i].is_selected = "1";
      }
    }
    print("language_data...${response.body}");
    print("language_data...${_language}");
    setState(() {
      _isLoading = false;
    });
  }

  void addLanguageByUserID() async {
    for (var element in _language) {
      if (element.is_selected == "1") {
        vLIds.add(element.language_id);
      }
      vULIds.add(element.language_id);
    }
    print("language_del_lads_id...${vULIds.join(",")}");
    print("language_lads_id...${vLIds.join(",")}");
    setState(() {
      _isLoading = true;
    });

    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/addUserLanguage'),
      body: {
        "user_id": user_id,
        "security_code": security_code,
        "is_delete": "1",
        "del_language": vULIds.join(","),
        "language_id": vLIds.join(",")
      },
    ).then(
      (response) {
        print("language_del_lads_id...${vULIds.join(",")}");
        print("language_lads_id...${vLIds.join(",")}");

        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });

          print("language_del_lads_id...${vULIds.join(",")}");
          print("language_lads_id...${vLIds.join(",")}");
          Navigator.pop(
            context,
            _language,
          );
        } else if (result1['status'] == 6) {
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
        }else {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }
}
