// ignore_for_file: file_names, prefer_typing_uninitialized_variables, null_check_always_fails

import 'package:flutter/material.dart';

class WidthHeight extends StatefulWidget {
  static var myWidth;

  const WidthHeight({Key? key}) : super(key: key);

  @override
  _WidthHeightState createState() => _WidthHeightState();
}

class _WidthHeightState extends State<WidthHeight> {
// static var myWidth;

  @override
  Widget build(BuildContext context) {
    WidthHeight.myWidth = MediaQuery.of(context).size.width;

    return null!;
  }
}
