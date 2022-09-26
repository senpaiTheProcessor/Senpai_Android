//ignore_for_file: prefer_const_constructors, deprecated_member_use, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, avoid_print, unused_field, prefer_typing_uninitialized_variables, unused_element, unnecessary_const

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/ExplorDetail.dart';
import 'package:senpai/View/FindMe.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/View/favorateUserList.dart';
import 'package:senpai/View/setting.dart';
import 'package:senpai/View/wallet/Wallet.dart';
import 'package:senpai/model/Language.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:senpai/model/intrestModel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../newEditProfile/newEditProfile.dart';
import 'package:http/http.dart' as http;

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  // TimeOfDay startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay startTime = TimeOfDay(hour: 9, minute: 0);

  TimeOfDay endTime = TimeOfDay(hour: 21, minute: 0);
  String timeText = 'Set A Time';
  late bool _loading;
  late double _progressValue;
  UserModel? userModel;
  IntrestModel? intrestModel;
  List<LanguageModel> _language = [];
  List<IntrestModel> _intrest = [];
  dynamic getUserProfileData = [];
  dynamic experience = [];
  dynamic education = [];
  dynamic location = [];
  dynamic occupation = [];
  dynamic intresetList = [];
  String? discription = "";
  String? callSetting = "0";
  String currentWallectBalance = "00";
  List<String> intrest = [];
  String _call_Setting = " ";
  int initSelect = 1;
  String vStartTime = "09:00:00", vEndTime = "21:00:00";

  String converDateTime(String dateStr) {
    DateFormat dateFormat = DateFormat("HH:mm:ss");
    DateFormat dateFormat1 = DateFormat('hh:mm a');
    DateTime dateTime = dateFormat.parse(dateStr);
    return dateFormat1.format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _loading = false;
    print("ss..${Preference().getString(Preference.START_TIME)}");
    print("ss..${Preference().getString(Preference.END_TIME)}");
    if (Preference().getString(Preference.START_TIME) == null) {
      Preference().setString(Preference.START_TIME, vStartTime);
      Preference().setString(Preference.END_TIME, vEndTime);
    }

    if (Preference().getString(Preference.CALL_SETTING) == null) {
      Preference().setString(Preference.CALL_SETTING, "1");
    }

    vStartTime = Preference().getString(Preference.START_TIME)!;
    vEndTime = Preference().getString(Preference.END_TIME)!;

    initSelect = int.parse(Preference().getString(Preference.CALL_SETTING)!);
    _progressValue = 0.0;

    getUserModel();
    _getUserProfileApi();
  }

  void _editProflieNavigator(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewEditProfile()),
    );
    if (result != null) {
      _getUserProfileApi();
    }
  }

  final imageurl =
      'https://firebasestorage.googleapis.com/v0/b/senpai-b950a.appspot.com/o/logo_senpai%20(1).jpg?alt=media&token=b36af16c-e090-4e0d-a22d-11b9700e16ca';

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Senpai',
        text: 'Senpai' +
            "\n" +
            "Name : " +
            "${userModel!.name}"
                "\n" +
            "Interest : " +
            "${userModel!.interest}"
                "\n" +
            "Degree : " +
            "Master Degree"
                "\n" +
            "Contact No: " +
            "${userModel!.mobile_number}" +
            "\n"
                'Senpai App',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.ps.senpai',
        chooserTitle: 'Example Chooser Title');
  }

  Future<void> shareFile() async {
    // final result = await FilePicker.platform.pickFiles();
    // if (result == null || result.files.isEmpty) return null;

    final bytes = await rootBundle.load('assets/logo/logo_senpai.png');
    final list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/image.jpg').create();
    file.writeAsBytesSync(list);

    final channel = MethodChannel('channel:me.albie.share/share');
    channel.invokeMethod('shareFile', 'image.jpg');

    await FlutterShare.shareFile(
      title: 'Example share',
      text: 'Example share text',
      filePath: file.path,
    );
  }

  void getUserModel() async {
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    userModel = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print('user_name..${userModel!.name}');
      print('user_name..${userModel!.user_unique_id}');
      print('user_name..${userModel!.user_image}');
    }

    int percentage = 0;
    int sign_up = 0,
        edit_profile = 0,
        wallet_per = 0,
        experience_per = 0,
        education_per = 0,
        location_per = 0,
        occupation_per = 0;
    try {
      sign_up = int.parse(
          Preference().getString(Preference.SIGNUP_PROFILE_PRETANCE)!);
    } catch (e) {}

    try {
      edit_profile =
          int.parse(Preference().getString(Preference.EDIT_PROFILE_PRETANCE)!);
    } catch (e) {}

    try {
      wallet_per = int.parse(
          Preference().getString(Preference.WALLET_PROFILE_PRETANCE)!);
    } catch (e) {}
    try {
      experience_per =
          int.parse(Preference().getString(Preference.EXPERIANCE_PRETANCE)!);
    } catch (e) {}
    try {
      education_per =
          int.parse(Preference().getString(Preference.EDUCATION_PRETANCE)!);
    } catch (e) {}
    try {
      location_per =
          int.parse(Preference().getString(Preference.LOCATION_PRETANCE)!);
    } catch (e) {}
    try {
      occupation_per =
          int.parse(Preference().getString(Preference.OCCUPATION_PRETANCE)!);
    } catch (e) {}
    Preference().getString(Preference.IS_BLUE_TICK);
    percentage = sign_up +
        edit_profile +
        wallet_per +
        experience_per +
        education_per +
        location_per +
        occupation_per;
    print("pretange$percentage");
    print("isssssss...${Preference().getString(Preference.IS_BLUE_TICK)}");
    setState(() {
      _progressValue = double.parse(percentage.toString());
    });
  }

  void _updateProgress() {
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      setState(() {
        _progressValue += 0.1;
        // we "finish" downloading here
        if (_progressValue.toStringAsFixed(1) == '1.0') {
          _loading = false;
          t.cancel();
          return;
        }
      });
    });
  }

  _startTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: startTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != startTime) {
      // vStartTime="";
      setState(() {
        startTime = timeOfDay;

        vStartTime = "${getValue(startTime.hour)}" +
            ":${getValue(startTime.minute)}" +
            ":00";

        // if (startTime.hour >= 0 && startTime.hour <= 12) {
        //   vStartTime = "${startTime.hour}" + ":${startTime.minute}" + " AM";
        // } else if (startTime.hour >= 12 && startTime.hour <= 24) {
        //   vStartTime = "${startTime.hour}" + ":${startTime.minute}" + " PM";
        // }
        startCallTime();
      });
      print("start_time...${vStartTime}");
    }
  }

  _endTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: endTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != endTime) {
      setState(() {
        endTime = timeOfDay;
        vEndTime = "${getValue(endTime.hour)}" +
            ":${getValue(endTime.minute)}" +
            ":00";

        // if (endTime.hour >= 0 && endTime.hour <= 12) {
        //   vEndTime = "${endTime.hour}" + ":${endTime.minute}" + " AM";
        // } else if (endTime.hour >= 12 && endTime.hour <= 24) {
        //   vEndTime = "${endTime.hour}" + ":${endTime.minute}" + " PM";
        // }
        endCallTime();
      });
      print("start_time...${vEndTime}");
    }
  }

  String getValue(int value) {
    if (value < 10) {
      return ("0" + value.toString());
    } else {
      return value.toString();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.4,
      child: Drawer(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4.4,
              child: DrawerHeader(
                  decoration: BoxDecoration(color: drawerCom),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ExploreDetail(
                                                detailKey: userModel!.user_id,
                                                ReviewKey: false,
                                                profliekey: true,
                                                reportkey: false,
                                                favirateKey: false,
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black54),
                                      shape: BoxShape.circle),
                                  child: ClipOval(
                                    child: userModel!.user_image.length > 0
                                        ? Image.network(
                                            userModel!.user_image,
                                            fit: BoxFit.cover,
                                            width: 55.0,
                                            height: 55.0,
                                          )
                                        : Image.asset(
                                            'assets/images/uprofile.png'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 2, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Unique Id :- ${userModel!.user_unique_id}",
                                          style: smollbtnWhite(context),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        (Preference().getString(
                                                    Preference.IS_BLUE_TICK) ==
                                                "1")
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border.all(
                                                      color: Colors.transparent,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Icon(
                                                  Icons
                                                      .check_circle_outline_outlined,
                                                  color: Colors.white,
                                                ))
                                            : Container()
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        "${userModel!.name}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: smollbtnWhite(context),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "Current Balance :- " +
                                          (currentWallectBalance.isEmpty
                                              ? "0.00"
                                              : "\u20B9" +
                                                  currentWallectBalance),
                                      style: smolldrawerWhite(context),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _editProflieNavigator(context);
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             NewEditProfile()));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 1),
                                          child: Text(
                                            "Edit Profile",
                                            style: smollheader(context),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: LinearProgressIndicator(
                              minHeight: 12,
                              backgroundColor: Color(0xff0A4FAA),
                              color: white,
                              valueColor: AlwaysStoppedAnimation<Color>(white),
                              value: (_progressValue / 100),
                            ),
                          ),
                          Text(
                            '${(_progressValue).round()}%',
                            style: smolldrawerWhite(context),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  child: Icon(
                    Icons.lock_clock,
                    size: 20,
                  ),
                ),
                Text(
                  "Update/ Prefered Timing",
                  style: bottomheader(context),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                ),
              ],
            ),
            InkWell(
              onTap: () {
                _startTime(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Text(
                      "Start Time  :-",
                      style: TextStyle(color: blueCom, fontSize: 14),
                    ),
                    Text(
                      " ${converDateTime(vStartTime)}",
                      // "  ${startTime.hour}:${startTime.minute}",
                      style: TextStyle(color: blueCom, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _endTime(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Text(
                      "End Time   :-",
                      style: TextStyle(color: blueCom, fontSize: 14),
                    ),
                    Text(
                      // "   ${endTime.hour}:${endTime.minute}",
                      " ${converDateTime(vEndTime)}",
                      style: TextStyle(color: blueCom, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Row(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                child: Icon(
                  Icons.call_outlined,
                  size: 20,
                ),
              ),
              Text(
                "Call Setting",
                style: bottomheader(context),
              ),
            ]),
            InkWell(
              onTap: () {
                // direct call 2
                setState(() {
                  if (initSelect == 1) {
                    initSelect = 2;
                  } else {
                    initSelect = 1;
                  }
                  callTimeSetting(2);
                  //_call_Setting = " 2";
                });
              },
              child: Row(children: [
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: initSelect == 2 ? blueCom : Colors.white,
                          border: Border.all(color: black, width: 2)),
                    )),
                Text(
                  "Every time available (direct call)  \n/ Noapproach  mode",
                  style: verysmollheader2(context),
                )
              ]),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  // every time 1
                  if (initSelect == 2) {
                    initSelect = 1;
                  } else {
                    initSelect = 2;
                  }
                  callTimeSetting(1);
                  // _call_Setting = " 1";
                });
              },
              child: Row(children: [
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: initSelect == 1 ? blueCom : Colors.white,
                          border: Border.all(color: black, width: 2)),
                    )),
                Text(
                  "Approach only mode",
                  style: verysmollheader2(context),
                )
              ]),
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Favorate()));
              },
              child: Row(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  child: Image.asset(
                    "assets/logo/fav.png",
                    width: 20,
                  ),
                ),
                Text(
                  "Favourite",
                  style: bottomheader(context),
                )
              ]),
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => FindMe()));
              },
              child: Row(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  child: Image.asset(
                    "assets/logo/see.png",
                    width: 20,
                  ),
                ),
                Text(
                  "Find Me Senpai",
                  style: bottomheader(context),
                )
              ]),
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Setting()));
              },
              child: Row(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  child: Image.asset("assets/logo/about.png", width: 20),
                ),
                Text(
                  "Setting",
                  style: bottomheader(context),
                )
              ]),
            ),
            Divider(),
            InkWell(
              onTap: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => Wallet()));
                _walletNavigatore(context);
              },
              child: Row(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  child: Image.asset("assets/logo/wallet.png", width: 20),
                ),
                Text(
                  "My Wallet",
                  style: bottomheader(context),
                )
              ]),
            ),
            Divider(),
            InkWell(
              onTap: () async {
                List<String> skills = [];
                for (var item in _intrest) {
                  skills.add(item.interest_name.toString());
                }

                final uri = Uri.parse(imageurl);
                final response = await http.get(uri);
                final bytes = response.bodyBytes;

                final temp = await getTemporaryDirectory();
                final path = '${temp.path}/image.jpg';

                File(path).writeAsBytesSync(bytes);

                await Share.shareFiles([path],
                    text: 'Senpai' +
                        "\n" +
                        "Name : " +
                        "${userModel!.name}"
                            "\n" +
                        "Skills : " +
                        "${skills.join(",").toString()}"
                            "\n" +
                        "Degree : " +
                        "\n"
                            'Senpai App' +
                        "\n" +
                        "https://play.google.com/store/apps/details?id=com.ps.senpa");
              },
              child: Row(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  child: Image.asset("assets/logo/share.png", width: 20),
                ),
                Text(
                  "Share Profile",
                  style: bottomheader(context),
                )
              ]),
            ),
            Divider(),
            InkWell(
              onTap: () {
                logoutAlert();
              },
              child: Row(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 1),
                  child: Image.asset("assets/logo/logout.png", width: 20),
                ),
                Text(
                  "Logout",
                  style: bottomheader(context),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  logoutAlert() {
    var baseDialog = BaseAlertDialog(
      title: "Logout",
      content: "Do you want to logout?",
      yesOnPressed: () async {
        Navigator.pop(context);
        //  Navigator.pop(context);
        Preference().setLoginBool(Preference.IS_LOGIN, false);
        //  Preference().setString(Preference.CURRENT_BALANCE, "00");
        SharedPreferences userData = await SharedPreferences.getInstance();
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
        Navigator.pop(context);
      },
      yes: "Confirm",
      no: "Cancel",
    );
    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  void saveUserData(String userImage) {
    print("$userImage");
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    //jsondatais['user_image']=userImage;
    userModel = UserModel.fromJson(jsondatais);
    userModel!.user_image = userImage;
    // //dynamic userJsonObject = userResponse['user'];
    // UserModel userModel = UserModel.fromJson(userResponse);
    String userModelStr = jsonEncode(userModel);
    print("saveUserVerification $userModelStr");
    Preference().setString(Preference.USER_MODEL, userModelStr);
    getUserModel();
  }

  //--------get user Profile
  _getUserProfileApi() async {
    // setState(() {
    //   _isLoading = true;
    // });
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/getUserProfile'),
      body: {"user_id": userModel!.user_id, "session_user_id": ""},
    ).then(
      (response) {
        dynamic result1 = json.decode(response.body);
        getUserProfileData = result1['user_detail'];
        saveUserData(getUserProfileData['user_image'].toString());
        if (mounted) {
          setState(() {
            userModel!.user_image = getUserProfileData["user_image"];
          });
        }
        currentWallectBalance = getUserProfileData['user_wallet_balance'];
        print("currentWallectBalance...${currentWallectBalance}");

        print("getUserProfileData...${getUserProfileData}");
        experience = getUserProfileData['experience'];
        print("experience...${experience}");

        education = getUserProfileData['study_field'];
        print("education...${education}");

        print("education...${education.length}");
        location = getUserProfileData['location'];
        print("location...${location}");

        print("location...${location.length}");
        occupation = getUserProfileData['occupation'];
        print("occupation...${occupation}");
// is_blue_tick
        print("occupation...${occupation.length}");
        discription = getUserProfileData['user_bio'];
        print("discription...${discription}");

        _language = (getUserProfileData['language'] as List)
            .map((itemWord) => LanguageModel.fromJson(itemWord))
            .toList();
        setState(() {});
        _intrest = (getUserProfileData['interest'] as List)
            .map((itemWord) => IntrestModel.fromJson(itemWord))
            .toList();
        callSetting = getUserProfileData['call_setting'];
        print("callSetting...$callSetting");

//  int.parse( Preference().setString(Preference.CALL_SETTING, callSetting)
// );
        setState(() {});
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          // setState(() {
          //   _isLoading = false;
          // });

        } else {}
      },
    );
  }

//-------updateTime Setting
  startCallTime() {
    print("object${userModel!.user_id}");
    print("object${userModel!.security_code}");
    print("object${_call_Setting}");
    print("object${startTime}");
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/updateSetting'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "call_setting": "",
        // "prefered_time": prefered_time,
        "start_time": vStartTime,
        "end_time": vEndTime
      },
    ).then(
      (response) {
        print("object...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          Preference().setString(Preference.START_TIME, vStartTime);
          // setState(() {
          //   _isLoading = false;
          // });
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
          // setState(() {
          //   _isLoading = false;
          // });

        }
      },
    );
  }

  endCallTime() {
    print("object${userModel!.user_id}");
    print("object${userModel!.security_code}");
    print("object${_call_Setting}");
    print("object${vStartTime}");
    print("object${vEndTime}");
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/updateSetting'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "call_setting": "",
        // "prefered_time": prefered_time,
        "start_time": vStartTime,
        "end_time": vEndTime
      },
    ).then(
      (response) {
        print("object...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          Preference().setString(Preference.END_TIME, vEndTime);
          // setState(() {
          //   _isLoading = false;
          // });
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
          // setState(() {
          //   _isLoading = false;
          // });

        }
      },
    );
  }

  callTimeSetting(int _call_Setting) {
//  setState(() {
//       _isLoading = true;
//     });
    print("object${userModel!.user_id}");
    print("object${userModel!.security_code}");
    print("object.....${_call_Setting}");
    print("object${endTime}");
    // print("object${expertiseRating.toString()}");

    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/updateSetting'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "call_setting": _call_Setting.toString(),
        // "prefered_time": prefered_time,
        "start_time": "",
        "end_time": ""
      },
    ).then(
      (response) {
        print("object...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          Preference()
              .setString(Preference.CALL_SETTING, _call_Setting.toString());
          // setState(() {
          //   _isLoading = false;
          // });
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
          // setState(() {
          //   _isLoading = false;
          // });

        }
      },
    );
  }
}
