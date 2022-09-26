// ignore_for_file: file_names, overridden_fields, annotate_overrides, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:flutter/material.dart';
import 'package:senpai/Common/colors.dart';

class smallButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonName;
  final Key key;

  //passing props in react style
  smallButton(
      {required this.buttonName, required this.onPressed, required this.key});

  @override
  Widget build(BuildContext context) {
    //  var screenSize = MediaQuery.of(context).size.width - 0;
    return Container(
      height: 46.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.0), color: blueCom
          // ignore: prefer_const_constructors
          // gradient: LinearGradient(colors: [
          //   Color(0xFF5d42ff),
          //   Color(0xFF8d7bfc),
          // ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
          ),
      // ignore: deprecated_member_use
      child: RaisedButton(
          key: key,
          elevation: 1.0,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            buttonName,
            style: TextStyle(
              inherit: true,
              color: white,
              fontSize: MediaQuery.of(context).size.width * 0.025,
              letterSpacing: 0.3,
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: onPressed),
    );
  }
}
