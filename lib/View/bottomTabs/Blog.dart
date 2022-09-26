// ignore_for_file: prefer_const_constructors, file_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/ExplorDetail.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/View/Notification.dart';
import 'package:senpai/View/drawer.dart';
import 'package:senpai/View/wallet/Wallet.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogRes extends StatefulWidget {
  const BlogRes({Key? key}) : super(key: key);

  @override
  State<BlogRes> createState() => _BlogResState();
}

class _BlogResState extends State<BlogRes> {
  bool? _isLoading = false;
  UserModel? userModel;
  String currentWallectBalance = "00";
  String notification_see = '';
  String blog_see = '';
  String request_see = '';
  String rate_amount = "";

  List _blogData = [];
  List _blogUserData = [];
  FocusNode? myFocusNode;

  final FocusNode searchFocus = FocusNode();
  TextEditingController searchCon = TextEditingController();

  int _page = 1;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  // bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;
  ScrollController? _controller;
  @override
  void initState() {
    // TODO: implement initState
    getUserModel();
    _getUserProfileApi();
    main();
    blogData();
    _blogData = [];
    _getUserProfileApi();
    _controller = ScrollController()..addListener(_loadMore);

    super.initState();
  }

  void main() {
    print(capitalize("this is a string"));
    // displays "This is a string"
  }

  String getAvgRating(String avgRating) {
    if (!avgRating.isEmpty) {
      return double.parse(avgRating).toStringAsFixed(1);
    } else {
      return "0.0";
    }
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
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

  void _walletNavigatore(BuildContext context) async {
    List<String> languageIds = [];
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Wallet()));
    if (result != null) {
      print("walletresult...$result");
      setState(() {
        currentWallectBalance = result.toString();
      });
    }
  }

  DateTime pre_backpress = DateTime.now();

  //------see blogs api
  seeBadgeAll() async {
    var request = http.MultipartRequest('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/updateBadge'));
    request.fields
        .addAll({'user_id': userModel!.user_id, 'badge_type': 'new_blog'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
      print("see new_blog.....$responseData");
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
          drawer: DrawerPage(),
          appBar: AppBar(
            backgroundColor: white,
            leading: Builder(builder: (BuildContext context) {
              return InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();

                    Scaffold.of(context).openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Image.asset(
                      "assets/logo/menu.png",
                      width: 10,
                      height: 10,
                    ),
                  ));
            }),
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    child: TextFormField(
                      onChanged: (value) {
                        print("value$value");
                        _page = 1;
                        _hasNextPage = true;
                        _isLoadMoreRunning = false;
                        _blogData = [];
                        blogData();
                      },
                      controller: searchCon,
                      autofocus: false,
                      focusNode: searchFocus,
                      onEditingComplete: () =>
                          {FocusScope.of(context).unfocus()},
                      style: TextStyle(
                          color: black,
                          fontSize: 14,
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: 'Search', //Lets Kill The Query',
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
                ),
                InkWell(
                  onTap: (() {
                    FocusScope.of(context).unfocus();
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Wallet()));
                    _walletNavigatore(context);
                  }),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          "assets/logo/wallet.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                      Text(
                        "\u20B9" +
                            (currentWallectBalance.isEmpty
                                ? "00"
                                : currentWallectBalance),
                        style: TextStyle(
                            color: blueCom,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 1, vertical: 15),
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationList()));
                    },
                    child: Badge(
                      elevation: 0,
                      badgeColor:
                          notification_see == "1" ? Colors.red : Colors.white,
                      child: Image.asset(
                        "assets/logo/bell.png",
                        //width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: Stack(
            children: [
              blogList(),
              LoaderIndicator(_isLoading!),
            ],
          )),
    );
  }

  Widget blogList() {
    return _blogData.length == 0
        ? Center(child: Text("No Record Found!"))
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
                controller: _controller,
                itemCount: _blogData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: grayShade,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: MediaQuery.of(context).size.height / 8,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: blueCom,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                      bottomLeft: Radius.circular(0.0),
                                      bottomRight: Radius.circular(0.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    "",
                                    textAlign: TextAlign.center,
                                    style: bottomheader(context),
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                             Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: Text(
                                _blogData[index]['blog_title'],
                          style: bottomheader(context).copyWith(fontSize: 20),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                launch(_blogData[index]['blog_url']);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Text(
                                  _blogData[index]['blog_url'],
                                  style: blueheader(context),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Text(
                                _blogData[index]['blog_content'],
                                style: verysmollheader2(context),
                              ),
                            ),
                            Divider(),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 10, vertical: 8),
                            //   child: Text(
                            //     "Where can I get some?",
                            //     style: bottomheader(context),
                            //   ),
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: [
                            //     Container(
                            //       color: borderColor,
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: Image.asset(
                            //           "assets/logo/logo_senpai.png",
                            //           width: 20,
                            //           height: 20,
                            //         ),
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width:
                            //           MediaQuery.of(context).size.width / 1.5,
                            //       child: Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Text(
                            //             "Lorem spaum comntact",
                            //             style: smollheader(context),
                            //           ),
                            //           Text(
                            //             "It is a long established fact that a reader readable content of a page when looking ",
                            //             style: verysmollheader2(context),
                            //           ),
                            //         ],
                            //       ),
                            //     )
                            //   ],
                            // ),
                            SizedBox(
                              height: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Recommended",
                                      style: bottomheader(context),
                                    ),
                                    Container(
                                      color: grayShade,
                                      //   padding: EdgeInsets.symmetric(horizontal: 4),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      alignment: Alignment.centerLeft,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _blogUserData.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: (() {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ExploreDetail(
                                                            profliekey: false,
                                                            detailKey:
                                                                _blogUserData[
                                                                        index]
                                                                    ['user_id'],
                                                            ReviewKey: false,
                                                            favirateKey: true,
                                                            reportkey: true,
                                                          )));
                                            }),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 2),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          offset:
                                                              Offset(0.0, 2.0),
                                                          blurRadius: 5.0,
                                                          color: Colors.grey)
                                                    ]),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.14,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.14,
                                                      decoration: BoxDecoration(
                                                        color: white,
                                                        border: Border.all(
                                                            width: 1,
                                                            color: grayShade),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: (_blogUserData[
                                                                              index]
                                                                          [
                                                                          'user_image']
                                                                      .length >
                                                                  0)
                                                              ? NetworkImage(
                                                                  _blogUserData[
                                                                          index]
                                                                      [
                                                                      'user_image'],
                                                                )
                                                              : AssetImage(
                                                                      'assets/images/uprofile.png')
                                                                  as ImageProvider,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      capitalize(
                                                          _blogUserData[index]
                                                              ['name']),
                                                      style:
                                                          smollheader(context),
                                                    ),
                                                    Text(
                                                      "\u20B9" +
                                                          _blogUserData[index]
                                                              ['rate_amount'] +
                                                          "/min",
                                                      style:
                                                          smollheader(context),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: white,
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Color(
                                                                  0xff646363)),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8,
                                                                vertical: 1),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              getAvgRating(_blogUserData[index]
                                                                              [
                                                                              'avg_rating']
                                                                          .length ==
                                                                      0
                                                                  ? "0"
                                                                  : _blogUserData[
                                                                          index]
                                                                      [
                                                                      'avg_rating']),
                                                              style:
                                                                  verysmollheader(
                                                                      context),
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                              size: 15,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ]),
                            )
                            // recommendedView(_blogData[index]['blog_user'])
                          ]),
                    ),
                  );
                }),
          );
  }

  blogData() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    var user = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      // print("interestID...${user.interest[1]['interest_id']}");
    }
    var request = http.MultipartRequest(
        'POST', Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getBlogList'));
    request.fields.addAll({
      "user_id": userModel!.user_id,
      "security_code": userModel!.security_code,
      "search_text": searchCon.text,
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
            _blogUserData = [];
          });
        }
      } else if (responseData['status'] == 1) {
        print("getUserData....$_blogUserData");
        if (mounted) {
          setState(() {
            _blogData = responseData['blogs'];
            _blogUserData = _blogData[0]['blog_user'];
            // _blogUserData =_blogData['blog_user'];
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
    print("datas...${_blogUserData.length}");

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
          Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getBlogList'));
      request.fields.addAll({
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "search_text": searchCon.text,
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
          List tempblogData = responseData['blogs'];
          if (tempblogData.length > 0) {
            setState(() {
              _blogData.addAll(tempblogData);
            });

            _blogData = responseData['blogs'];
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
      print("datas...${_blogData.length}");
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

  _getUserProfileApi() async {
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/getUserProfile'),
      body: {
        "user_id": userModel!.user_id,
        "session_user_id": ""
      },
    ).then(
      (response) {
        dynamic responce = json.decode(response.body);
        currentWallectBalance = responce['user_detail']['user_wallet_balance'];
        rate_amount = responce['user_detail']['rate_amount'];
        notification_see = responce['user_detail']['new_notification'];
        blog_see = responce['user_detail']['new_blog'];
        request_see = responce['user_detail']['new_request'];

        Preference().setString(Preference.NEW_BLOG, blog_see);
        Preference().setString(Preference.NEW_REQUEST, request_see);
        print("currentWallectBalance...$currentWallectBalance");
        Preference().setString(Preference.NEW_NOTIFICATION, notification_see);
        Preference()
            .setString(Preference.CURRENT_BALANCE, currentWallectBalance);

        Preference().setString(Preference.RATE_AMMOUNT, rate_amount);

        setState(() {});
      },
    );
  }
}
