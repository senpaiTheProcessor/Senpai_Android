// ignore_for_file: prefer_const_constructors, file_names, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senpai/Common/colors.dart';

class TextFieldDesign extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final Set<void> Function() onEditingComplete;
  final controller;
  final textInputAction;
  final focusNode;
  final prefixText;
  final enabled;
  final hintText;
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
  final firstCapital;

  const TextFieldDesign({
    Key? key,
    this.firstCapital,
    this.controller,
    this.enabled,
    this.prefixText,
    this.prefixStyle,
    this.keyBoardType,
    this.obsecureText,
    this.suffixIcon,
    this.prefixIcon,
    this.hintText,
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
  }) : super(key: key);

  @override
  _TextFieldDesignState createState() => _TextFieldDesignState();
}

class _TextFieldDesignState extends State<TextFieldDesign> {
  // var cf = CommonFunctions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text(
        //   (widget.inputHeaderName != null) ? widget.inputHeaderName : '',
        //   // style: labelHintFontStyle,
        // ),
        SizedBox(
          height: 2,
        ),
        Container(
          height: 50,
          
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: TextFormField(
            cursorColor: Colors.grey,
            onSaved: widget.onSaved,
            textInputAction: widget.textInputAction,
            onEditingComplete: widget.onEditingComplete,
            focusNode: widget.focusNode,
            style: TextStyle(
                //   color: WeatherTheme.weatherBalck,
                color: black,
                fontSize: 13,
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w600
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
              counter: Offstage(),
              filled: true,
              fillColor: Color(0XFFFFFFFF),
              hintText: (widget.hintText != null) ? widget.hintText : '',
              hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w400),
              suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: .0),
                  child:
                      widget.suffixIcon != null ? widget.suffixIcon : Text('')),
              prefixText: (widget.prefixText != null) ? widget.prefixText : '',
              prefixIcon: widget.prefixIcon,
              errorText: widget.errorText,
              errorStyle: TextStyle(/*fontFamily: monsterdRegular*/),
              contentPadding: const EdgeInsets.only(left: 5, top: 20),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(color: blueCom, width: 0.9),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(color: Colors.transparent, width: 0.2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
