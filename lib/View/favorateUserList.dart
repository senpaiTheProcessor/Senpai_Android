import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorate extends StatefulWidget {
  const Favorate({Key? key}) : super(key: key);

  @override
  State<Favorate> createState() => _FavorateState();
}

class _FavorateState extends State<Favorate> {
  List getFavorateUsers = [];
  String is_favorite = "0";
  UserModel? userModel;

  int _page = 1;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  // bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;
  bool? _isLoading = false;

  ScrollController? _controller;
  @override
  void initState() {
    getUserModel();
    getFavorateUsers = [];
    favorateUserList();
    _controller = ScrollController()..addListener(_loadMore);

    is_favorite = "0";
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller!.removeListener(_loadMore);
    super.dispose();
  }

  void getUserModel() async {
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    userModel = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print("userName...${userModel!.user_id}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: blueCom,
          centerTitle: true,
          title: Text(
            "Favorate User ",
            style: btnWhite(context),
          ),
        ),
        body: Stack(
          children: [
            favList(),
            LoaderIndicator(_isLoading!),
          ],
        ));
  }

  Widget favList() {
    return getFavorateUsers.length == 0
        ? Center(child: Text("No Data Found!"))
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                controller: _controller,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: getFavorateUsers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                    child: InkWell(
                      onTap: (() {}),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: borderColor),
                            color: grayShade,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.14,
                                  width:
                                      MediaQuery.of(context).size.height * 0.14,
                                  decoration: BoxDecoration(
                                    color: white,
                                    border:
                                        Border.all(width: 1, color: grayShade),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: getFavorateUsers[index]
                                                      ['user_image']
                                                  .length >
                                              0
                                          ? NetworkImage(
                                              getFavorateUsers[index]
                                                  ['user_image'],
                                            )
                                          : AssetImage(
                                                  'assets/images/uprofile.png')
                                              as ImageProvider,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        // "Jhon Smith",
                                        getFavorateUsers[index]["name"],
                                        style: smollheader(context),
                                      ),
                                      // SizedBox(
                                      //   height: 2,
                                      // ),
                                      // RichText(
                                      //   text: TextSpan(
                                      //     text: 'Mobile number :- ',
                                      //     style: smollheader(context),
                                      //     children: <TextSpan>[
                                      //       TextSpan(
                                      //           text: getFavorateUsers[index]
                                      //               ['mobile_number'],
                                      //           style:
                                      //               smollheaderlight(context)),
                                      //     ],
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Rate amount :- ',
                                          style: smollheader(context),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: " \u20B9 " +
                                                    getFavorateUsers[index]
                                                        ['rate_amount'] +
                                                    "/min",
                                                style:
                                                    smollheaderlight(context)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'No calls :- ',
                                            style: smollheader(context),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: getFavorateUsers[index]
                                                      ['no_calls'],
                                                  style: smollheaderlight(
                                                      context)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Guided min :- ',
                                          style: smollheader(context),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: getFavorateUsers[index]
                                                              ['guided_min']
                                                          .length >
                                                      0
                                                  ? getFavorateUsers[index]
                                                          ['guided_min'] +
                                                      " /min"
                                                  : "N/A",

                                              // _sentRequestList[index]
                                              //     .created!,
                                              style: smollheaderlight(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                                IconButton(
                                    onPressed: () {
                                      favorateUser(index);
                                    },
                                    icon: Icon(
                                      ((is_favorite == "1")
                                          ? Icons.favorite_outline
                                          : Icons.favorite),
                                      color: ((is_favorite == "1")
                                          ? Colors.grey
                                          : Colors.red),
                                    ))
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

  favorateUser(int index) {
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/favoriteUser'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "other_user_id": getFavorateUsers[index]['user_id'],
      },
    ).then(
      (response) {
        print("only approch...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          if (is_favorite == "1") {
            is_favorite = "0";
          } else {
            is_favorite = "1";
          }
          setState(() {
            getFavorateUsers.removeAt(index);
          });
          //favorateUserList();
          return showToastMessage("UnFavorite User", context);
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
        } else {}
      },
    );
  }

  // favorateUserList() {
  //   http.post(
  //     Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/getFavoriteList'),
  //     body: {
  //       "user_id": userModel!.user_id,
  //       "security_code": userModel!.security_code,
  //       "page_no": "1",
  //       "limit": "50",
  //     },
  //   ).then(
  //     (response) {
  //       dynamic result1 = json.decode(response.body);
  //       getFavorateUsers = result1['fav_list'];
  //       print("getUserProfileData...${getFavorateUsers}");

  //       setState(() {});
  //       String mgs = result1['message'];
  //       if (result1['status'] == 1) {
  //       } else {}
  //     },
  //   );
  // }
  favorateUserList() async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/getFavoriteList'));
    request.fields.addAll({
      "user_id": userModel!.user_id,
      "security_code": userModel!.security_code,
      "page_no": "1",
      "limit": "10",
    });

    http.StreamedResponse response = await request.send();
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
      log("responseData...$responseData");
      if (responseData['status'] == 0) {
        print("Feild");
        if (mounted) {
          setState(() {
            getFavorateUsers = [];
          });
        }
      } else if (responseData['status'] == 1) {
        print("getFavorateUsers$getFavorateUsers");
        if (mounted) {
          setState(() {
            getFavorateUsers = responseData['fav_list'];
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
    print("datas...${getFavorateUsers.length}");

    setState(() {
      _isLoading = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isLoading == false &&
        _isLoadMoreRunning == false &&
        _controller!.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      // print("intrest_id..$intrest_id");
      Map<String, dynamic> jsondatais =
          jsonDecode(Preference().getString(Preference.USER_MODEL)!);
      var user = UserModel.fromJson(jsondatais);
      if (jsondatais.isNotEmpty) {
        // print("interestID...${user.interest[1]['interest_id']}");
      }
      var request = http.MultipartRequest('POST',
          Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/getFavoriteList'));
      request.fields.addAll({
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "page_no": _page.toString(),
        "limit": "10",
      });

      http.StreamedResponse response = await request.send();
      print("request...${request.fields}");
      if (response.statusCode == 200) {
        dynamic responseJson = await response.stream.bytesToString();
        dynamic responseData = json.decode(responseJson);

        print("load1..$responseData");
        if (responseData['status'] == 1) {
          List tempgetFavorateUsers = responseData['fav_list'];
          if (tempgetFavorateUsers.length > 0) {
            setState(() {
              getFavorateUsers.addAll(tempgetFavorateUsers);
            });
          }
          String is_more_data = responseData['is_more_data'];
          print("is_more_data...$is_more_data");
          if (is_more_data == 'no') {
            showSnackBar();
            setState(() {
              _hasNextPage = false;
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
      print("favData...${getFavorateUsers.length}");
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  //----for paginaton
  void showSnackBar() {
    final snackBar = SnackBar(
      content: Text('You have fetched all of the content'),
    );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
