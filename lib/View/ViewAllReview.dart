import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:http/http.dart' as http;

class ViewAllReview extends StatefulWidget {
  final dynamic reviewUserId;
  const ViewAllReview({Key? key, this.reviewUserId}) : super(key: key);

  @override
  State<ViewAllReview> createState() => _ViewAllReviewState();
}

class _ViewAllReviewState extends State<ViewAllReview> {
  List usergetReview = [];
  bool? _isLoading = false;
  int _page = 1;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  ScrollController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usergetReview = [];
    getReviewListApi();
    _controller = ScrollController()..addListener(loadMore);
  }

  ///-------razorPay
  @override
  void dispose() {
    super.dispose();

    _controller!.removeListener(loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: blueCom,
          centerTitle: true,
          title: Text(
            "Review",
            style: btnWhite(context),
          ),
          leading: InkWell(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Icon(Icons.arrow_back)),
        ),
        body: reviewList());
  }

  Widget reviewList() {
    return usergetReview.length == 0
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Container(
              child: ListView.builder(
                  controller: _controller,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount:
                      usergetReview.length != null ? usergetReview.length : 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            // border: Border.all(width: 1, color: borderColor),
                            color: white,
                            borderRadius: BorderRadius.circular(0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 45.0,
                                    width: 45.0,
                                    decoration: BoxDecoration(
                                        color: white,
                                        border: Border.all(
                                            width: 1, color: grayShade),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50))),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: usergetReview[index]
                                                      ['user_image']
                                                  .length >
                                              0
                                          ? NetworkImage(
                                              usergetReview[index]
                                                  ['user_image'],
                                            )
                                          : AssetImage(
                                                  'assets/images/uprofile.png')
                                              as ImageProvider,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        usergetReview[index]['name'],
                                        style: smollheader(context),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      // ),

                                      RatingBar(
                                        initialRating: double.parse(
                                            usergetReview[index]['senpai']),
                                        allowHalfRating: true,
                                        ignoreGestures: true,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemSize:
                                            MediaQuery.of(context).size.width *
                                                .06,
                                        ratingWidget: RatingWidget(
                                            full: Icon(
                                              Icons.star,
                                              color: Colors.orange,
                                            ),
                                            half: Icon(
                                              Icons.star_half,
                                              color: Colors.orange,
                                            ),
                                            empty: Icon(
                                              Icons.star_outline,
                                              color: Colors.orange,
                                            )),
                                        onRatingUpdate: (value) {
                                          // value = false;
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                // color: Colors.red,
                                width: MediaQuery.of(context).size.width * .75,
                                child: RichText(
                                    text: TextSpan(
                                        text: usergetReview[index]
                                            ['review_text'],
                                        style: TextStyle(
                                            fontSize: 13, color: black))),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
  }

  void showSnackBar() {
    final snackBar = SnackBar(
      content: Text('You have fetched all of the content'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

//-------------new api
  getReviewListApi() async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/getUserReview'));
    request.fields.addAll({
      "user_id": widget.reviewUserId,
      "page_no": "1",
      "limit": "10",
    });

    http.StreamedResponse response = await request.send();
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
      log("responseData...$responseData");
      if (responseData['status'] == 0) {
        print("Feild");
        if (mounted) {
          setState(() {
            usergetReview = [];
          });
        }
      } else if (responseData['status'] == 1) {
        print("usergetReview..$usergetReview");
        print("usergetReview..${usergetReview.length}");
        try {
          usergetReview = responseData['user_review'];
        } catch (e) {
          log("Exception...$e");
        }
      }
    } else {
      print(response.reasonPhrase);
    }
    print("reviewsad...${usergetReview.length}");

    setState(() {
      _isLoading = false;
    });
  }

  //---for pagination
  void loadMore() async {
    if (_hasNextPage == true &&
        _isLoading == false &&
        _isLoadMoreRunning == false &&
        _controller!.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      var request = http.MultipartRequest('POST',
          Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/getUserReview'));
      request.fields.addAll({
        "user_id": widget.reviewUserId,
        "page_no": _page.toString(),
        "limit": "10",
      });

      http.StreamedResponse response = await request.send();
      print("request...${request.fields}");
      if (response.statusCode == 200) {
        dynamic responseJson = await response.stream.bytesToString();
        dynamic responseData = json.decode(responseJson);

        print("load1..$responseData");
        if (responseData['status'] == 1) {
          try {
            List tempusergetReview = responseData['user_review'];
            if (tempusergetReview.length > 0) {
              setState(() {
                usergetReview.addAll(tempusergetReview);
              });
            }
          } catch (e) {
            log("Exception...$e");
          }
          String is_more_data = responseData['is_more_data'];
          print("is_more_data...$is_more_data");
          if (is_more_data == 'no') {
            showSnackBar();
            setState(() {
              _hasNextPage = false;
            });
          }
        }
      } else {
        print(response.reasonPhrase);
      }
      print("reviewsad...${usergetReview.length}");
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }




  
}
