// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  UserModel? userModel;
  List notificationListData = [];
  bool? _isLoading = false;
  int _page = 1;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  ScrollController? _controller;
  @override
  void initState() {
    getUserModel();
    seeBadgeAll();
    getNotificationListApi();
    _controller = ScrollController()..addListener(loadMore);
    // TODO: implement initState
    super.initState();
  }

  String converDateTime(String dateStr) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat dateFormat1 = DateFormat('dd MMM,hh:mm a');
    DateTime dateTime = dateFormat.parse(dateStr);
    return dateFormat1.format(dateTime);
  }

  void getUserModel() async {
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    userModel = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print("userName...${userModel!.user_id}");
    }
  }
  //------see all notification
 seeBadgeAll() async {
    var request = http.MultipartRequest('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/updateBadge'));
    request.fields.addAll({'user_id': userModel!.user_id, 'badge_type': 'new_notification'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
      print("see notifications.....$responseData");
    } else {
      print(response.reasonPhrase);
    }
  }
  ///-------razorPay
  @override
  void dispose() {
    super.dispose();

    _controller?.removeListener(loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueCom,
        centerTitle: true,
        title: Text(
          "Notification",
          style: btnWhite(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              List vIds = [];
              for (int ii = 0; ii < notificationListData.length; ii++) {
                if (notificationListData[ii]['is_selected']) {
                  vIds.add(notificationListData[ii]['notification_id']);
                }
              }
              // _page = 1;
              // _hasNextPage = true;
              // _isLoadMoreRunning = false;
              // notificationListData = [];

              print("vIds...${vIds.join(",")}");
              deleteNotification(vIds.join(","));
              getNotificationListApi();
            },
          )
        ],
      ),
      body: notificationListData.length == 0
          ? Center(child: Text("Notification Data empty"))
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: ListView.builder(
                controller: _controller,
                itemCount: notificationListData.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    child: InkWell(
                      onLongPress: () {
                        setState(() {
                          notificationListData[index]['is_selected'] =
                              !notificationListData[index]['is_selected'];
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[50]!,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: white,
                                      border:
                                          Border.all(width: 2, color: white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: notificationListData[index]
                                                    ['user_image']
                                                .length >
                                            0
                                        ? NetworkImage(
                                            notificationListData[index]
                                                ['user_image'],
                                          )
                                        : AssetImage(
                                                'assets/images/uprofile.png')
                                            as ImageProvider,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              notificationListData[index]
                                                  ['name'],
                                              style: smollheader(context),
                                              //    " fghb",
                                              //  style: b
                                              //
                                              //
                                              // usinessHeader(context),
                                            ),
                                            Text(
                                                convertTime(
                                                    (notificationListData !=
                                                            null)
                                                        ? notificationListData[
                                                            index]['created']
                                                        : ""),
                                                style: smollheader(context)
                                                    .copyWith(fontSize: 9)),
                                          ],
                                        ),

                                        Text(
                                          notificationListData[index]
                                              ['notification_text'],
                                          style: verysmollheader2(context),
                                        ),
                                        //  isSelected
                                        (notificationListData != null)
                                            ? ((notificationListData[index]
                                                        ['is_selected'] !=
                                                    null)
                                                ? (notificationListData[index]
                                                        ['is_selected'])
                                                    ? Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.check_circle,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      )
                                                    : Container()
                                                : Container())
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: borderColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  getNotificationListApi() async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getNotification'));
    request.fields.addAll({
      "user_id": userModel!.user_id,
      "security_code": userModel!.security_code,
      "page_no": "1",
      "limit": "10"
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
            notificationListData = [];
          });
        }
      } else if (responseData['status'] == 1) {
        try {
          notificationListData = responseData['notification'];
          for (int i = 0; i < notificationListData.length; i++) {
            notificationListData[i]['is_selected'] = false;
          }
          setState(() {});
        } catch (e) {
          log("Exception...$e");
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
    print("reviewsad...${notificationListData.length}");

    setState(() {
      _isLoading = false;
    });
  }

  //---for pagination
  void loadMore() async {
    if (_hasNextPage == true &&
        _isLoading == false &&
        _isLoadMoreRunning == false &&
        _controller!.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      var request = http.MultipartRequest('POST',
          Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getNotification'));
      request.fields.addAll({
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "page_no": _page.toString(),
        "limit": "10"
      });

      http.StreamedResponse response = await request.send();
      print("request...${request.fields}");
      if (response.statusCode == 200) {
        dynamic responseJson = await response.stream.bytesToString();
        dynamic responseData = json.decode(responseJson);

        print("load1..$responseData");
        if (responseData['status'] == 1) {
          try {
            List tempnotificationListData = responseData['notification'];
            if (tempnotificationListData.length > 0) {
              notificationListData.addAll(tempnotificationListData);
            }

            for (int i = 0; i < notificationListData.length; i++) {
              notificationListData[i]['is_selected'] = false;
            }
            setState(() {});
          } catch (e) {
            log("Exception...$e");
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
      print("reviewsad...${notificationListData.length}");
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void showSnackBar() {
    final snackBar = SnackBar(
      content: Text('You have fetched all of the content'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  deleteNotification(notification_id) {
    //  setState(() {
    //     _isLoading = true;
    //   });
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/deleteNotification'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "notification_id": notification_id
      },
    ).then(
      (response) {
        dynamic result1 = json.decode(response.body);
        print("notificationDdelel..${result1}");
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          getNotificationListApi();
          return showToastMessage(mgs, context);
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
          return showToastMessage(mgs, context);
        }
      },
    );
  }

  String convertTime(String vCreateTime) {
    // var dateTime =
    //     DateFormat("yyyy-MM-dd HH:mm:ss").parse("2022-07-04 08:51:57", true);
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(vCreateTime, true);
    var dateLocal = dateTime.toLocal();
    print("current..$dateLocal");
    return DateFormat('dd MMM,hh:mm a').format(dateLocal);
  }
}


