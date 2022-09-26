import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/View/AboutUs.dart';
import 'package:senpai/View/Faq.dart';
import 'package:senpai/View/changePassword.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'FeedBack.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  // String txt = '';
  Future<void> share() async {
    await FlutterShare.share(
        title: 'Senpai',
        text: 'Senpai' +
            "\n" +
            "\n" +
            'Stay Connected and communication with your favourite teacher with SENPAI',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.ps.senpai',
        chooserTitle: 'Example Chooser Title');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: blueCom,
        centerTitle: true,
        title: Text(
          "Setting",
          style: btnWhite(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: white,

                border: Border.all(
                    color: Colors.transparent,
                    width: 1.0,
                    style: BorderStyle.solid), //Border.all

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ), //BoxShadow
                ],
              ),
              child: ListTile(
                leading: Image.asset("assets/logo/about.png", width: 25),
                title: const Text(
                  'About Us',
                  style: TextStyle(
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w500,
                      // fontSize: MediaQuery.of(Context).size.width / 26,
                      fontSize: 16,
                      color: black),
                  // textScaleFactor: 1.5,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.black,
                ),
                // subtitle: const Text('This is subtitle'),
                selected: true,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutUs()));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: white,

                border: Border.all(
                    color: Colors.transparent,
                    width: 1.0,
                    style: BorderStyle.solid), //Border.all

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ), //BoxShadow
                ],
              ),
              child: ListTile(
                leading: Image.asset("assets/logo/stars.png", width: 25),
                title: const Text(
                  'Rate Us',
                  style: TextStyle(
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w500,
                      // fontSize: MediaQuery.of(Context).size.width / 26,
                      fontSize: 16,
                      color: black),
                  // textScaleFactor: 1.5,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.black,
                ),
                // subtitle: const Text('This is subtitle'),
                selected: true,
                onTap: () {
                  launch("https://play.google.com/store/apps/details?id=com.ps.senpai");

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => FeedBack()));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: white,

                border: Border.all(
                    color: Colors.transparent,
                    width: 1.0,
                    style: BorderStyle.solid), //Border.all

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ), //BoxShadow
                ],
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.question_mark,
                  color: Colors.black,
                ),
                title: const Text(
                  'FaQ',
                  style: TextStyle(
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w500,
                      // fontSize: MediaQuery.of(Context).size.width / 26,
                      fontSize: 16,
                      color: black),
                  // textScaleFactor: 1.5,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.black,
                ),
                // subtitle: const Text('This is subtitle'),
                selected: true,
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Faq()));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: white,

                border: Border.all(
                    color: Colors.transparent,
                    width: 1.0,
                    style: BorderStyle.solid), //Border.all

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ), //BoxShadow
                ],
              ),
              child: ListTile(
                leading: Image.asset("assets/logo/share.png", width: 25),
                title: const Text(
                  'Share app',
                  style: TextStyle(
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w500,
                      // fontSize: MediaQuery.of(Context).size.width / 26,
                      fontSize: 16,
                      color: black),
                  // textScaleFactor: 1.5,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.black,
                ),
                // subtitle: const Text('This is subtitle'),
                selected: true,
                onTap: () {
                  share();
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: white,

                border: Border.all(
                    color: Colors.transparent,
                    width: 1.0,
                    style: BorderStyle.solid), //Border.all

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ), //BoxShadow
                ],
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                title: const Text(
                  'Change Password',
                  style: TextStyle(
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w500,
                      // fontSize: MediaQuery.of(Context).size.width / 26,
                      fontSize: 16,
                      color: black),
                  // textScaleFactor: 1.5,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.black,
                ),
                // subtitle: const Text('This is subtitle'),
                selected: true,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePassword()));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: white,

                border: Border.all(
                    color: Colors.transparent,
                    width: 1.0,
                    style: BorderStyle.solid), //Border.all

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ), //BoxShadow
                ],
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.call,
                  color: Colors.black,
                ),
                title: const Text(
                  'Call Permission',
                  style: TextStyle(
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w500,
                      // fontSize: MediaQuery.of(Context).size.width / 26,
                      fontSize: 16,
                      color: black),
                  // textScaleFactor: 1.5,
                ),

                // subtitle: const Text('This is subtitle'),
                selected: true,
                onTap: () {
                  requestCallPermission();
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: white,

                border: Border.all(
                    color: Colors.transparent,
                    width: 1.0,
                    style: BorderStyle.solid), //Border.all

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ), //BoxShadow
                ],
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.image,
                  color: Colors.black,
                ),
                title: const Text(
                  'Camera & Gallary Permission',
                  style: TextStyle(
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w500,
                      // fontSize: MediaQuery.of(Context).size.width / 26,
                      fontSize: 16,
                      color: black),
                  // textScaleFactor: 1.5,
                ),

                // subtitle: const Text('This is subtitle'),
                selected: true,
                onTap: () {
                  requestCameraPermission();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> requestCameraPermission() async {
    final serviceStatus = await Permission.camera.isGranted;

    bool isCameraOn = serviceStatus == ServiceStatus.enabled;

    final status = await Permission.camera.request();

    if (status == PermissionStatus.granted) {
      return showToastMessage("Permission camera Granted", context);
    } else if (status == PermissionStatus.denied) {
      return showToastMessage("Permission camera Denied", context);
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }

  Future<void> requestCallPermission() async {
    final serviceStatus = await Permission.microphone.isGranted;

    bool isCallConnected = serviceStatus == ServiceStatus.enabled;

    final status = await Permission.microphone.request();

    if (status == PermissionStatus.granted) {
      return showToastMessage("Permission calling Granted", context);
    } else if (status == PermissionStatus.denied) {
      return showToastMessage("Permission calling Denied", context);
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }
}
