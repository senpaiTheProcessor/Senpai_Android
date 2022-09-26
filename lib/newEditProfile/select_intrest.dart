// ignore_for_file: prefer_final_fields, unnecessary_new, prefer_const_constructors, sized_box_for_whitespace, prefer_is_empty, unused_element, curly_braces_in_flow_control_structures, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print, unused_local_variable

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
import 'package:senpai/model/intrestModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SelectIntrest extends StatefulWidget {
  final List<String> interstIds;
  const SelectIntrest({Key? key, required this.interstIds}) : super(key: key);

  @override
  _SelectIntrestState createState() => _SelectIntrestState();
}

class _SelectIntrestState extends State<SelectIntrest>
    with SingleTickerProviderStateMixin {
  var h, w;
  List vLIds = [];
  List vULIds = [];
  List<IntrestModel> _intrest = [];
  var IntrestData;
  bool? _isLoading = false;
  UserModel? userModel;
  String user_id = "0", security_code = "";
  @override
  void initState() {
    super.initState();
    getUserModel();
    getintestByUserID();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUserModel() async {
    if (Preference().getLoginBool(Preference.IS_LOGIN) == true) {
      Map<String, dynamic> jsondatais =
          jsonDecode(Preference().getString(Preference.USER_MODEL)!);
      userModel = UserModel.fromJson(jsondatais);
      user_id = userModel!.user_id;
      security_code = userModel!.security_code;
      //print("interstedModel...${userModel.interest}");
    } else {
      user_id = "0";
      security_code = "";
    }
  }

  FocusNode? myFocusNode;

  final FocusNode searchFocus = FocusNode();
  TextEditingController searchCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        title: Container(
          height: 36,
          child: TextFormField(
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              print("value$value");

              getintestByUserID();
            },
            controller: searchCon,
            autofocus: false,
            focusNode: searchFocus,
            onEditingComplete: () => {FocusScope.of(context).unfocus()},
            style: TextStyle(
                color: black,
                fontSize: 14,
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: 'Search Interest',
              hintStyle: TextStyle(
                  color: black,
                  fontSize: 12,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w600),
              suffixIcon: Icon(
                Icons.search,
                color: black,
              ),
              contentPadding: const EdgeInsets.only(left: 8, top: 20),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(color: blueCom, width: 0.9),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(color: blueCom, width: 0.5),
              ),
            ),
          ),
        ),
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
          // alignment: WrapAlignment.start,
          children: _intrest
              // .where((tagModel) => !_tags.contains(tagModel))
              .map((intrestModel) => tagChip(
                    intrestModel: intrestModel,
                    onTap: () {
                      if (intrestModel.is_selected == "0") {
                        setState(() {
                          intrestModel.is_selected = "1";
                        });
                      } else {
                        setState(() {
                          intrestModel.is_selected = "0";
                        });
                      }
                    },
                    action: 'Add',
                  ))
              .toList(),
        ),
      ]),
    );
  }

  Widget tagChip({
    intrestModel,
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
              color: (intrestModel.is_selected == "1") ? Colors.green : white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                  color: (intrestModel.is_selected == "0") ? black : white),
            ),
            child: Wrap(
              children: [
                Text(
                  '${intrestModel.interest_name}',
                  style: TextStyle(
                    color: (intrestModel.is_selected == "0") ? black : white,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.add,
                  color: (intrestModel.is_selected == "0") ? black : white,
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
                'Select interest to showcase your expertise',
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
              addInterestByUserID();
            } else {
              Navigator.pop(
                context,
                _intrest,
              );

              print("resi..$_intrest");
            }
          },
        ),
      ),
    );
  }

  //  ------------get language------------------
  void getintestByUserID() async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getInterest');
    var response = await http
        .post(url, body: {"user_id": user_id, "search_text": searchCon.text});
    dynamic res = json.decode(response.body.toString());
    IntrestData = res['interest'];
    _intrest = (res['interest'] as List)
        .map((itemWord) => IntrestModel.fromJson(itemWord))
        .toList();
    for (var i = 0; i < _intrest.length; i++) {
      if (widget.interstIds.contains(_intrest[i].interest_id)) {
        _intrest[i].is_selected = "1";
      }
    }
    print("IntrestData...${response.body}");
    setState(() {
      _isLoading = false;
    });
  }

  addInterestByUserID() async {
    for (var element in _intrest) {
      if (element.is_selected == "1") {
        vLIds.add(element.interest_id);
      }
      vULIds.add(element.interest_id);
    }
    setState(() {
      _isLoading = true;
    });

    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/addInterest'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "is_delete": "1",
        "del_interest_id": vULIds.join(","),
        "interest_id": vLIds.join(","),
      },
    ).then(
      (response) {
        print("add interest...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });

          Navigator.pop(context, _intrest);
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
        }
      },
    );
  }
}
