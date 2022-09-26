// ignore_for_file: constant_identifier_names, prefer_final_fields, unnecessary_new, file_names, prefer_const_constructors, unrelated_type_equality_checks, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, avoid_print, prefer_typing_uninitialized_variables, non_constant_identifier_names, prefer_adjacent_string_concatenation

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Common/smallButton.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/ExplorDetail.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/View/Notification.dart';
import 'package:senpai/View/drawer.dart';
import 'package:senpai/View/wallet/Wallet.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:senpai/model/intrestModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  final search;
  const SearchPage({Key? key, this.search}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

enum Filter { Rates, Calls, Rating }

class _SearchPageState extends State<SearchPage> {
  ValueNotifier<Filter> _selectedItem = new ValueNotifier<Filter>(Filter.Rates);

  List getUserData = [];
  String currentWallectBalance = "00";
  UserModel? userModel;
  String user_id = "0";

  List<IntrestModel> _intrest = [];
  var IntrestData;
  IntrestModel? intrestDropdownvalue;
  bool? _isLoading = false;
  String filtter = "0";
  FocusNode? myFocusNode;
  final FocusNode searchFocus = FocusNode();
  //TextEditingController searchCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    intrestDropdownvalue = IntrestModel(
      interest_id: "",
      interest_name: "Select Interest",
      is_selected: "0",
    );
    getUserModel();

    getAllUserList("");
    // _getUserProfileApi();
  }

  String getAvgRating(String avgRating) {
    if (!avgRating.isEmpty) {
      return double.parse(avgRating).toStringAsFixed(1);
    } else {
      return "0.0";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: blueCom,
          centerTitle: true,
          title: Text(
            "Search",
            style: btnWhite(context),
          ),
          leading: InkWell(
              onTap: (() {
                Navigator.pop(context, currentWallectBalance);
              }),
              child: Icon(Icons.arrow_back)),
        ),
        body: Stack(
          children: [
            allFiled(),
            LoaderIndicator(_isLoading!),
          ],
        ));
  }

  Widget allFiled() {
    return exploreList();
  }

  Widget exploreList() {
    return getUserData.length == 0
        ? Center(child: Text("No data"))
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: getUserData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: InkWell(
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExploreDetail(
                                      detailKey: getUserData[index]['user_id'],
                                      ReviewKey: false,
                                      profliekey: false,
                                      favirateKey: true,
                                      reportkey: true,
                                    )));
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: borderColor),
                            color: grayShade,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.16,
                              width: MediaQuery.of(context).size.height * 0.14,
                              decoration: BoxDecoration(
                                color: white,
                                border: Border.all(width: 1, color: grayShade),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: (getUserData[index]['user_image']
                                              .length >
                                          0)
                                      ? NetworkImage(
                                          getUserData[index]['user_image'],
                                        )
                                      : AssetImage('assets/images/uprofile.png')
                                          as ImageProvider,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getUserData[index]['name'].length == 0
                                      ? "N/A"
                                      : getUserData[index]['name'],
                                  style: smollheader(context),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "\u20B9"
                                  " "
                                  "${getUserData[index]['rate_amount'].length == 0 ? "0" : getUserData[index]['rate_amount']}",
                                  style: smollheader(context),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Container(
                                  // width: MediaQuery.of(context).size.width*0.05,
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'No of Call :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                "${getUserData[index]['no_calls'].length == 0 ? "0" : getUserData[index]['no_calls']}",
                                            // " min",
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Container(
                                  // width: MediaQuery.of(context).size.width*0.4,
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'No of Guided :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                "${getUserData[index]['guided_min'].length == 0 ? "0" : getUserData[index]['guided_min']}" +
                                                    " min",
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.028,
                                  decoration: BoxDecoration(
                                      color: white,
                                      border: Border.all(
                                          width: 1, color: Color(0xff646363)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 1),
                                    child: Row(
                                      children: [
                                        Text(
                                          getAvgRating(getUserData[index]
                                                          ['avg_rating']
                                                      .length ==
                                                  0
                                              ? "0"
                                              : getUserData[index]
                                                  ['avg_rating']),
                                          style: verysmollheader(context),
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                viewDetailBtn(index),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
  }

  Widget viewDetailBtn(index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.04,
        child: smallButton(
          key: Key('detail_button'),
          buttonName: "View Detail",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ExploreDetail(
                          detailKey: getUserData[index]['user_id'],
                          ReviewKey: false,
                          profliekey: false,
                          favirateKey: true,
                          reportkey: true,
                        )));
          },
        ),
      ),
    );
  }

  Widget fillterDropDown() {
    return PopupMenuButton<Filter>(
      child: Center(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                  color: grayShade,
                  border: Border.all(width: 1, color: black),
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Filter"),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                    )
                  ],
                ),
              ))),
      itemBuilder: (BuildContext context) {
        return List<PopupMenuEntry<Filter>>.generate(
          Filter.values.length,
          (int index) {
            return PopupMenuItem(
              // height: 40,
              value: Filter.values[index],
              child: AnimatedBuilder(
                  child: Text(Filter.values[index]
                      .name), //Text(Fruit.values[index].toString()),
                  animation: _selectedItem,
                  builder: (BuildContext context, Widget? child) {
                    return RadioListTile<Filter>(
                        value: Filter.values[index],
                        title: child,
                        groupValue: _selectedItem.value,
                        onChanged: (Filter? value) {
                          _selectedItem.value = value!;
                          if (value.name == 'Rates') {
                            filtter == "1";
                          } else if (value.name == 'Calls') {
                            filtter == "2";
                          } else if (value.name == 'Rating') {
                            filtter == "3";
                          }

                          print("_selectedItem..${value.name}");
                          Navigator.pop(context);

                          getAllUserList("");
                        });
                  }),
            );
          },
        );
      },
    );
  }

  Widget categoryDropdown() {
    return Center(
      child: Container(
        // width: MediaQuery.of(context).size.width*0.05,
        width: MediaQuery.of(context).size.width * .4,
        height: MediaQuery.of(context).size.height * .04,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: white,
            border: Border.all(width: 1, color: black),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<IntrestModel>(
              // Initial Value
              value: intrestDropdownvalue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: _intrest
                  .map<DropdownMenuItem<IntrestModel>>((IntrestModel items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(
                    items.interest_name!,
                    style: subheader(context),
                  ),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (IntrestModel? newValue) {
                setState(() {
                  intrestDropdownvalue = newValue!;
                  print("intrestId...${intrestDropdownvalue?.interest_id}");
                  getAllUserList(intrestDropdownvalue!.interest_id.toString());
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  //----------get IntrestApi
  void getintestByUserID() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    var user = UserModel.fromJson(jsondatais);
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getInterest');
    var response = await http.post(url, body: {"user_id": user.user_id});
    dynamic res = json.decode(response.body.toString());
    print("res..$res");
    IntrestData = res['interest'];
    _intrest = (res['interest'] as List)
        .map((itemWord) => IntrestModel.fromJson(itemWord))
        .toList();
    setState(() {
      intrestDropdownvalue = _intrest[0];
    });
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    print("IntrestData2...${_intrest.toString()}");
  }

  getAllUserList(String intrest_id) async {
    setState(() {
      _isLoading = true;
    });
    print("intrest_id..$intrest_id");
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    var user = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      // print("interestID...${user.interest[1]['interest_id']}");
    }
    var request = http.MultipartRequest(
        'POST', Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getAllUser'));
    request.fields.addAll({
      "user_id": user.user_id,
      "security_code": user.security_code,
      "search_text": widget.search,
      "interest_id": "0",
      "rates": "0",
      "calls": "0",
      "rating": "0",
      "page_no": "1",
      "limit": '10',
    });

    http.StreamedResponse response = await request.send();
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
      print("commentList...$responseData");
      if (responseData['status'] == 0) {
        print("Feild");
        if (mounted) {
          setState(() {
            getUserData = [];
          });
        }
      } else if (responseData['status'] == 1) {
        print("getUserData$getUserData");
        if (mounted) {
          setState(() {
            getUserData = responseData['user_list'];
            print("getUserData$getUserData");
            print("getUserData..${getUserData[0]['user_id']}");
            print("getUserData..${getUserData[0]['user_image']}");
          });
        }
      }else if (responseData['status'] == 6) {
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
        } 
    } else {
      print(response.reasonPhrase);
    }
    print("datas...${getUserData.length}");
  }

  void getUserModel() async {
    if (Preference().getLoginBool(Preference.IS_LOGIN)!) {
      Map<String, dynamic> jsondatais =
          jsonDecode(Preference().getString(Preference.USER_MODEL)!);
      userModel = UserModel.fromJson(jsondatais);
      user_id = userModel!.user_id;                 
    } else {
      user_id = "0";
    }
  }

  _getUserProfileApi() async {
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/getUserProfile'),
      body: {"user_id": userModel!.user_id, "session_user_id": ""},
    ).then(
      (response) {
        dynamic responce = json.decode(response.body);
        currentWallectBalance = responce['user_detail']['user_wallet_balance'];
        Preference()
            .setString(Preference.CURRENT_BALANCE, currentWallectBalance);
        setState(() {});
      },
    );
  }
}
