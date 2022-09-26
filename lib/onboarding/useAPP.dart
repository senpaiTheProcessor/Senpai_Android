import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:senpai/Common/Button.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/onboarding/home_onboradind.dart';

class UseApp extends StatefulWidget {
  const UseApp({Key? key}) : super(key: key);

  @override
  State<UseApp> createState() => _UseAppState();
}

class _UseAppState extends State<UseApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             SizedBox(
            height:  MediaQuery.of(context).size.height*0.05,
          ),
          InkWell(
            onTap: (() {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
            }),
            child: Padding(
              padding: const EdgeInsets.only(left: 250),
              child: Text("Skip",style:TextStyle(color: Colors.blue,
              fontSize: MediaQuery.of(context).size.width*0.05,
              fontWeight: FontWeight.bold,
          
              )),
            ),
          ),
          SizedBox(
            height:  MediaQuery.of(context).size.height*0.1,
          ),
          Image.asset("assets/images/useApp.png"),
          SizedBox(
            height:  MediaQuery.of(context).size.height*0.2,
          ),
          loginBtn(),
          registionText()
        ],),
      ),
    );
  }


    Widget loginBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Button(
          key: Key('login_button'),
          buttonName: "Get Started",
          onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeTutorial()));
            // onPresedLogin();
          },
        ),
      ),
    );
  }

  Widget registionText() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Registion(),
          //   ),
          // );
        },
        child: RichText(
          text: TextSpan(
            text: 'How to use app',
            style: bottomheader(context),
            // children: [
            //   TextSpan(text: ' SignUp', style: blueheader(context)),
            // ],
          ),
        ),
      ),
    );
  }
}