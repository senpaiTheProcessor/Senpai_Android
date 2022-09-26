// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class CommonSized extends StatelessWidget {
  final double height;
  CommonSized(this.height);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class CommonWidth extends StatelessWidget {
  final double width;
  CommonWidth(this.width);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}

// TextField(focusNode: FirstDisabledFocusNode(),)

class FirstDisabledFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    return false;
  }
}