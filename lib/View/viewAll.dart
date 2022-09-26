// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/ExplorDetail.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewALLPage extends StatefulWidget {
  final dynamic inerestKey;
  final dynamic inerestName;
  final bool isRecommendeKey;
  const ViewALLPage(
      {Key? key,
      this.inerestKey,
      this.inerestName,
      required this.isRecommendeKey})
      : super(key: key);

  @override
  State<ViewALLPage> createState() => _ViewALLPageState();
}

class _ViewALLPageState extends State<ViewALLPage> {
  void main() {
    print(capitalize("this is a string"));
    // displays "This is a string"
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  List getUserData = [];
  String userData = "0";
  bool? _isLoading = false;

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
    super.initState();
    main();
    if (widget.isRecommendeKey == true) {
      getRecommendUserList();
    } else {
      getAllUserList();
      _controller = ScrollController()..addListener(_loadMore);
    }

    print(
        "object...${widget.inerestKey}+${widget.inerestName}+${widget.isRecommendeKey}");
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller!.removeListener(_loadMore);
  // }

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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: blueCom,
          centerTitle: true,
          title: Text(
            widget.inerestName,
            style: btnWhite(context),
          ),
        ),
        body: Stack(
          children: [
            categoriesView(),
            LoaderIndicator(_isLoading!),
          ],
        ));
  }

//----------05 July Moksh-------//
  Widget categoriesView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          height: MediaQuery.of(context).size.height,
          // color: Colors.yellow,
          child: GridView.builder(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            itemCount: getUserData.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 8.0,
                mainAxisExtent: MediaQuery.of(context).size.height * .25),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
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
                        ),
                      ),
                    );
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                        color: grayShade,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          width: MediaQuery.of(context).size.height * 0.14,
                          decoration: BoxDecoration(
                            color: white,
                            border: Border.all(width: 1, color: grayShade),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image:
                                  (getUserData[index]['user_image'].length > 0)
                                      ? NetworkImage(
                                          getUserData[index]['user_image'],
                                        )
                                      : AssetImage('assets/images/uprofile.png')
                                          as ImageProvider,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          capitalize(getUserData[index]['name'].length == 0
                              ? "N/A"
                              : getUserData[index]['name']),
                          textAlign: TextAlign.center,
                          style: smollheader(context),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "\u20B9"
                          " "
                          "${getUserData[index]['rate_amount'].length == 0 ? "00.0" : getUserData[index]['rate_amount']+"/min"}",
                          style: smollheader(context),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 1),
                          child: Container(
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(
                                width: 1,
                                color: Color(0xff646363),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    getAvgRating(getUserData[index]
                                            ['avg_rating']!
                                        .toString()),
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
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  getAllUserList() async {
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
        'POST', Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getAllUser'));
    request.fields.addAll({
      "user_id": user.user_id,
      "security_code": user.security_code,
      "interest_id": widget.inerestKey,
      "rates": "0",
      "calls": "0",
      "rating": "0",
      "page_no": "1",
      "limit": '15',
    });

    http.StreamedResponse response = await request.send();
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
      print("getUserData...$responseData");
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
    print("datas...${getUserData.length}");

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
      var request = http.MultipartRequest(
          'POST', Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getAllUser'));
      request.fields.addAll({
        "user_id": user.user_id,
        "security_code": user.security_code,
        "interest_id": widget.inerestKey,
        "rates": "0",
        "calls": "0",
        "rating": "0",
        "page_no": _page.toString(),
        "limit": '15',
      });

      http.StreamedResponse response = await request.send();
      print("request...${request.fields}");
      if (response.statusCode == 200) {
        dynamic responseJson = await response.stream.bytesToString();
        dynamic responseData = json.decode(responseJson);

        print("load1..$responseData");
        if (responseData['status'] == 1) {
          List tempgetExpolreData = responseData['user_list'];
          if (tempgetExpolreData.length > 0) {
            setState(() {
              getUserData.addAll(tempgetExpolreData);
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
      print("datas...${getUserData.length}");
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

  getRecommendUserList() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    var user = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      // print("interestID...${user.interest[1]['interest_id']}");
    }
    var request = http.MultipartRequest('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getRecommendedList'));
    request.fields.addAll({
      "user_id": user.user_id,
      "security_code": user.security_code,
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
            getUserData = responseData['recommended'];
            print("recommenddata$getUserData");
            print("recommenddata${getUserData[0]['user_id']}");
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
}
