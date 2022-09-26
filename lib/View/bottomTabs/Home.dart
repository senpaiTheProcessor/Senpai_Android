 // ignore_for_file: prefer_const_constructors, prefer_is_empty, prefer_is_not_empty, avoid_unnecessary_containers, file_names, prefer_final_fields, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, unused_element, sized_box_for_whitespace, avoid_types_as_parameter_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/ExplorDetail.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/View/Notification.dart';
import 'package:senpai/View/allCategori.dart';
import 'package:senpai/View/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/View/searchbar.dart';
import 'package:senpai/View/viewAll.dart';
import 'package:senpai/View/wallet/Wallet.dart';
import 'package:senpai/model/IntrestUserModel.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:senpai/model/bannerModel.dart';
import 'package:senpai/model/intrestModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<BannerModel> _banner = [];
  var BannerData;
  bool? _isLoading = false;
  dynamic recommendedData = [];
  String avg_rating_Rec = "0.00";
  dynamic IntrestData = [];
  List getUserData = [];
  dynamic intrestData1 = [];
  dynamic result1 = "";

  String intrestName1 = "";
  dynamic intrestData2 = [];
  String intrestName2 = "";

  dynamic intrestData3 = [];
  String intrestName3 = "";

  dynamic intrestData4 = [];
  String intrestName4 = "";

  String currentWallectBalance = "00";
  String notification_see = '';
  String blog_see = '';
  String request_see = '';
  String rate_amount = "";

  var IntrestData1;
  List<IntrestModel> _intrest = [];
  List<IntrestUserModel> _intrestUserModelList1 = [],
      _intrestUserModelList2 = [],
      _intrestUserModelList3 = [],
      _intrestUserModelList4 = [];

  String user_id = "0";
  CarouselController buttonCarouselController = CarouselController();

  int _current = 0;
  List colors = [Color(0xff407374), Color(0xff6B5761), Color(0xff4F5C86)];
  UserModel? userModel;
  FocusNode? myFocusNode;

  final FocusNode searchFocus = FocusNode();
  TextEditingController searchCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    result1 = "";
    intrestName1 = "";
    intrestName2 = "";
    intrestName3 = "";
    intrestName4 = "";
    main();
    //---Notification Code
    //seeNotifications();
    getUserModel();
    getBannerData();
    getRecommendUserList();
    getintestByUserID();
    _getUserProfileApi();

    print("securityCode...${userModel!.security_code}");
  }

  void getUserModel() async {
    if (Preference().getLoginBool(Preference.IS_LOGIN)!) {
      Map<String, dynamic> jsondatais =
          jsonDecode(Preference().getString(Preference.USER_MODEL)!);
      userModel = UserModel.fromJson(jsondatais);
      user_id = userModel!.user_id;
    } else {
      user_id = "0";
    }
    //  Preference().getString(Preference.NEW_NOTIFICATION);
  }

  void _ExploreDetailNavigatore(BuildContext context, index) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExploreDetail(
                  detailKey: recommendedData[index]['user_id'],
                  ReviewKey: false,
                  profliekey: false,
                  favirateKey: true,
                  reportkey: true,
                )));
    if (result != null) {
      _getUserProfileApi();
    }
  }

  void _ExploreDetailNavigatoreList1(BuildContext context, index) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExploreDetail(
                  detailKey: _intrestUserModelList1[index].user_id,
                  ReviewKey: false,
                  profliekey: false,
                  favirateKey: true,
                  reportkey: true,
                )));
    if (result != null) {
      _getUserProfileApi();
    }
  }

  void _ExploreDetailNavigatoreList2(BuildContext context, index) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExploreDetail(
                  detailKey: _intrestUserModelList2[index].user_id,
                  ReviewKey: false,
                  profliekey: false,
                  favirateKey: true,
                  reportkey: true,
                )));
    if (result != null) {
      _getUserProfileApi();
    }
  }

  void _ExploreDetailNavigatoreList3(BuildContext context, index) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExploreDetail(
                  detailKey: _intrestUserModelList3[index].user_id,
                  ReviewKey: false,
                  profliekey: false,
                  favirateKey: true,
                  reportkey: true,
                )));
    if (result != null) {
      _getUserProfileApi();
    }
  }

  void _ExploreDetailNavigatoreList4(BuildContext context, index) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExploreDetail(
                  detailKey: _intrestUserModelList4[index].user_id,
                  ReviewKey: false,
                  profliekey: false,
                  favirateKey: true,
                  reportkey: true,
                )));
    if (result != null) {
      _getUserProfileApi();
    }
  }

  void _walletNavigatore(BuildContext context) async {
    List<String> languageIds = [];
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Wallet()));
    if (result != null) {
      print("walletresult...$result");
      setState(() {
        currentWallectBalance = result.toString();
      });
    }
  }

  void main() {
    print(capitalize("this is a string"));
    // displays "This is a string"
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
////-------------Notification end

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
          // drawer: DrawerPage(),
          drawer: DrawerPage(),
          appBar: AppBar(
            backgroundColor: white,
            leading: Builder(builder: (BuildContext context) {
              return InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();

                    Scaffold.of(context).openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Image.asset(
                      "assets/logo/menu.png",
                      width: 10,
                      height: 10,
                    ),
                  ));
            }),
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 39,
                    width: MediaQuery.of(context).size.width * 0.05,
                    // color: Colors.cyan,
                    child: TextFormField(
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) {
                        //    getAllUserList("");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SearchPage(search: value)));
                      },
                      controller: searchCon,
                      autofocus: false,
                      focusNode: searchFocus,
                      onEditingComplete: () =>
                          {FocusScope.of(context).unfocus()},
                      style: TextStyle(
                          color: black,
                          fontSize: 14,
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: 'Search', //Lets Kill The Query',
                        hintStyle: TextStyle(
                            color: black,
                            fontSize: 12,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.w600),
                        suffixIcon: Icon(
                          Icons.search,
                          color: black,
                        ),
                        contentPadding:
                            const EdgeInsets.only(left: 10, top: 20),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: blueCom, width: 0.9),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: blueCom, width: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (() {
                    FocusScope.of(context).unfocus();
                    _walletNavigatore(context);
                  }),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          "assets/logo/wallet.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                      Text(
                        "\u20B9" +
                            (currentWallectBalance.isEmpty
                                ? "00"
                                : currentWallectBalance),
                        style: TextStyle(
                            color: blueCom,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 1, vertical: 15),
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationList()));
                    },
                    child: Badge(
                      elevation: 0,
                      badgeColor:
                          notification_see == "1" ? Colors.red : Colors.white,
                      child: Image.asset(
                        "assets/logo/bell.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: Stack(
            children: [
              allField(),
              LoaderIndicator(_isLoading!),
            ],
          )
          // bottomNavigationBar: bottomNav(),
          ),
    );
  }

  Widget allField() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
        child: Column(
          children: [
            bannerTopImage(),
            bannerTopIndicatr(),
            recommendedView(),
            categoriesView(),
            list1(),
            list2(),
            list3(),
            list4(),
          ],
        ),
      ),
    );
  }

  Widget bannerTopImage() {
    //  final double height = SizeConfig.screenHeight * 15;
    return Align(
      alignment: Alignment.center,
      child: Container(
        // height: SizeConfig.blockSizeVertical * 15,
        child: CarouselSlider(
          carouselController: buttonCarouselController,
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height / 5,

              //   height: MediaQuery.of(context).size.height ,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              autoPlay: true,
              reverse: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          items: _banner
              .map(
                (BannerModel) => Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        BannerModel.banner_image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.amber,
                            alignment: Alignment.center,
                            child: const Text(
                              'Whoops!',
                              style: TextStyle(fontSize: 30),
                            ),
                          );
                        },
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width,
                        // height: height,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget bannerTopIndicatr() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _banner.map(
        (url) {
          int index = _banner.indexOf(url);
          return Container(
            width: 10.0,
            height: 10.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index ? blueCom : Colors.grey[300],
            ),
          );
        },
      ).toList(),
    );
  }

//-----------------Recommended List Change on 4-july-2022 by Moksh Sharma----------//
  Widget recommendedView() {
    return recommendedData.length == 0
        ? Center(child: Text("No data"))
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommended",
                    style: bottomheader(context),
                  ),
                  InkWell(
                    onTap: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewALLPage(
                                    isRecommendeKey: true,
                                    inerestKey: "",
                                    inerestName: "Recommended",
                                  )));
                    }),
                    child: Text(
                      "View All",
                      style: blueheader(context),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height * .25,
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendedData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 1),
                        child: InkWell(
                          onTap: (() {
                            _ExploreDetailNavigatore(context, index);
                          }),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            width: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                                color: grayShade,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0.0, 2.0),
                                      blurRadius: 5.0,
                                      color: Colors.grey)
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.14,
                                  // width:
                                  //     MediaQuery.of(context).size.height * 0.14,
                                  decoration: BoxDecoration(
                                    color: white,
                                    border:
                                        Border.all(width: 1, color: grayShade),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: (recommendedData[index]
                                                      ['user_image']
                                                  .length >
                                              0)
                                          ? NetworkImage(
                                              recommendedData[index]
                                                  ['user_image'],
                                            )
                                          : AssetImage(
                                                  'assets/images/uprofile.png')
                                              as ImageProvider,
                                    ),
                                  ),
                                ),

                                Text(
                                  // textCapitalization: TextCapitalization.sentences
                                  capitalize(
                                      recommendedData[index]['name'].length == 0
                                          ? "N/A"
                                          : recommendedData[index]['name']),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: smollheader(context),
                                ),

                                //-----------Rate------------//
                                Text(
                                  "\u20B9"
                                          "${recommendedData[index]['rate_amount'].length == 0 ? "00.0" : recommendedData[index]['rate_amount']}" +
                                      " /min",
                                  style: smollheader(context),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 4),
                                  child: Container(
                                    //  padding: const EdgeInsets.symmetric(
                                    //         horizontal: 0, vertical: 0) ,
                                    decoration: BoxDecoration(
                                      color: white,
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xff646363),
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            getAvgRating(recommendedData[index]
                                                    ['avg_rating']
                                                .toString()),
                                            textAlign: TextAlign.center,
                                            style: verysmollheader(context),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]),
          );
  }

  String getAvgRating(String avgRating) {
    if (!avgRating.isEmpty) {
      return double.parse(avgRating).toStringAsFixed(1);
    } else {
      return "0.0";
    }
  }

  Widget categoriesView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Interest",
              style: bottomheader(context),
            ),
            InkWell(
              onTap: (() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AllCategory()));
              }),
              child: Text(
                "View All",
                style: blueheader(context),
              ),
            )
          ],
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            height: MediaQuery.of(context).size.height / 5.5,
            child: GridView.builder(
              // scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: _intrest.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  mainAxisExtent: 42),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewALLPage(
                                  inerestKey:
                                      _intrest[index].interest_id.toString(),
                                  inerestName: _intrest[index].interest_name,
                                  isRecommendeKey: false,
                                )));
                  }),
                  child: Container(
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
                        border: Border.all(width: 1, color: Color(0xff646363)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          // "Sport",
                          IntrestData[index]['interest_name'],
                          style: smollbtnWhite(context),
                        ),
                      ))),
                );
              },
            )),
      ]),
    );
  }

//-----------------List Change on 4-july-2022 by Moksh Sharma----------//

  Widget list1() {
    return _intrestUserModelList1.length == 0
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // result1['interest_name'].toString(),
                    intrestName1,
                    style: bottomheader(context),
                  ),
                  InkWell(
                    onTap: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewALLPage(
                                    inerestKey:
                                        _intrest[0].interest_id.toString(),
                                    inerestName: intrestName1,
                                    isRecommendeKey: false,
                                  )));
                    }),
                    child: Text(
                      "View All",
                      style: blueheader(context),
                    ),
                  )
                ],
              ),
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 4),
                height: MediaQuery.of(context).size.height * .25,
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _intrestUserModelList1.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 1),
                      child: InkWell(
                          onTap: (() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExploreDetail(
                                  detailKey:
                                      _intrestUserModelList1[index].user_id,
                                  ReviewKey: false,
                                  profliekey: false,
                                  favirateKey: true,
                                  reportkey: true,
                                ),
                              ),
                            );
                          }),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            width: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                                color: grayShade,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0.0, 2.0),
                                      blurRadius: 5.0,
                                      color: Colors.grey)
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.14,
                                  // width:
                                  //     MediaQuery.of(context).size.height * 0.14,
                                  decoration: BoxDecoration(
                                    color: white,
                                    border:
                                        Border.all(width: 1, color: grayShade),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _intrestUserModelList1[index]
                                                  .user_image!
                                                  .length >
                                              0
                                          ? NetworkImage(
                                              _intrestUserModelList1[index]
                                                  .user_image!,
                                            )
                                          : AssetImage(
                                                  'assets/images/uprofile.png')
                                              as ImageProvider,
                                    ),
                                  ),
                                ),

                                // //------Name-------//
                                // Text(
                                //   recommendedData[index]['name'].length == 0
                                //       ? "N/A"
                                //       : recommendedData[index]['name'],
                                //   style: smollheader(context),
                                // ),
                                //.toTitleCase()

                                Text(
                                  capitalize(
                                      _intrestUserModelList1[index].name!),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: smollheader(context),
                                ),

                                //-----------Rate------------//
                                Text(
                                  "\u20B9"
                                          "${_intrestUserModelList1[index].rate_amount!}" +
                                      " /min",
                                  // "${_intrestUserModelList1[index]['rate_amount'].length == 0 ? "00.0" : _intrestUserModelList1[index]['rate_amount']}",
                                  style: smollheader(context),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 4),
                                  child: Container(
                                    //  padding: const EdgeInsets.symmetric(
                                    //         horizontal: 0, vertical: 0) ,
                                    decoration: BoxDecoration(
                                      color: white,
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xff646363),
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            getAvgRating(
                                                _intrestUserModelList1[index]
                                                    .avg_rating!
                                                    .toString()),
                                            style: verysmollheader(context),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    );
                  },
                ),
              ),
            ]),
          );
  }

//-----------------List Change on 4-july-2022 by Moksh Sharma----------//
  Widget list2() {
    return _intrestUserModelList2.length == 0
        ? Container()
        : Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // "Entreprership",
                    intrestName2,
                    style: bottomheader(context),
                  ),
                  InkWell(
                    onTap: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewALLPage(
                            inerestKey: _intrest[1].interest_id.toString(),
                            inerestName: intrestName2,
                            isRecommendeKey: false,
                          ),
                        ),
                      );
                    }),
                    child: Text(
                      "View All",
                      style: blueheader(context),
                    ),
                  )
                ],
              ),
            ),
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 4),
              height: MediaQuery.of(context).size.height * .25,
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _intrestUserModelList2.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                    child: InkWell(
                        onTap: (() {
                          _ExploreDetailNavigatoreList2(context, index);

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ExploreDetail(
                          //             detailKey: _intrestUserModelList2[index]
                          //                 .user_id)));
                        }),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          width: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 5.0,
                                    color: Colors.grey)
                              ],
                              color: grayShade,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                // width:
                                //     MediaQuery.of(context).size.height * 0.14,
                                decoration: BoxDecoration(
                                  color: white,
                                  border:
                                      Border.all(width: 1, color: grayShade),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _intrestUserModelList2[index]
                                                .user_image!
                                                .length >
                                            0
                                        ? NetworkImage(
                                            _intrestUserModelList2[index]
                                                .user_image!,
                                          )
                                        : AssetImage(
                                                'assets/images/uprofile.png')
                                            as ImageProvider,
                                  ),
                                ),
                              ),

                              // //------Name-------//
                              // Text(
                              //   recommendedData[index]['name'].length == 0
                              //       ? "N/A"
                              //       : recommendedData[index]['name'],
                              //   style: smollheader(context),
                              // ),
                              //.toTitleCase()

                              Text(
                                capitalize(_intrestUserModelList2[index].name!),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: smollheader(context),
                              ),

                              //-----------Rate------------//
                              Text(
                                "\u20B9"
                                        "${_intrestUserModelList2[index].rate_amount!}" +
                                    " /min",
                                // "${_intrestUserModelList1[index]['rate_amount'].length == 0 ? "00.0" : _intrestUserModelList1[index]['rate_amount']}",
                                style: smollheader(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 4),
                                child: Container(
                                  //  padding: const EdgeInsets.symmetric(
                                  //         horizontal: 0, vertical: 0) ,
                                  decoration: BoxDecoration(
                                    color: white,
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xff646363),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          getAvgRating(
                                              _intrestUserModelList2[index]
                                                  .avg_rating!
                                                  .toString()),
                                          style: verysmollheader(context),
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                },
              ),
            ),
          ]);
  }

//-----------------List Change on 4-july-2022 by Moksh Sharma----------//
  Widget list3() {
    return _intrestUserModelList3.length == 0
        ? Container()
        : Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // "Mental Health / Love Relation",
                    intrestName3,
                    style: bottomheader(context),
                  ),
                  InkWell(
                    onTap: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewALLPage(
                                    inerestKey:
                                        _intrest[2].interest_id.toString(),
                                    inerestName: intrestName3,
                                    isRecommendeKey: false,
                                  )));
                    }),
                    child: Text(
                      "View All",
                      style: blueheader(context),
                    ),
                  )
                ],
              ),
            ),
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 4),
              height: MediaQuery.of(context).size.height * .25,

              alignment: Alignment.centerLeft,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _intrestUserModelList3.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                    child: InkWell(
                        onTap: (() {
                          _ExploreDetailNavigatoreList3(context, index);

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ExploreDetail(
                          //               detailKey: _intrestUserModelList3[index]
                          //                   .user_id,
                          //             )));
                        }),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          width: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 5.0,
                                    color: Colors.grey)
                              ],
                              color: grayShade,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                // width:
                                //     MediaQuery.of(context).size.height * 0.14,
                                decoration: BoxDecoration(
                                  color: white,
                                  border:
                                      Border.all(width: 1, color: grayShade),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _intrestUserModelList3[index]
                                                .user_image!
                                                .length >
                                            0
                                        ? NetworkImage(
                                            _intrestUserModelList3[index]
                                                .user_image!,
                                          )
                                        : AssetImage(
                                                'assets/images/uprofile.png')
                                            as ImageProvider,
                                  ),
                                ),
                              ),

                              Text(
                                capitalize(_intrestUserModelList3[index].name!),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: smollheader(context),
                              ),

                              //-----------Rate------------//
                              Text(
                                "\u20B9"
                                        "${_intrestUserModelList3[index].rate_amount!}" +
                                    " /min",
                                style: smollheader(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: white,
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xff646363),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          getAvgRating(
                                              _intrestUserModelList3[index]
                                                  .avg_rating!
                                                  .toString()),
                                          style: verysmollheader(context),
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                },
              ),
            ),
          ]);
  }

//-----------------List Change on 4-july-2022 by Moksh Sharma----------//
  Widget list4() {
    return _intrestUserModelList4.length == 0
        ? Container()
        : Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // "Fims / Photography",
                    intrestName4,
                    style: bottomheader(context),
                  ),
                  InkWell(
                    onTap: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewALLPage(
                                    inerestKey:
                                        _intrest[3].interest_id.toString(),
                                    inerestName: intrestName4,
                                    isRecommendeKey: false,
                                  )));
                    }),
                    child: Text(
                      "View All",
                      style: blueheader(context),
                    ),
                  )
                ],
              ),
            ),
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 4),
              height: MediaQuery.of(context).size.height * .25,
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _intrestUserModelList4.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                    child: InkWell(
                        onTap: (() {
                          _ExploreDetailNavigatoreList4(context, index);

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ExploreDetail(
                          //             detailKey: _intrestUserModelList4[index]Y
                          //                 .user_id)));
                        }),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          width: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 5.0,
                                    color: Colors.grey)
                              ],
                              color: grayShade,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                // width:
                                //     MediaQuery.of(context).size.height * 0.14,
                                decoration: BoxDecoration(
                                  color: white,
                                  border:
                                      Border.all(width: 1, color: grayShade),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _intrestUserModelList4[index]
                                                .user_image!
                                                .length >
                                            0
                                        ? NetworkImage(
                                            _intrestUserModelList4[index]
                                                .user_image!,
                                          )
                                        : AssetImage(
                                                'assets/images/uprofile.png')
                                            as ImageProvider,
                                  ),
                                ),
                              ),

                              // //------Name-------//
                              // Text(
                              //   recommendedData[index]['name'].length == 0
                              //       ? "N/A"
                              //       : recommendedData[index]['name'],
                              //   style: smollheader(context),
                              // ),
                              //.toTitleCase()

                              Text(
                                capitalize(_intrestUserModelList4[index].name!),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: smollheader(context),
                              ),

                              //-----------Rate------------//
                              Text(
                                "\u20B9"
                                        "${_intrestUserModelList4[index].rate_amount!}" +
                                    " /min",
                                // "${_intrestUserModelList1[index]['rate_amount'].length == 0 ? "00.0" : _intrestUserModelList1[index]['rate_amount']}",
                                style: smollheader(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 4),
                                child: Container(
                                  //  padding: const EdgeInsets.symmetric(
                                  //         horizontal: 0, vertical: 0) ,
                                  decoration: BoxDecoration(
                                    color: white,
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xff646363),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          getAvgRating(
                                              _intrestUserModelList4[index]
                                                  .avg_rating!
                                                  .toString()),
                                          style: verysmollheader(context),
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                },
              ),
            ),
          ]);
  }

//------- banner Api------
  getBannerData() async {
    setState(() {
      _isLoading = true;
    });
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST', Uri.parse('${APIConstants.senpaiBaseUrl}user/getBanner'));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      dynamic responseJson = await response.stream.bytesToString();
      dynamic BannerData = json.decode(responseJson);
      BannerData = BannerData['banner'];
      print("BannerData....${responseJson}");
      print("BannerData....${BannerData}");

      print(BannerData);
      for (int i = 0; i < BannerData.length; i++) {
        var bannerDataList = BannerData[i];

        BannerModel bannerModel = BannerModel(
            bannerDataList['banner_id'], bannerDataList['banner_image']);
        _banner.add(bannerModel);
      }
    } else {
      print(response.reasonPhrase);
    }
  }

//------------get recommended Api------------
  getRecommendUserList() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    var user = UserModel.fromJson(jsondatais);

    var request = http.MultipartRequest('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getRecommendedList'));
    request.fields.addAll({
      "user_id": user.user_id,
      "security_code": user.security_code,
    });

    http.StreamedResponse response = await request.send();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
      print("commentList...$responseData");
      if (responseData['status'] == 0) {
        setState(() {
          _isLoading = false;
        });
        print("Feild");
        if (mounted) {
          setState(() {
            recommendedData = [];
          });
        }
      } else if (responseData['status'] == 1) {
        setState(() {
          _isLoading = false;
        });
        print("getUserData$recommendedData");
        if (mounted) {
          setState(() {
            recommendedData = responseData['recommended'];
            // pr
            // (userModel.)
            print("recommenddata$recommendedData");
            print("recommenddata${recommendedData[0]['user_id']}");
            avg_rating_Rec =
                double.parse(responseData['recommended'][0]['avg_rating'])
                    .toStringAsFixed(2);

            print("recommenddata${recommendedData[0]['user_image']}");
          });
        }
      }else if (responseData['status'] == 6) {
          var baseDialog1 = BaseAlertDialog(
            title: "Your account has been login by another device.",
            content: "Please logout account another device",
            yesOnPressed: () async {
              Preference().setLoginBool(Preference.IS_LOGIN, false);
              SharedPreferences userData =
                  await SharedPreferences.getInstance();
              await userData.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Login(),
                ),
                (route) => false,
              );
            },
            noOnPressed: () {
              // Navigator.pop(context);
            },
            yes: "Ok ",
            no: " ",
          );
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => baseDialog1);
        }
    } else {
      print(response.reasonPhrase);
    }
    print("datas...${recommendedData.length}");
  }

// get all users by interest id...
  _getIntrestApi1(int index, String interestId) async {
    setState(() {
      _isLoading = true;
    });
    print("res...$index");
    print("res_int...$interestId");
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getUserByCategory'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "interest_id": interestId
      },
    ).then(
      (response) async {
        dynamic res = json.decode(response.body);
        print("fds$res");

        String mgs = res['message'];
        if (res['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          try {
            if (index == 0) {
              setState(() {
                intrestName1 = res['interest_name'];
              });
              _intrestUserModelList1 = (res['user_list'] as List)
                  .map((itemWord) => IntrestUserModel.fromJson(itemWord))
                  .toList();
            } else if (index == 1) {
              setState(() {
                intrestName2 = res['interest_name'];
              });
              _intrestUserModelList2 = (res['user_list'] as List)
                  .map((itemWord) => IntrestUserModel.fromJson(itemWord))
                  .toList();
            } else if (index == 2) {
              setState(() {
                intrestName3 = res['interest_name'];
              });
              _intrestUserModelList3 = (res['user_list'] as List)
                  .map((itemWord) => IntrestUserModel.fromJson(itemWord))
                  .toList();
            } else if (index == 3) {
              setState(() {
                intrestName4 = res['interest_name'];
              });
              _intrestUserModelList4 = (res['user_list'] as List)
                  .map((itemWord) => IntrestUserModel.fromJson(itemWord))
                  .toList();
            }
          } catch (e) {
            print("Exception....");
          }
        } else if (res['status'] == 5) {
          setState(() {
            _isLoading = false;
          });
          var baseDialog = BaseAlertDialog(
            title: "Your account has been blocked by the Senpai admin.",
            content: "Please connect with the Senapi support",
            yesOnPressed: () async {
              Navigator.pop(context);
              //  Navigator.pop(context);
              Preference().setLoginBool(Preference.IS_LOGIN, false);
              //  Preference().setString(Preference.CURRENT_BALANCE, "00");
              SharedPreferences userData =
                  await SharedPreferences.getInstance();
              await userData.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Login(),
                ),
                (route) => false,
              );
            },
            noOnPressed: () {
              // Navigator.pop(context);
            },
            yes: "Ok",
            no: " ",
          );
          showDialog(
              context: context, builder: (BuildContext context) => baseDialog);
        } else if (res['status'] == 6) {
          var baseDialogTwo = BaseAlertDialog(
            title: "Your account has been login by another device.",
            content: "Please logout account another device",
            yesOnPressed: () async {
              Preference().setLoginBool(Preference.IS_LOGIN, false);
              SharedPreferences userData =
                  await SharedPreferences.getInstance();
              await userData.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Login(),
                ),
                (route) => false,
              );
            },
            noOnPressed: () {
              // Navigator.pop(context);
            },
            yes: "Ok ",
            no: " ",
          );
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => baseDialogTwo);
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(mgs),
            ),
          );
        }
      },
    );
  }

  // logoutAlert() {
  //   var baseDialog = BaseAlertDialog(
  //     title: "Logout",
  //     content: "Do you want to logout?",
  //     yesOnPressed: () async {
  //       Navigator.pop(context);
  //       //  Navigator.pop(context);
  //       Preference().setLoginBool(Preference.IS_LOGIN, false);
  //       //  Preference().setString(Preference.CURRENT_BALANCE, "00");
  //       SharedPreferences userData = await SharedPreferences.getInstance();
  //       await userData.clear();
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (BuildContext context) => Login(),
  //         ),
  //         (route) => false,
  //       );
  //     },
  //     noOnPressed: () {
  //       Navigator.pop(context);
  //     },
  //     yes: "Confirm",
  //     no: "Cancel",
  //   );
  //   showDialog(context: context, builder: (BuildContext context) => baseDialog);
  // }
 
  logoutAlert() {
    var baseDialog = BaseAlertDialog(
      title: "Logout",
      content: "Do you want to logout?",
      yesOnPressed: () async {
        Navigator.pop(context);
        //  Navigator.pop(context);
        Preference().setLoginBool(Preference.IS_LOGIN, false);
        //  Preference().setString(Preference.CURRENT_BALANCE, "00");
        SharedPreferences userData = await SharedPreferences.getInstance();
        await userData.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Login(),
          ),
          (route) => false,
        );
      },
      noOnPressed: () {
        Navigator.pop(context);
      },
      yes: "Confirm",
      no: "Cancel",
    );
    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  //  ------------get All Interests------------------
  void getintestByUserID() async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getInterest');
    var response =
        await http.post(url, body: {"user_id": user_id, "search_text": ""});
    dynamic res = json.decode(response.body.toString());
    print("res..$res");
    IntrestData = res['interest'];
    _intrest = (res['interest'] as List)
        .map((itemWord) => IntrestModel.fromJson(itemWord))
        .toList();

List<IntrestModel>  _tempIntrestModel= _intrest.where((o) => o.is_selected == "0").toList();


_intrest= _intrest.where((o) => o.is_selected == "1").toList();
_intrest.addAll(_tempIntrestModel);

print('shorting....$_intrest');
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }


    List<dynamic> getCategoryList(List<dynamic> _intrest) {
    List outputList = _intrest.where((o) => o['is_selected'] == "1").toList();
    print('getCategoey order: $outputList');

    return outputList;
  }
    //_intrest.sort();
    print('ascending order: ${_intrest.toString()}');
    print("IntrestData2...${_intrest.toString()}");

    if (_intrest.length > 0) {
      for (var i = 0; i < _intrest.length; i++) {

        print("intrest...${_intrest[i].interest_id.toString()}");
        _getIntrestApi1(i, _intrest[i].interest_id.toString());
      }
    }
  }

  _getUserProfileApi() async {
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/getUserProfile'),
      body: {"user_id": userModel!.user_id, "session_user_id": ""},
    ).then(
      (response) {
        dynamic responce = json.decode(response.body);
        print("currentWallectBalance...$responce");

        currentWallectBalance = responce['user_detail']['user_wallet_balance'];
        notification_see = responce['user_detail']['new_notification'];
        rate_amount = responce['user_detail']['rate_amount'];
        blog_see = responce['user_detail']['new_blog'];
        request_see = responce['user_detail']['new_request'];

        Preference().setString(Preference.NEW_BLOG, blog_see);
        Preference().setString(Preference.NEW_REQUEST, request_see);
        print("currentWallectBalance...$currentWallectBalance");
        Preference().setString(Preference.NEW_NOTIFICATION, notification_see);
        Preference()
            .setString(Preference.CURRENT_BALANCE, currentWallectBalance);
        Preference().setString(Preference.RATE_AMMOUNT, rate_amount);

        setState(() {});
      },
    );
  }

  getAllUserList(String intrest_id) async {
    setState(() {
      _isLoading = true;
    });
    print("intrest_id..$intrest_id");
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    var user = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      // print("interestID...${user.interest[1]['interest_id']}");
    }
    var request = http.MultipartRequest(
        'POST', Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getAllUser'));
    request.fields.addAll({
      "user_id": user.user_id,
      "security_code": user.security_code,
      "search_text": searchCon.text,
      "interest_id": "0",
      "rates": "0",
      "calls": "0",
      "rating": "0",
      "page_no": "1",
      "limit": '10',
    });

    http.StreamedResponse response = await request.send();
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
      print("commentList...$responseData");
      if (responseData['status'] == 0) {
        print("Feild");
        if (mounted) {
          setState(() {
            getUserData = [];
          });
        }
      } else if (responseData['status'] == 1) {
        print("getUserData$getUserData");
        if (mounted) {
          setState(() {
            getUserData = responseData['user_list'];
          });
        }
      }else if (responseData['status'] == 6) {
          var baseDialog1 = BaseAlertDialog(
            title: "Your account has been login by another device.",
            content: "Please logout account another device",
            yesOnPressed: () async {
              Preference().setLoginBool(Preference.IS_LOGIN, false);
              SharedPreferences userData =
                  await SharedPreferences.getInstance();
              await userData.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Login(),
                ),
                (route) => false,
              );
            },
            noOnPressed: () {
              // Navigator.pop(context);
            },
            yes: "Ok ",
            no: " ",
          );
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => baseDialog1);
        }
    } else {
      print(response.reasonPhrase);
    }
  }

  
}