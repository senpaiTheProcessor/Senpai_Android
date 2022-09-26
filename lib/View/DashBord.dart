// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_print, use_key_in_widget_constructors, file_names, unused_import, prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names, sized_box_for_whitespace, prefer_adjacent_string_concatenation, empty_catches

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:senpai/Call/CallScreen.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/bottomTabs/Blog.dart';
import 'package:senpai/View/bottomTabs/Home.dart';
import 'package:senpai/View/Notification.dart';
import 'package:senpai/View/bottomTabs/Booking.dart';
import 'package:senpai/View/bottomTabs/Explore.dart';
import 'package:senpai/View/drawer.dart';
import 'package:senpai/View/wallet/Wallet.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/model/UserModel.dart';

class Dashboard extends StatefulWidget {
  final dynamic selectedTab;
  final dynamic tabBarIndex;
  Dashboard({Key? key, this.selectedTab, this.tabBarIndex}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  //int selectedIndex = 0;
  String blog_see = '';
  String request_see = '';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Error Occurred: ${e.toString()} ");
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _UpdateConnectionState(result);
  }

  Future<void> _UpdateConnectionState(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      showStatus(result, true);
    } else {
      showStatus(result, false);
    }
  }

  void showStatus(ConnectivityResult result, bool status) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content:
            Text("${status ? 'ONLINE\n' : 'OFFLINE\n'}${result.toString()} "),
        backgroundColor: status ? Colors.green : Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  FocusNode? myFocusNode;
  UserModel? userModel;

  final FocusNode searchFocus = FocusNode();

  bool isLogin = false;
  int _selectedIndex = 0;
  int _selectedTabBarIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Booking(),
    Explore(),
    BlogRes()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // GetIt.instance<FeedViewModel>().setActualScreen(index);
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      print("selectedBooking1...${widget.tabBarIndex}");
      print("selectedBooking2...${widget.selectedTab}");
    } catch (e) {}
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);
    getUserModel();
    setState(() {
      try {
        _selectedTabBarIndex = int.parse(widget.tabBarIndex.toString());
      } catch (e) {}
    });
    setState(() {
      try {
        _selectedIndex = int.parse(widget.selectedTab.toString());
      } catch (e) {}
    });
    _widgetOptions = <Widget>[
      Home(),
      Booking(tabBarIndex: _selectedTabBarIndex),
      Explore(),
      BlogRes()
    ];

    checkIfLoggedIn();
    _getUserProfileApi();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print("message.listen notification..${message.toString()}");

        dynamic vData = message.data['body'];
        debugPrint("payload back..... :$vData");
        try {
          isLogin = Preference().getLoginBool(Preference.IS_LOGIN)!;
        } catch (e) {}
        if (isLogin == null) {
          return;
        } else if (!isLogin) {
          return;
        }
        try {
          print("message...${message.data['body'].toString()}");

          if (message.data['body'].toString().contains('sent you request') ||
              message.data['body']
                  .toString()
                  .contains('Accpeted your request') ||
              message.data['body']
                  .toString()
                  .contains('Rejected your request') ||
              message.data['body'].toString().contains('reviewed you') ||
              message.notification!.title
                  .toString()
                  .contains('Add Wallet Amount')) {
          } else {
            //  FlutterRingtonePlayer.stop();
            FlutterRingtonePlayer.playRingtone();
          }
        } catch (e) {
          print("Exception occurs.....");
        }
        if (message.data['body'].toString().contains('sent you request')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(selectedTab: 1, tabBarIndex: 1),
            ),
          );
        } else if (message.data['body']
            .toString()
            .contains('Accpeted your request')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(
                selectedTab: 1,
                tabBarIndex: 3,
              ),
            ),
          );
        } else if (message.data['body']
            .toString()
            .contains('Rejected your request')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(selectedTab: 1, tabBarIndex: 1),
            ),
          );
        } else if (message.data['body'].toString().contains('reviewed you')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(selectedTab: 1, tabBarIndex: 0),
            ),
          );
        } else {
          dynamic dataBBJ = jsonDecode(vData!);
          log("call......notifiy$dataBBJ");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallScreen(
                userData: dataBBJ,
                is_from: false,
              ),
            ),
          );
        }
      }
    });
    getMessage();
  }

////-------------Notification start
  Future<void> getMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked! backgraund..on click....');

      bool isLogin = false;
      try {
        isLogin = Preference().getLoginBool(Preference.IS_LOGIN)!;
      } catch (e) {
        print("Exception...$e");
      }
      if (isLogin == null) {
        return;
      } else if (!isLogin) {
        return;
      }

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        String? vBody = message.data['body'];

        print('Message clicked! backgraund......${message.data['body']}');
        print(
            'Message data backgraund...body...: ${message.notification!.body}');
        print(
            'Message data backgraund.....title.: ${message.notification!.title}');

        try {
          print("message...${message.notification!.body.toString()}");

          if (message.notification!.body
                  .toString()
                  .contains('sent you request') ||
              message.notification!.body
                  .toString()
                  .contains('Accpeted your request') ||
              message.notification!.body
                  .toString()
                  .contains('Rejected your request') ||
              message.notification!.body.toString().contains('reviewed you') ||
              message.notification!.title
                  .toString()
                  .contains('Add Wallet Amount')) {
          } else {
            //   FlutterRingtonePlayer.stop();
            FlutterRingtonePlayer.playRingtone();
          }
        } catch (e) {
          print("Exception occurs.....");
        }

        if (message.notification!.body
            .toString()
            .contains('sent you request')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(selectedTab: 1, tabBarIndex: 1),
            ),
          );
        } else if (message.notification!.body
            .toString()
            .contains('Accpeted your request')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(
                selectedTab: 1,
                tabBarIndex: 0,
              ),
            ),
          );
        } else if (message.notification!.body
            .toString()
            .contains('Rejected your request')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(selectedTab: 1, tabBarIndex: 1),
            ),
          );
        } else if (message.notification!.body
            .toString()
            .contains('reviewed you')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(selectedTab: 1, tabBarIndex: 0),
            ),
          );
        } else {
          dynamic dataBBJ = jsonDecode(vBody!);
          log("call......notifiy$dataBBJ");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallScreen(
                userData: dataBBJ,
                is_from: false,
              ),
            ),
          );
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      try {
        isLogin = Preference().getLoginBool(Preference.IS_LOGIN)!;
      } catch (e) {}
      if (isLogin == null) {
        return;
      } else if (!isLogin) {
        return;
      }
      print('Message clicked! foreground..On click messsage....');
      print('user_id: ${message.data}');
      print('Message data: ${message.notification?.body}');
      print('Message data: ${message.notification?.title}');
      try {
        print("message...${message.data['body'].toString()}");

        if (message.data['body'].toString().contains('sent you request') ||
                message.data['body']
                    .toString()
                    .contains('Accpeted your request') ||
                message.data['body']
                    .toString()
                    .contains('Rejected your request') ||
                message.data['body'].toString().contains('reviewed you') ||
                message.notification!.title
                    .toString()
                    .contains('Add Wallet Amount')

            //message.data['title'].toString().contains('Add Wallet Amount')
            ) {
        } else {
          FlutterRingtonePlayer.playRingtone();
        }
      } catch (e) {
        print("Exception occurs.....");
      }

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      var android = AndroidInitializationSettings('@mipmap/ic_launcher');
      var iOS = IOSInitializationSettings();
      var initSetttings = InitializationSettings(android: android, iOS: iOS);
      flutterLocalNotificationsPlugin.initialize(
        initSetttings,
        onSelectNotification: (payload) {
          debugPrint("payload :$payload");
          if (payload.toString().contains('sent you request')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(selectedTab: 1, tabBarIndex: 1),
              ),
            );
          } else if (payload.toString().contains('Accpeted your request')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(
                  selectedTab: 1,
                  tabBarIndex: 0,
                ),
              ),
            );
          } else if (payload.toString().contains('Rejected your request')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(selectedTab: 1, tabBarIndex: 1),
              ),
            );
          } else if (payload.toString().contains('reviewed you')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(selectedTab: 1, tabBarIndex: 0),
              ),
            );
          } else {
            dynamic dataBBJ = jsonDecode(payload!);
            log("call......notifiy$dataBBJ");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CallScreen(
                  userData: dataBBJ,
                  is_from: false,
                ),
              ),
            );
          }
        },
      );

      flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification?.title,
        message.notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            '1687497218170948721x8',
            'New Trips Notification ',
            icon: 'launch_background',
            enableLights: true,
            enableVibration: true,
            showWhen: true,
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            ongoing: true,
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            visibility: NotificationVisibility.public,
          ),
        ),
        // platformChannelSpecifics,
        payload: message.data['body'],
      );
    });
  }

////-------------Notification end

  void getUserModel() async {
    if (Preference().getLoginBool(Preference.IS_LOGIN)!) {
      Map<String, dynamic> jsondatais =
          jsonDecode(Preference().getString(Preference.USER_MODEL)!);
      userModel = UserModel.fromJson(jsondatais);
    } else {}
  }

  Future<void> checkIfLoggedIn() async {
    //if (Preference().getLoginBool(Preference.IS_LOGIN) == false) {
    print("Hello");
    setState(() {
      _widgetOptions[1];
      _widgetOptions[2];
      _widgetOptions[3];
    });
    //  }
  }

  DateTime pre_backpress = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        //  onWillPop: () async => true;
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if (cantExit) {
          //  show snackbar
          final toast = showToastMessage('Press again to exit', context);

          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: bottomNav(),
      ),
    );
  }

  Widget bottomNav() {
    return Container(
      //  height: 50,
      decoration: BoxDecoration(color: black),
      child: BottomNavigationBar(
          //  backgroundColor: LinearGradient(c),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: white,
              icon: Icon(
                Icons.home_outlined,
                color: black,
                size: 30,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              backgroundColor: white,
              icon: Badge(
                elevation: 0,
                badgeColor: request_see == "1" ? Colors.red : Colors.white,
                child: Image.asset(
                  'assets/logo/booking .png',
                  width: 30,
                  height: 30,
                ),
              ),
              label: "Booking",
            ),
            BottomNavigationBarItem(
              backgroundColor: white,
              icon: Image.asset(
                'assets/logo/logo_senpai.png',
                width: 30,
                height: 30,
              ),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              backgroundColor: white,
              icon: Badge(
                elevation: 0,
                badgeColor: blog_see == "1" ? Colors.red : Colors.white,
                child: Image.asset(
                  'assets/logo/Vector.png',
                  width: 30,
                  height: 30,
                ),
              ),
              label: "Resource",
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          unselectedItemColor: black,
          selectedLabelStyle: TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(color: Colors.black, fontSize: 12),
          fixedColor: black,
          iconSize: 40,
          onTap: _onItemTapped),
    );
  }

  _getUserProfileApi() async {
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/getUserProfile'),
      body: {"user_id": userModel!.user_id, "session_user_id": ""},
    ).then(
      (response) {
        dynamic responce = json.decode(response.body);
        String currentWallectBalance =
            responce['user_detail']['user_wallet_balance'];
        String notification_see = responce['user_detail']['new_notification'];
        blog_see = responce['user_detail']['new_blog'];
        request_see = responce['user_detail']['new_request'];
        Preference().setString(Preference.NEW_NOTIFICATION, notification_see);
        Preference().setString(Preference.NEW_BLOG, blog_see);
        Preference().setString(Preference.NEW_REQUEST, request_see);
        Preference()
            .setString(Preference.CURRENT_BALANCE, currentWallectBalance);
        setState(() {});
      },
    );
  }
}
