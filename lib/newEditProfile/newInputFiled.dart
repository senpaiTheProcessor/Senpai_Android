// ignore_for_file: prefer_const_constructors, file_names, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, prefer_if_null_operators, camel_case_types, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senpai/Common/colors.dart';

class newTextFieldDesign extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final Set<void> Function() onEditingComplete;
  final controller;
  final textInputAction;
  final focusNode;
  final prefixText;
  final enabled;
  final hintText;
  // final lableText;
  final inputHeaderName;
  final prefixStyle;
  final validator;
  final errorText;
  final keyBoardType;
  final List<TextInputFormatter> inputFormatterData;
  final FormFieldSetter<String> onSaved;
  final obsecureText;
  final suffixIcon;
  final prefixIcon;
  final maxlength;
  final counterText;

  const newTextFieldDesign({
    Key? key,
    this.controller,
    this.enabled,
    this.prefixText,
    this.prefixStyle,
    this.keyBoardType,
    this.obsecureText,
    this.suffixIcon,
    this.prefixIcon,
    this.hintText,
    // this.lableText,
    this.inputHeaderName,
    required this.inputFormatterData,
    this.validator,
    required this.onSaved,
    this.errorText,
    required this.onChanged,
    this.textInputAction,
    this.focusNode,
    required this.onEditingComplete,
    bool? enableInteractiveSelection,
    this.maxlength,
    this.counterText,
  }) : super(key: key);

  @override
  _newTextFieldDesignState createState() => _newTextFieldDesignState();
}

class _newTextFieldDesignState extends State<newTextFieldDesign> {
  // var cf = CommonFunctions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          (widget.inputHeaderName != null) ? widget.inputHeaderName : '',
          style: TextStyle(
            color: black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
            // fontFamily: "helvetica-light-587ebe5a59211",
          ),
        ),
        Container(
          height: 45,
          // color: Colors.tealAccent,
          child: TextFormField(
            cursorColor: Colors.grey,
            onSaved: widget.onSaved,
            textInputAction: widget.textInputAction,
            onEditingComplete: widget.onEditingComplete,
            focusNode: widget.focusNode,
            style: TextStyle(
              //   color: WeatherTheme.weatherBalck,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
              // fontFamily: "helvetica-light-587ebe5a59211",
            ),
            keyboardType: widget.keyBoardType,
            maxLength: widget.maxlength,

            // validator: (val) => widget.validator(val, widget.validatorFieldValue),
            controller: widget.controller,
            enabled: widget.enabled,
            inputFormatters: widget.inputFormatterData,
            obscureText:
                widget.obsecureText != null ? widget.obsecureText : false,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              counterText: widget.counterText,
              counter: Offstage(),
              filled: true,
              fillColor: Colors.transparent,
              hintText: (widget.hintText != null) ? widget.hintText : '',
              hintStyle: TextStyle(
                  color: Colors.black12,
                  fontSize: 14,
                  fontFamily: "PoppinsMedium",

                  // fontFamily: sourceSansPro,
                  fontWeight: FontWeight.w500),
              suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10.0, top: 20),
                  child:
                      widget.suffixIcon != null ? widget.suffixIcon : Text('')),
              prefixText: (widget.prefixText != null) ? widget.prefixText : '',
              prefixIcon: widget.prefixIcon,
              errorText: widget.errorText,
              errorStyle: TextStyle(/*fontFamily: monsterdRegular*/),
              contentPadding: const EdgeInsets.only(left: 0, top: 20),
            ),
          ),
        ),
      ],
    );
  }
}
