// ignore_for_file: file_names, must_be_immutable, use_key_in_widget_constructors, unnecessary_this, unnecessary_new, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BaseAlertDialog extends StatelessWidget {
  //When creating please recheck 'context' if there is an error!

  //Color _color = Color.fromARGB(220, 117, 218, 255);

  String? _title;
  String? _content;
  String? _yes;
  String? _no;
  Function? _yesOnPressed;
  Function? _noOnPressed;
  bool? barrierDismissible;

  BaseAlertDialog({
    String? title,
    String? content,
    Function? yesOnPressed,
    Function? noOnPressed,
    String yes = "Yes",
    String no = "",
  }) {
    this._title = title!;
    this._content = content!;
    this._yesOnPressed = yesOnPressed!;
    this._noOnPressed = noOnPressed;
    this._yes = yes;
    this._no = no;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //  barrierDismissible: false,
      title: new Text(this._title!),

      content: new Text(this._content!),
      backgroundColor: Colors.white,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: <Widget>[
        new FlatButton(
          child: Text(this._no!),
          textColor: Colors.red,
          onPressed: () {
            this._noOnPressed!();
          },
        ),
        new FlatButton(
          child: new Text(this._yes!),
          textColor: Colors.green,
          onPressed: () {
            this._yesOnPressed!();
          },
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<Function>('_yesOnPressed', _yesOnPressed));
  }
}
