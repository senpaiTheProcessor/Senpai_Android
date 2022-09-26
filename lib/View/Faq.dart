// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:senpai/Common/colors.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';

class Faq extends StatefulWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  List _FaqData = [];
  bool? _isLoading = false;

  @override
  void initState() {
    _FaqData = [];
    // TODO: implement initState
    super.initState();
    _getFaqApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: blueCom,
          centerTitle: true,
          title: Text(
            "FAQ",
            style: btnWhite(context),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
            child: Stack(
              children: [
               _FaqData.length == 0
        ? Center(child: Text("No Record Found!"))
        : demo(),
                LoaderIndicator(_isLoading!),
              ],
            )));
  }

  Widget demo() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _FaqData.length,
        itemBuilder: (BuildContext context, int index) {
          return lOREMmean(index);
        });
  }

  Widget lOREMmean(index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: white,
            border: Border.all(width: 1, color: Color(0xff646363)),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: ExpansionTile(
          title: Container(
            child: Text(
              // "What does LOREM mean?",
              _FaqData[index]['question'],
              style: bottomheader(context),
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                _FaqData[index]['answer'],

                // "Lorem ipsum dolor sit amet, consectetur adipisici elit… (complete text) is dummy text that is not meant to mean anything. It is used as a placeholder in magazine layouts, for example, in order to give an impression of thefinished documen ",
                style: verysmollheader2(context),
              ),
            ),
          ],
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  _getFaqApi() async {
    setState(() {
      _isLoading = true;
    });
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getFaqList'),
      body: {},
    ).then(
      (response) {
        dynamic res = json.decode(response.body);
        print("resGuide..$res");
        String mgs = res['message'];
        if (res['status'] == 1) {
           setState(() {
            _isLoading = false;
          });
          try {
            setState(() {
              _FaqData = res['faq'];
              print("faq..${_FaqData}");
            });
          } catch (e) {
            log("Exception...$e");
          }
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }
}
