// ignore_for_file: file_names, non_constant_identifier_names, unused_field, avoid_unnecessary_containers, prefer_const_constructors, unnecessary_new, sized_box_for_whitespace, avoid_print, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Common/mediumButton.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/View/viewAll.dart';
import 'package:senpai/model/intrestModel.dart';
import 'package:http/http.dart' as http;

class AllCategory extends StatefulWidget {
  const AllCategory({Key? key}) : super(key: key);

  @override
  State<AllCategory> createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory> {
  dynamic IntrestData = [];
  bool? _isLoading = false;
  List<IntrestModel> _intrest = [];
  String user_id = "0";

  @override
  void initState() {
    super.initState();
    getintestByUserID();
  }

  FocusNode? myFocusNode;

  final FocusNode searchFocus = FocusNode();
  TextEditingController searchCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: blueCom,
            centerTitle: true,
            title: Container(
              height: 36,
              child: TextFormField(
                textInputAction: TextInputAction.search,
                // onFieldSubmitted: (value) {
                //  getintestByUserID();
                //   //    ge("");
                //   // Navigator.push(
                //   //     context,
                //   //     MaterialPageRoute(
                //   //         builder: (context) => SearchPage(search: value)));
                // },
                onChanged: (value) {
                  print("value$value");

                  getintestByUserID();
                },
                controller: searchCon,
                autofocus: false,
                focusNode: searchFocus,
                onEditingComplete: () => {FocusScope.of(context).unfocus()},
                style: TextStyle(
                    color: black,
                    fontSize: 14,
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'Serach Intrest',
                  hintStyle: TextStyle(
                      color: white,
                      fontSize: 12,
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w600),
                  suffixIcon: Icon(
                    Icons.search,
                    color: white,
                  ),
                  contentPadding: const EdgeInsets.only(left: 8, top: 20),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(color: white, width: 0.9),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(color: white, width: 0.5),
                  ),
                ),
              ),
            )),
        body: Stack(
          children: [
            exprienceList(),
            LoaderIndicator(_isLoading!),
          ],
        ));
  }

  Widget exprienceList() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: IntrestData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 12, top: 4, right: 4, bottom: 4),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      //  border: Border.all(
                      //     color: Colors.grey,
                      //     style: BorderStyle.solid,
                      //     width: 1.0,
                      // ),
                      boxShadow: [
                        new BoxShadow(
                            color: Colors.black,
                            blurRadius: 2.0,
                            offset: Offset(0.0, 0.75)),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          IntrestData[index]['interest_name'],
                          style: mediumsmollheader(context),
                        ),
                        categoriesBtn(index)
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget categoriesBtn(index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.045,
        child: mediumButton(
          key: Key('review_button'),
          buttonName: "View All",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewALLPage(
                          inerestKey: IntrestData[index]['interest_name'],
                          inerestName: IntrestData[index]['interest_name'],
                          isRecommendeKey: false,
                        )));
          },
        ),
      ),
    );
  }

  void getintestByUserID() async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getInterest');
    var response = await http
        .post(url, body: {"user_id": user_id, "search_text": searchCon.text});
    dynamic res = json.decode(response.body.toString());
    IntrestData = res['interest'];
    _intrest = (res['interest'] as List)
        .map((itemWord) => IntrestModel.fromJson(itemWord))
        .toList();

    setState(() {
      _isLoading = false;
    });
  }
}
