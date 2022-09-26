// ignore_for_file: file_names, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:http/http.dart' as http;

class AboutUs extends StatefulWidget {
  const AboutUs({
    Key? key,
  }) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  var policyTest = '';

  @override
  void initState() {
    policyTest = '';
    // TODO: implement initState
    super.initState();
    getpolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueCom,
        centerTitle: true,
        title: Text(
          "About Us",
          style: btnWhite(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Text(
            //   "About Senpai",
            //   style: bottomheader(context),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 15),
            //   child: Text(
            //     "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in",
            //     style: verysmollheader2(context),
            //   ),
            // ),
            // HTML(data:""),
            Html(data: policyTest.toString()),
      
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "www.senpai.com",
                style: TextStyle(
                  color: blueCom,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "infosenpai@gmail.com",
                style: TextStyle(
                  color: black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "https://www.youtube.com/watch?v=zfX8aOKiXxg",
                style: TextStyle(
                  color: black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "https://www.instagram.com/beingsalmankhan/",
                style: TextStyle(
                  color: blueCom,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset(
                    "assets/logo/facebook.png",
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset("assets/logo/insta.png", width: 30, height: 30),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset("assets/logo/linkedin.png", width: 30, height: 30),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset("assets/logo/twitter.png", width: 30, height: 30)
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  getpolicy() {
// userModel!.user_id
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/getPolicy'),
      body: {"policy_type": "2"},
    ).then(
      (response) {
        print("get Review...${response.body}");
        dynamic result1 = json.decode(response.body);
        setState(() {
          policyTest = result1['policy_text'];
        });

        print("...$policyTest");
      },
    );
  }
}
