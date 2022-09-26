// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:senpai/Common/colors.dart';

class LoaderIndicator extends StatelessWidget {
  final bool loading;
  LoaderIndicator(this.loading);
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height/2,
      // width: MediaQuery.of(context).size.width,
      child: loading == true
          // ignore: prefer_const_constructors
          ? Center(
              // ignore: prefer_const_constructors
              child: Container(
                height: 60,
                color: Colors.transparent,
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(blueCom),
                        ),
                        // SizedBox(width: 15,),
                        // Text("Loading...")
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}
