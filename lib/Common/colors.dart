// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

const blueCom = Color(0xFF2B78DF);
const blueComlight = Colors.blue;

const drawerCom = Color(0xFF2378E9);
const white = Color(0xFFFFFFFF);
const black = Color(0xFF000000);
const grayShade = Color(0xFFF4F4F4);
const borderColor = Color(0xFF7A7A7A);

const kAnimationDuration = Duration(milliseconds: 200);


TextStyle btnWhite(mContext) {
  TextStyle btnWhiteText = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w700,
      fontSize: MediaQuery.of(mContext).size.width / 24,
      color: white);
  return btnWhiteText;
}

TextStyle smollbtnWhite(mContext) {
  TextStyle smollbtnWhite = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w700,
      fontSize: MediaQuery.of(mContext).size.width *0.03,
      color: white);
  return smollbtnWhite;
}

TextStyle smolldrawerWhite(mContext) {
  TextStyle smolldrawerWhite = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w400,
      fontSize: MediaQuery.of(mContext).size.width / 35,
      color: white);
  return smolldrawerWhite;
}

TextStyle header(mContext) {
  TextStyle headerText = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w700,
      fontSize: MediaQuery.of(mContext).size.width /19,
      color: black);
  return headerText;
}

TextStyle headerexplore(mContext) {
  TextStyle headerText = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w600,
      fontSize: MediaQuery.of(mContext).size.width * 0.05,
      color: black);
  return headerText;
}

TextStyle subheader(mContext) {
  TextStyle subheaderText = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w400,
      fontSize: MediaQuery.of(mContext).size.width / 26,
      color: black);
  return subheaderText;
}

TextStyle subheaderdark(mContext) {
  TextStyle subheaderText = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w600,
      fontSize: MediaQuery.of(mContext).size.width / 26,
      color: black);
  return subheaderText;
}

TextStyle mediumsmollheader(mContext) {
  TextStyle smollheader = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w700,
      fontSize: MediaQuery.of(mContext).size.width / 25,
      color: black);
  return smollheader;
}

// TextStyle mediumsmollheader(mContext) {
//   TextStyle smollheader = TextStyle(
//       fontFamily: "OpenSans",
//       fontWeight: FontWeight.w700,
//       fontSize: MediaQuery.of(mContext).size.width / 25,
//       color: black);
//   return smollheader;
// }
TextStyle smollheader(mContext) {
  TextStyle smollheader = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w700,
      fontSize: MediaQuery.of(mContext).size.width *0.03,
      color: black);
  return smollheader;
}

TextStyle smollheaderlight(mContext) {
  TextStyle smollheader = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w500,
      fontSize: MediaQuery.of(mContext).size.width / 30,
      color: black);
  return smollheader;
}

TextStyle smollheadertext(mContext) {
  TextStyle smollheader = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w500,
      fontSize: MediaQuery.of(mContext).size.width / 27,
      color: black);
  return smollheader;
}

TextStyle verysmollheader(mContext) {
  TextStyle verysmollheader = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w700,
      fontSize: MediaQuery.of(mContext).size.width / 36,
      color: black);
  return verysmollheader;
}

TextStyle verysmollheader2(mContext) {
  TextStyle verysmollheader = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w400,
      fontSize: MediaQuery.of(mContext).size.width / 32,
      color: black);
  return verysmollheader;
}

TextStyle bottomheader(mContext) {
  TextStyle bottomheader = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w700,
      fontSize: MediaQuery.of(mContext).size.width / 29,
      color: black);
  return bottomheader;
}

TextStyle blueheader(mContext) {
  TextStyle blueheader = TextStyle(
      fontFamily: "OpenSans",
      fontWeight: FontWeight.w700,
      fontSize: MediaQuery.of(mContext).size.width / 28,
      color: blueCom);
  return blueheader;
}

showToastMessage(String massage, BuildContext context) {
  showToast(massage,
      context: context,
      animation: StyledToastAnimation.slideFromTopFade,
      reverseAnimation: StyledToastAnimation.slideFromTopFade,
      backgroundColor: Colors.red,
      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      position: StyledToastPosition(align: Alignment.topCenter, offset: 100),
      startOffset: Offset(0.0, -1.0),
      reverseEndOffset: Offset(0.0, 0.0),
      duration: Duration(seconds: 2),
      //Animation duration   animDuration * 2 <= duration
      animDuration: Duration(seconds: 1),
      curve: Curves.fastLinearToSlowEaseIn,
      reverseCurve: Curves.fastOutSlowIn);
}
