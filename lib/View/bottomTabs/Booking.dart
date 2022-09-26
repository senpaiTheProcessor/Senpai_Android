// ignore_for_file: prefer_const_constructors, prefer_final_fields, constant_identifier_names, prefer_const_literals_to_create_immutables, file_names, unrelated_type_equality_checks, prefer_is_empty, avoid_print, sized_box_for_whitespace, non_constant_identifier_names, unused_local_variable, unnecessary_brace_in_string_interps, unused_field, unnecessary_new
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:senpai/Call/CallScreen.dart';
import 'package:senpai/Call/agora.config.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/ExplorDetail.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/View/Notification.dart';
import 'package:senpai/View/drawer.dart';
import 'package:senpai/View/searchbar.dart';
import 'package:senpai/View/wallet/Wallet.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:senpai/model/receviedModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Common/Button.dart';
import '../../Common/colors.dart';
import 'package:http/http.dart' as http;

class Booking extends StatefulWidget {
  final dynamic tabBarIndex;
  final dynamic dataSchedele;
  const Booking({Key? key, this.tabBarIndex, this.dataSchedele})
      : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

enum all { All, Pending, Rejected, Accepted }

enum STATUS { Pending, Rejected, Accepted }

class _BookingState extends State<Booking> with SingleTickerProviderStateMixin {
  StateSetter? _setState;

  void main() {
    print(capitalize("this is a string"));
    // displays "This is a string"
  }

  dynamic agora_Server_Id = "";
  dynamic agora_Server_Channel = "";
  dynamic agora_Server_token = "";
  dynamic agora_Server_Certificate = "";
  String vStartTime = "00:00:00";

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  List getUserData = [];

  FocusNode? myFocusNode;
  String currentWallectBalance = "00";
  String notification_see = '';
  String blog_see = '';
  String request_see = '';
  String rate_amount = "";

  final FocusNode searchFocus = FocusNode();
  TextEditingController searchCon = TextEditingController();

  TextEditingController teacherCon = TextEditingController();

  ValueNotifier<all> _selectedItem = ValueNotifier<all>(all.Pending);
  String date = "";
  DateTime selectedDate = DateTime.now();
  String time = "";
  TimeOfDay selectedTime = TimeOfDay(hour: 0, minute: 0);

  String request_status = "";
  String filterByStutus = "";
  String call_reciver_id = "";
  int selectedTab = 0;
  bool? _isLoading = false;

  int _page = 1;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  // bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;
  ScrollController? _controller1;
  ScrollController? _controller2;

  ScrollController? _controller3;

  ScrollController? _controller4;
//------Date picker
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 1)), //DateTime(2022),
      lastDate: DateTime(2032),
    );
    if (selected != null && selected != selectedDate)
      // ignore: curly_braces_in_flow_control_structures
      _setState!(() {
        selectedDate = selected;
        print("selectedDate$selectedDate");
      });
    date = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
  }

//-----Time Picker
  _selectedTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      // vStartTime="";
      _setState!(() {
        selectedTime = timeOfDay;
        vStartTime =
            "${(selectedTime.hour)}" + ":${(selectedTime.minute)}" + ":00";
      });
      // time = "${selectedTime.hour}"+":${selectedTime.minute}"+":00";
      print("time....$vStartTime");
    }
  }

//----Get User
  UserModel? userModel;
  List<ReciviedModel> _recivedModelList = [];
  List<ReciviedModel> _sentRequestList = [];
  List<ReciviedModel> _callHistory = [];
  List<ReciviedModel> _guidenowlist = [];

  List usersList = [];
  void getUserModel() async {
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    userModel = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print("userName...${userModel!.user_id}");
    }
  }

  TabController? _tabController;
 String tdata = DateFormat("HH:mm:ss").format(DateTime.now());

  @override
  void initState() {
    super.initState();
    print("tdata...$tdata");
    print("prun..${Preference().getString(Preference.RATE_AMMOUNT)}");
    // print("prun..${userModel!.rate_amount}");

    main();
    _tabController = new TabController(
        initialIndex: widget.tabBarIndex, vsync: this, length: 4);
    getUserModel();
    getTokenApi(); //Token Api call
    seeBadgeAll();
    // getUserList();
    _getsenRequestApi();

    _getRecivedApi();
    _getcallHistoryApi();
    _getguideApi();
    _getUserProfileApi();
    agora_Server_Id = "";
    agora_Server_Channel = "";
    agora_Server_token = "";
    agora_Server_Certificate = "";
    usersList = [];
    request_status = "";
    call_reciver_id = " ";
    _controller1 = ScrollController()..addListener(_senRequestApiloadMore1);
    _controller2 = ScrollController()..addListener(_senRecivedloadMore);
    _controller3 = ScrollController()..addListener(_sencallhistoryloadMore);

    _controller4 = ScrollController()..addListener(_senguideLoadMore);
  }

  @override
  void dispose() {
    _tabController!.dispose();

    _controller1!.removeListener(_senRequestApiloadMore1);
    _controller2!.removeListener(_senRecivedloadMore);
    _controller3!.removeListener(_sencallhistoryloadMore);

    _controller4!.removeListener(_senguideLoadMore);

    // _controller2!.removeListener(_loadMore2);

    super.dispose();
  }

  String convertNewDate(String date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateFormat dateFormat1 = DateFormat('hh:mm a');
    DateTime dateTime = formatter.parse(date);
    return dateFormat1.format(dateTime);
    // final String formatted = formatter.format(now);
    // print(formatted);
    // return formatted;
  }

  // String converDateTime(String dateStr) {
  //   DateFormat dateFormat = DateFormat("HH:mm:ss");
  //   DateFormat dateFormat1 = DateFormat('hh:mm a');
  //   DateTime dateTime = dateFormat.parse(dateStr);
  //   return dateFormat1.format(dateTime);
  // }
  String convertDateIntoFormat(String date) {
    final DateTime parseDateTime = DateTime.parse(date);
    // final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateFormat formatter1 = DateFormat('dd MMM');
    final String formattedDate = formatter1.format(parseDateTime);
    print(formattedDate);
    return formattedDate;
  }

  String convertDateIntoDateFormat(String date) {
    final DateTime parseDateTime = DateTime.parse(date);
    // final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
    final String formattedDate = formatter1.format(parseDateTime);
    print(formattedDate);
    return formattedDate;
  }

  String convertDateIntoTimeFormat(String date) {
    final DateTime parseDateTime = DateTime.parse(date);
    // final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateFormat formatter1 = DateFormat('hh:mm a');
    final String formattedDate = formatter1.format(parseDateTime);
    print(formattedDate);
    return formattedDate;
  }

  String converDateTime(String dateStr) {
    DateFormat dateFormat = DateFormat("HH:mm:ss");
    DateFormat dateFormat1 = DateFormat('hh:mm a');
    DateTime dateTime = dateFormat.parse(dateStr);
    return dateFormat1.format(dateTime);
  }

//  String convertDateIntoTimeFormat2(String date) {
//     final DateTime parseDateTime = DateTime.parse(date);
//     final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
//     final DateFormat formatter1 = DateFormat('hh:mm a');
//     final String formattedDate = formatter1.format(parseDateTime);
//     print("sfdg$formattedDate");
//     return formattedDate;
//   }

  //   String convertDateTime(String vCreateTime) {
  //   // var dateTime =
  //   //     DateFormat("yyyy-MM-dd HH:mm:ss").parse("2022-07-04 08:51:57", true);
  //   var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss")
  //   return DateFormat('dd MMM,hh:mm a')
  // }

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

  ////---------see all request
  seeBadgeAll() async {
    var request = http.MultipartRequest('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/updateBadge'));
    request.fields
        .addAll({'user_id': userModel!.user_id, 'badge_type': 'new_request'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
      print("see new_request.....$responseData");
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
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
            title: Row(children: [
              Expanded(
                child: Container(
                  height: 36,
                  child: TextFormField(
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (value) {
                      //    getAllUserList("");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPage(search: value)));
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
                      hintText: 'Search',
                      hintStyle: TextStyle(
                          color: black,
                          fontSize: 12,
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.w600),
                      suffixIcon: Icon(
                        Icons.search,
                        color: black,
                      ),
                      contentPadding: const EdgeInsets.only(left: 8, top: 20),
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
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => Wallet()));
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
              InkWell(
                onTap: (() {
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationList()));
                }),
                child: Badge(
                  elevation: 0,
                  badgeColor:
                      notification_see == "1" ? Colors.red : Colors.white,
                  child: Image.asset(
                    "assets/logo/bell.png",
                    //width: 20,
                    height: 20,
                  ),
                ),
              ),
            ])),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: <Widget>[
                  ButtonsTabBar(
                    controller: _tabController,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    backgroundColor: blueCom,
                    unselectedBackgroundColor: white,
                    unselectedLabelStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    radius: 100,
                    unselectedBorderColor: black,
                    borderColor: Colors.transparent,
                    borderWidth: 1,
                    onTap: (index) {
                      //your currently selected index
                      setState(() {
                        selectedTab = index;
                      });

                      print("i..${index}");
                    },
                    tabs: [
                      Tab(
                        text: "Sent",
                      ),
                      Tab(
                        text: "Received",
                      ),
                      Tab(
                        text: "Call History",
                      ),
                      Tab(
                        text: "Guide Now",
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        sentAll(),
                        recivedListAll(),
                        callHistoryList(),
                        guideNowListAll()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sentAll() {
    return Column(
      children: [allDropDown(), Expanded(child: sentList())],
    );
  }

  Widget recivedListAll() {
    return Column(
      children: [allDropDown(), Expanded(child: recivedList())],
    );
  }

  Widget callHistoryAll() {
    return Column(
      children: [allDropDown(), Expanded(child: callHistoryList())],
    );
  }

  Widget guideNowListAll() {
    return Column(
      children: [Expanded(child: guideNowList())],
    );
  }

// recived List
  Widget recivedList() {
    // setState(() {
    //   selectedTab == 1;
    // });
    return _recivedModelList.length == 0
        ? Center(child: Text("You have no Received Request."))
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                controller: _controller2,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _recivedModelList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                    child: InkWell(
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExploreDetail(
                                    detailKey: _recivedModelList[index].user_id,
                                    ReviewKey: false,
                                    favirateKey: true,
                                    reportkey: true,
                                    profliekey: true)));
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: borderColor),
                            color: grayShade,
                            // color:Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.14,
                              width: MediaQuery.of(context).size.height * 0.14,
                              decoration: BoxDecoration(
                                color: white,
                                border: Border.all(width: 1, color: grayShade),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _recivedModelList[index]
                                                .user_image!
                                                .length >
                                            0
                                        ? NetworkImage(
                                            _recivedModelList[index]
                                                .user_image!,
                                          )
                                        : AssetImage(
                                                'assets/images/uprofile.png')
                                            as ImageProvider),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              // height: MediaQuery.of(context).size.width * 0.3,
                              // color: Colors.red,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    capitalize(_recivedModelList[index].name!),
                                    style: smollheader(context),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.00,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Interest:- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: _recivedModelList[index]
                                                .interest_name!,
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.00,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Question :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: capitalize(
                                                _recivedModelList[index]
                                                    .question!),
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.00,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Call Date :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: convertDateIntoDateFormat(
                                                _recivedModelList[index]
                                                        .request_date! +
                                                    " " +
                                                    _recivedModelList[index]
                                                        .request_time!),
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.00,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Shedule Time :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: convertDateIntoTimeFormat(
                                                _recivedModelList[index]
                                                        .request_date! +
                                                    " " +
                                                    _recivedModelList[index]
                                                        .request_time!),
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.00,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Request Time :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: convertNewDate(
                                                _recivedModelList[index]
                                                    .created!),
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.width * 0.3,
                              child: Column(
                                children: [
                                  (_recivedModelList[index]
                                              .request_status
                                              .toString()
                                              .endsWith("1") ||
                                          _recivedModelList[index]
                                              .request_status
                                              .toString()
                                              .endsWith("3") ||
                                          _recivedModelList[index]
                                              .request_status
                                              .toString()
                                              .endsWith("5"))
                                      ? Center(
                                          child: Text(
                                            _recivedModelList[index]
                                                    .request_status
                                                    .toString()
                                                    .endsWith("1")
                                                ? "Accepted"
                                                : (_recivedModelList[index]
                                                        .request_status
                                                        .toString()
                                                        .endsWith("5"))
                                                    ? "Completed"
                                                    : "Rejected",
                                            style: verysmollheader(context)
                                                .copyWith(
                                                    color: _recivedModelList[
                                                                index]
                                                            .request_status
                                                            .toString()
                                                            .endsWith("1")
                                                        ? Colors.green
                                                        : (_recivedModelList[
                                                                    index]
                                                                .request_status
                                                                .toString()
                                                                .endsWith("5"))
                                                            ? Colors.blueAccent
                                                            : Colors.redAccent,
                                                    fontSize: 12),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  _recivedModelList[index]
                                          .request_status
                                          .toString()
                                          .endsWith("0")
                                      ? InkWell(
                                          onTap: (() {
                                            accpectDialog(1,
                                                index); // 1 for accept 3 - reject
                                          }),
                                          child: Container(
                                            // height: MediaQuery.of(context)
                                            //         .size
                                            //         .height *
                                            //     0.03,
                                            // width: MediaQuery.of(context)
                                            //         .size
                                            //         .width *
                                            //     0.25,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                // border: Border.all(width: 1, color: Color(0xff646363)),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                )),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 4),
                                                child: Text(
                                                  "Accept",
                                                  style:
                                                      verysmollheader(context)
                                                          .copyWith(
                                                              color:
                                                                  Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  _recivedModelList[index]
                                          .request_status
                                          .toString()
                                          .endsWith("0")
                                      ? InkWell(
                                          onTap: (() {
                                            accpectDialog(3,
                                                index); // 1 for accept 3 - reject
                                          }),
                                          child: Container(
                                            // height: MediaQuery.of(context)
                                            //         .size
                                            //         .height *
                                            //     0.03,
                                            // width: MediaQuery.of(context)
                                            //         .size
                                            //         .width *
                                            //     0.25,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                //  border: Border.all(width: 1, color: Color(0xff646363)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 4),
                                                child: Text(
                                                  "Reject",
                                                  style:
                                                      verysmollheader(context)
                                                          .copyWith(
                                                              color:
                                                                  Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
  }

// guided now List
  Widget guideNowList() {
    // setState(() {
    //   selectedTab == 3;
    // });
    return _guidenowlist.length == 0
        ? Center(child: Text("You have no guide now data."))
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                controller: _controller4,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _guidenowlist.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                    child: InkWell(
                      onTap: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExploreDetail(
                              detailKey: _guidenowlist[index].user_id,
                              ReviewKey: false,
                              profliekey: false,
                              favirateKey: true,
                              reportkey: true,
                              receiver_Id: _recivedModelList[index].user_id,
                              request_Id:
                                  _recivedModelList[index].user_request_id,
                              user_request_Id: _recivedModelList[index].user_id,
                            ),
                          ),
                        );
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: borderColor),
                            color: grayShade,
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.18,
                              width: MediaQuery.of(context).size.height * 0.14,
                              decoration: BoxDecoration(
                                color: white,
                                border: Border.all(width: 1, color: grayShade),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _guidenowlist[index]
                                                .user_image!
                                                .length >
                                            0
                                        ? NetworkImage(
                                            _guidenowlist[index].user_image!,
                                          )
                                        : AssetImage(
                                                'assets/images/uprofile.png')
                                            as ImageProvider),
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              // color: Colors.red,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    capitalize(_guidenowlist[index].name!),
                                    style: smollheader(context),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Interest :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: capitalize(
                                                _guidenowlist[index]
                                                    .interest_name!),
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Question :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: capitalize(
                                                _guidenowlist[index].question!),
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Schedule Date :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: convertDateIntoDateFormat(
                                                _guidenowlist[index]
                                                        .request_date! +
                                                    " " +
                                                    _guidenowlist[index]
                                                        .request_time!),
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Schedule Time :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: convertDateIntoTimeFormat(
                                                _guidenowlist[index]
                                                        .request_date! +
                                                    " " +
                                                    _guidenowlist[index]
                                                        .request_time!),
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Request Time :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: convertNewDate(
                                                _guidenowlist[index].created!),
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Note :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: _guidenowlist[index]
                                                .teacher_note!,
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (() {
                                dynamic vJsonOBJ = {
                                  "user_id": userModel?.user_id,
                                  "channel_name": channelId,
                                  "caller_name": userModel?.name,
                                  "receiver_name":
                                      _recivedModelList[index].name,
                                  "message":
                                      "Join call with channel name:- $channelId",
                                  "device_token": (userModel?.user_id !=
                                          _recivedModelList[index].teacher_id)
                                      ? _recivedModelList[index].device_token
                                      : _recivedModelList[index].t_device_token,
                                  // _recivedModelList[index].t_device_token,
                                  "request_id":
                                      _recivedModelList[index].user_request_id,
                                  "user_request_id":
                                      _recivedModelList[index].user_id,
                                  "receiver_id":
                                      _recivedModelList[index].teacher_id,
                                  "rate_amount": Preference().getString(Preference
                                      .RATE_AMMOUNT), // userModel?.rate_amount,
                                  "receiver_image":
                                      _recivedModelList[index].user_image,
                                  "sender_image": userModel?.user_image,
                                  "user_wallet_balance":
                                      _recivedModelList[index]
                                          .user_wallet_balance,
                                  "app_id": agora_Server_Id,
                                  "aap_channel": agora_Server_Channel,
                                  "aap_token": agora_Server_token,
                                };
                                print("vJsonOBJ.... ${vJsonOBJ},");

                                messageApi(
                                    index); // send notification to receiver

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CallScreen(
                                        userData: vJsonOBJ, is_from: true),
                                  ),
                                );
                              }),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 2),
                                child: Container(
                                  // height:
                                  //     MediaQuery.of(context).size.height * 0.03,
                                  // width:
                                  //     MediaQuery.of(context).size.width * 0.25,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      // border: Border.all(width: 1, color: Color(0xff646363)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.call,
                                          size: 15,
                                          color: white,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "Call Now",
                                          style: verysmollheader(context)
                                              .copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
  }

//  sent List
  Widget sentList() {
    return _sentRequestList.length == 0
        ? Center(child: Text("You havn't Sent any Request."))
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                controller: _controller1,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _sentRequestList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                    child: InkWell(
                      onTap: (() {}),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: borderColor),
                            color: grayShade,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.14,
                                    width: MediaQuery.of(context).size.height *
                                        0.14,
                                    decoration: BoxDecoration(
                                      color: white,
                                      border: Border.all(
                                          width: 1, color: grayShade),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: _sentRequestList[index]
                                                      .t_user_image!
                                                      .length >
                                                  0
                                              ? NetworkImage(
                                                  _sentRequestList[index]
                                                      .t_user_image!,
                                                )
                                              : AssetImage(
                                                      'assets/images/uprofile.png')
                                                  as ImageProvider),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      // color: Colors.red,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            // "Jhon Smith",
                                            capitalize(_sentRequestList[index]
                                                .t_name!),
                                            style: smollheader(context),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Interest :- ',
                                              style: smollheader(context),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        _sentRequestList[index]
                                                            .interest_name!,
                                                    style: smollheaderlight(
                                                        context)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Question :- ',
                                              style: smollheader(context),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: capitalize(
                                                        _sentRequestList[index]
                                                            .question!),
                                                    style: smollheaderlight(
                                                        context)),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: 5,
                                          // ),
                                          // Container(
                                          //   width: MediaQuery.of(context)
                                          //           .size
                                          //           .width *
                                          //       0.4,
                                          //   child: RichText(
                                          //     text: TextSpan(
                                          //       text: 'Note :- ',
                                          //       style: smollheader(context),
                                          //       children: <TextSpan>[
                                          //         TextSpan(
                                          //             text: _sentRequestList[
                                          //                     index]
                                          //                 .note!,
                                          //             style: smollheaderlight(
                                          //                 context)),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Time :- ',
                                              style: smollheader(context),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: "${convertDateIntoFormat(_sentRequestList[index].request_date!)}" +
                                                      " ${converDateTime(_sentRequestList[index].request_time!)}",
                                                  style:
                                                      smollheaderlight(context),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Text( _sentRequestList[index]
                                  //                           .request_status!),
                                  InkWell(
                                    onTap: (() {
                                      //  onPressed: isJoined ? _leaveChannel : _joinChannel;
                                    }),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        // height:
                                        //     MediaQuery.of(context).size.height *
                                        //         0.03,
                                        // width: MediaQuery.of(context).size.width *
                                        //     0.2,

                                        decoration: BoxDecoration(
                                            //color: Colors.green,
                                            color: (_sentRequestList[index]
                                                    .request_status!
                                                    .trim()
                                                    .endsWith("0")
                                                ? Colors.orange //"Pending"
                                                : (_sentRequestList[index]
                                                        .request_status!
                                                        .trim()
                                                        .endsWith("1")
                                                    ? Colors.green // "Accepted"
                                                    : (_sentRequestList[index]
                                                            .request_status!
                                                            .trim()
                                                            .endsWith("3")
                                                        ? Colors
                                                            .red // "Rejected"
                                                        : Colors
                                                            .orange))), //"Pending"))),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          child: Text(
                                            (_sentRequestList[index]
                                                    .request_status!
                                                    .trim()
                                                    .endsWith("0")
                                                ? "Pending"
                                                : (_sentRequestList[index]
                                                        .request_status!
                                                        .trim()
                                                        .endsWith("1")
                                                    ? "Accepted"
                                                    : (_sentRequestList[index]
                                                            .request_status!
                                                            .trim()
                                                            .endsWith("3")
                                                        ? "Rejected"
                                                        : "Pending"))),
                                            style: verysmollheader(context)
                                                .copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
  }

  Widget sentAcceptBtn(int index) {
    return InkWell(
      onTap: () {
        dynamic vJsonOBJ = {
          "user_id": userModel?.user_id,
          "channel_name": channelId,
          "caller_name": userModel?.name,
          "receiver_name": _recivedModelList[index].name,
          "message": "Join call with channel name:- $channelId",
          "device_token":
              (userModel?.user_id != _recivedModelList[index].teacher_id)
                  ? _recivedModelList[index].device_token
                  : _recivedModelList[index].t_device_token,
          // _recivedModelList[index].t_device_token,
          "request_id": _recivedModelList[index].user_request_id,
          "user_request_id": _recivedModelList[index].user_id,
          "receiver_id": _recivedModelList[index].teacher_id,
          "rate_amount": Preference()
              .getString(Preference.RATE_AMMOUNT), //userModel?.rate_amount,
          "receiver_image": _recivedModelList[index].user_image,
          "sender_image": userModel?.user_image,
          // "user_wallet_balance":_recivedModelList[index].user_wallet_balance
          "app_id": agora_Server_Id,
          "aap_channel": agora_Server_Channel,
          "aap_token": agora_Server_token,
        };
        print("vJsonOBJ.... ${vJsonOBJ},");

        messageApi(index); // send notification to receiver

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(userData: vJsonOBJ, is_from: true),
          ),
        );
      },
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.04,
          width: MediaQuery.of(context).size.width * 0.40,
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.call,
                size: 15,
                color: white,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "Call Now",
                style: verysmollheader(context)
                    .copyWith(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

// call History List

  Widget callHistoryList() {
    // setState(() {
    //   selectedTab == 2;
    // });
    return _callHistory.length == 0
        ? Center(child: Text("You have no call history."))
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                controller: _controller3,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount:
                    _callHistory.length != null ? _callHistory.length : 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                    child: InkWell(
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExploreDetail(
                                      profliekey: false,
                                      favirateKey: true,
                                      reportkey: true,
                                      detailKey: (userModel!.user_id ==
                                              _callHistory[index].user_id)
                                          ? _callHistory[index].teacher_id
                                          : _callHistory[index].user_id,
                                      ReviewKey: true,
                                      request_Id:
                                          _callHistory[index].user_request_id,
                                      user_request_Id:
                                          _callHistory[index].user_request_id,
                                      receiver_Id: (userModel!.user_id ==
                                              _callHistory[index].user_id)
                                          ? _callHistory[index].teacher_id
                                          : _callHistory[index].user_id,
                                    )));
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: borderColor),
                            color: grayShade,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width:
                                    MediaQuery.of(context).size.height * 0.14,
                                decoration: BoxDecoration(
                                  color: white,
                                  border:
                                      Border.all(width: 1, color: grayShade),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: (userModel!.user_id ==
                                            _callHistory[index].user_id)
                                        ? _callHistory[index]
                                                    .t_user_image!
                                                    .length >
                                                0
                                            ? NetworkImage(
                                                _callHistory[index]
                                                    .t_user_image!,
                                              )
                                            : AssetImage(
                                                    'assets/images/uprofile.png')
                                                as ImageProvider
                                        : _callHistory[index]
                                                    .user_image!
                                                    .length >
                                                0
                                            ? NetworkImage(
                                                _callHistory[index].user_image!,
                                              )
                                            : AssetImage(
                                                    'assets/images/uprofile.png')
                                                as ImageProvider,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (userModel!.user_id ==
                                            _callHistory[index].user_id)
                                        ? capitalize(
                                            _callHistory[index].t_name!)
                                        : capitalize(_callHistory[index].name!),
                                    style: smollheader(context),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Interest :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: capitalize(_callHistory[index]
                                                .interest_name!),
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Question :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: capitalize(
                                                _callHistory[index].question!),
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Call Duration :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                "${_callHistory[index].call_duration}" +
                                                    " min",
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Call Date :- ',
                                      style: smollheader(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: convertDateIntoDateFormat(
                                                _callHistory[index]
                                                        .request_date! +
                                                    " " +
                                                    _callHistory[index]
                                                        .request_time!),
                                            style: smollheaderlight(context)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
  }

  Widget callNotAnsBtn() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.03,
      width: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
          color: Colors.red,
          // border: Border.all(width: 1, color: Color(0xff646363)),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Center(
        child: Text(
          "Not Answered",
          style: verysmollheader(context).copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget callAnsBtn() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.03,
      width: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
          color: Colors.green,
          //  border: Border.all(width: 1, color: Color(0xff646363)),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Center(
        child: Text(
          "Answered",
          style: verysmollheader(context).copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget callAcceptBtnHistory() {
    return InkWell(
      onTap: (() {}),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.03,
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
            color: blueCom,
            // border: Border.all(width: 1, color: Color(0xff646363)),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Text(
            "Accepted",
            style: verysmollheader(context).copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void accpectDialog(int requestAction, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            _setState = setState;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              backgroundColor: Colors.white,

              // title: Text("Decline Appointment Request"),
              content: Container(
                height: MediaQuery.of(context).size.height * .50,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                              size: 25,
                            )),
                      ),
                      Center(
                        child: Text(
                          requestAction == 1
                              ? "Accept Request"
                              : "Reject Request",
                          style: TextStyle(
                              color: black,
                              fontSize: 15,
                              fontFamily: "OpenSans",
                              fontWeight: FontWeight.w600),
                          // style: bottomheader(context),
                        ),
                      ),

                      requestAction == 1 ? sentAcceptBtn(index) : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .25,
                            height: MediaQuery.of(context).size.height * 0.001,
                            color: black,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text("or"),
                          SizedBox(
                            width: 2,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .25,
                            height: MediaQuery.of(context).size.height * 0.001,
                            color: black,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 2),
                        child: Text(
                          "Schedule Your Call / Tenteative Time",
                          style: verysmollheader(context),
                        ),
                      ),
                      calender(),
                      // timeschedule(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: InkWell(
                          onTap: (() {
                            setState(() {
                              _selectedTime(context);
                            });
                          }),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: blueCom),
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(Icons.timelapse),
                                SizedBox(
                                  width: 12,
                                ),
                                Text("${converDateTime(vStartTime)}")
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 2),
                        child: Text(
                          "Note",
                          style: verysmollheader(context),
                        ),
                      ),
                      // NoteInputAcceptCall(),
                      newNote(),
                      //SubmitBtn(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Button(
                            key: Key('login_button'),
                            buttonName: "Submit",
                            onPressed: () {
                              print("selectedTime...${vStartTime.toString()}");
                              if (requestAction == 1) {
                                if (date.toString().isEmpty) {
                                  return showToastMessage(
                                      "Select  Date", context);
                                } else if (selectedTime.toString().isEmpty) {
                                  return showToastMessage(
                                      "Select Time", context);
                                } else if (teacherCon.text.toString().isEmpty) {
                                  return showToastMessage(
                                      "Enter Note", context);
                                } else {
                                  _actionRequestApi(
                                      requestAction,
                                      selectedDate.toString(),
                                      vStartTime,
                                      teacherCon.text,
                                      index);
                                }
                              } else {
                                _actionRequestApi(
                                    requestAction,
                                    selectedDate.toString(),
                                    vStartTime,
                                    teacherCon.text,
                                    index);
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget calender() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: (() {
          _selectDate(context);
        }),
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: blueCom),
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Icon(Icons.calendar_month),
              SizedBox(
                width: 12,
              ),
              Text(
// selectedDate.toString())

                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}")
            ],
          ),
        ),
      ),
    );
  }

  Widget timeschedule() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: (() {
          setState(() {
            _selectedTime(context);
          });
        }),
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: blueCom),
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Icon(Icons.timelapse),
              SizedBox(
                width: 12,
              ),
              Text("${converDateTime(vStartTime)}")
            ],
          ),
        ),
      ),
    );
  }

  Widget newNote() {
    return Container(
      height: 36,
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: teacherCon,
        onEditingComplete: () => {},
        style: TextStyle(
            color: black,
            fontSize: 14,
            fontFamily: "OpenSans",
            fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: 'Note',
          hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w600),
          prefixIcon: Icon(
            Icons.note,
            color: black,
            size: 20,
          ),
          contentPadding: const EdgeInsets.only(left: 8, top: 20),
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
    );
  }

  Widget allDropDown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topRight,
        child: PopupMenuButton<all>(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  // border: Border.all(width: 1, color: black),
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("All"),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                    )
                  ],
                ),
              )),
          itemBuilder: (BuildContext context) {
            return List<PopupMenuEntry<all>>.generate(
              all.values.length,
              (int index) {
                return PopupMenuItem(
                  value: all.values[index],
                  child: AnimatedBuilder(
                      child: Text(all.values[index]
                          .name), //Text(Fruit.values[index].toString()),
                      animation: _selectedItem,
                      builder: (BuildContext context, Widget? child) {
                        return RadioListTile<all>(
                            value: all.values[index],
                            title: child,
                            groupValue: _selectedItem.value,
                            onChanged: (all? value) {
                              _selectedItem.value = value!;
                              if (value.name == 'All') {
                                filterByStutus = "";
                              } else if (value.name == 'Pending') {
                                filterByStutus = "0";
                              } else if (value.name == 'Accepted') {
                                filterByStutus = "1";
                              } else if (value.name == 'Rejected') {
                                filterByStutus = "3";
                              }
                              print(
                                  "${value.name}+${selectedTab}+${filterByStutus}");
                              Navigator.pop(context);
                              if (selectedTab == 0) {
                                _getsenRequestApi();
                              } else if (selectedTab == 1) {
                                _getRecivedApi();
                              } else if (selectedTab == 2) {
                                _getcallHistoryApi();
                              } else if (selectedTab == 3) {
                                _getguideApi();
                              }
                            });
                      }),
                );
              },
            );
          },
        ),
      ),
    );
  }

//-----FCM Calling api

  messageApi(int index) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAFlVQNVU:APA91bEwHTWTEiA0EIDxlRWVsdvGuEZYIR2dYiYWV1GCRGuNkLZNWcdNw1EU7L7QQ1aK1sDui4E3gelSQLmylUePgVvW3lKZUnCZDN-YFt4k6SuamBmmZRKu9McTfDmwzPagFvs5DBQe'
      // AAAAFlVQNVU:APA91bEwHTWTEiA0EIDxlRWVsdvGuEZYIR2dYiYWV1GCRGuNkLZNWcdNw1EU7L7QQ1aK1sDui4E3gelSQLmylUePgVvW3lKZUnCZDN-YFt4k6SuamBmmZRKu9McTfDmwzPagFvs5DBQe
    };

    dynamic body = {
      "user_id": userModel?.user_id,
      "channel_name": channelId,
      "caller_name": userModel?.name,
      "receiver_name": _recivedModelList[index].name,
      "message": "Join call with channel name: $channelId",
      "device_token":
          (userModel?.user_id != _recivedModelList[index].teacher_id)
              ? _recivedModelList[index].device_token
              : _recivedModelList[index]
                  .t_device_token, //_recivedModelList[index].t_device_token,
      "request_id": _recivedModelList[index].user_request_id,
      "user_request_id": _recivedModelList[index].user_id,
      "receiver_id": _recivedModelList[index].teacher_id,
      "rate_amount": Preference()
          .getString(Preference.RATE_AMMOUNT), //userModel?.rate_amount,
      "receiver_image": _recivedModelList[index].user_image,
      "sender_image": userModel?.user_image,
      "user_wallet_balance": _recivedModelList[index].user_wallet_balance,
      "app_id": agora_Server_Id,
      "aap_channel": agora_Server_Channel,
      "aap_token": agora_Server_token,
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": (userModel?.user_id.toString() ==
              _recivedModelList[index].teacher_id.toString())
          ? _recivedModelList[index].device_token
          : _recivedModelList[index]
              .t_device_token, //_recivedModelList[index].t_device_token,
      "priority": "high",
      "notification": {
        "title": "${userModel?.name} is Calling...",
        "body": "Join Call",
        "text": "Text"
      },
      "data": {"title": "${userModel?.name} is Calling...", "body": body}
    });
// "JOIN Call with Channel Name is : Rameshwaram"
    //  print("index.....${usersList[index]['device_token']}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
    } else {
      print(response.reasonPhrase);
    }
  }
  //-----get User List

  getUserList() async {
    var request = http.Request(
        'POST', Uri.parse('${APIConstants.senpaiBaseUrl}user/getUserList'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
      if (mounted) {
        setState(() {
          usersList = responseData['user'];
        });
      }

      print("userlist....$usersList");
    } else {
      print(response.reasonPhrase);
    }
  }

  _getRecivedApi() async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getReceivedRequest'));
    request.fields.addAll({
      "user_id": userModel!.user_id,
      "security_code": userModel!.security_code,
      "request_status": filterByStutus.toString(),
      'page_no': "1",
      "limit": "10",
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
      log("responseDatareciver...$responseData");
      if (responseData['status'] == 0) {
        print("Feild");
        if (mounted) {
          setState(() {
            _recivedModelList = [];
          });
        }
      } else if (responseData['status'] == 1) {
        print("_sentRequestList..$_sentRequestList");
        try {
          setState(() {
            _recivedModelList = (responseData['received_request'] as List)
                .map((itemWord) => ReciviedModel.fromJson(itemWord))
                .toList();
          });
        } catch (e) {
          log('Exception...$e');
        }
      } else if (responseData['status'] == 6) {
        var baseDialog1 = BaseAlertDialog(
          title: "Your account has been login by another device.",
          content: "Please logout account another device",
          yesOnPressed: () async {
            Preference().setLoginBool(Preference.IS_LOGIN, false);
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
    print("_recivedModelList...${_recivedModelList.length}");

    setState(() {
      _isLoading = false;
    });
  }

//---for pagination
  void _senRecivedloadMore() async {
    if (_hasNextPage == true &&
        _isLoading == false &&
        _isLoadMoreRunning == false &&
        _controller2!.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      // print("intrest_id..$intrest_id");
      Map<String, dynamic> jsondatais =
          jsonDecode(Preference().getString(Preference.USER_MODEL)!);
      var user = UserModel.fromJson(jsondatais);
      if (jsondatais.isNotEmpty) {
        // print("interestID...${user.interest[1]['interest_id']}");
      }
      var request = http.MultipartRequest('POST',
          Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getReceivedRequest'));
      request.fields.addAll({
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "request_status": filterByStutus.toString(),
        'page_no': _page.toString(),
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
            setState(() {
              List<ReciviedModel> tempgetrecivedData =
                  (responseData['received_request'] as List)
                      .map((itemWord) => ReciviedModel.fromJson(itemWord))
                      .toList();
              if (tempgetrecivedData.length > 0) {
                setState(() {
                  _recivedModelList.addAll(tempgetrecivedData);
                });
              }
            });
          } catch (e) {
            log("Exception...$e");
          }
          // List tempgetExpolreData = responseData['sent_request'];
          // if (tempgetExpolreData.length > 0) {
          //   setState(() {
          //     _sentRequestList.addAll(tempgetExpolreData);
          //   });

          // }
          String is_more_data = responseData['is_more_data'];
          print("is_more_data...$is_more_data");
          if (is_more_data == 'no') {
            showSnackBar();
            setState(() {
              _hasNextPage = false;
            });
          }
        } else if (responseData['status'] == 6) {
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
      print("datas...${_recivedModelList.length}");
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  _getsenRequestApi() async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getSentRequest'));
    request.fields.addAll({
      "user_id": userModel!.user_id,
      "security_code": userModel!.security_code,
      "request_status": filterByStutus.toString(),
      'page_no': "1",
      "limit": "10",
      "search_text": ""
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
            _sentRequestList = [];
          });
        }
      } else if (responseData['status'] == 1) {
        print("_sentRequestList..$_sentRequestList");
        print("_sentRequestList..${_sentRequestList.length}");
        try {
          setState(() {
            _sentRequestList = (responseData['sent_request'] as List)
                .map((itemWord) => ReciviedModel.fromJson(itemWord))
                .toList();
          });
        } catch (e) {
          log("Exception...$e");
        }
      } else if (responseData['status'] == 6) {
        var baseDialog1 = BaseAlertDialog(
          title: "Your account has been login by another device.",
          content: "Please logout account another device",
          yesOnPressed: () async {
            Preference().setLoginBool(Preference.IS_LOGIN, false);
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
    print("datassent...${_sentRequestList.length}");

    setState(() {
      _isLoading = false;
    });
  }

  //---for pagination
  void _senRequestApiloadMore1() async {
    if (_hasNextPage == true &&
        _isLoading == false &&
        _isLoadMoreRunning == false &&
        _controller1!.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      // print("intrest_id..$intrest_id");
      Map<String, dynamic> jsondatais =
          jsonDecode(Preference().getString(Preference.USER_MODEL)!);
      var user = UserModel.fromJson(jsondatais);
      if (jsondatais.isNotEmpty) {
        // print("interestID...${user.interest[1]['interest_id']}");
      }
      var request = http.MultipartRequest('POST',
          Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getSentRequest'));
      request.fields.addAll({
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "request_status": filterByStutus.toString(),
        'page_no': _page.toString(),
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
            setState(() {
              List<ReciviedModel> tempgetExpolreData =
                  (responseData['sent_request'] as List)
                      .map((itemWord) => ReciviedModel.fromJson(itemWord))
                      .toList();
              if (tempgetExpolreData.length > 0) {
                setState(() {
                  _sentRequestList.addAll(tempgetExpolreData);
                });
              }
            });
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
        } else if (responseData['status'] == 6) {
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
      print("datassent...${_sentRequestList.length}");
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  //----for paginaton
  void showSnackBar() {
    final snackBar = SnackBar(
      content: Text('You have fetched all of the content'),
    );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _getcallHistoryApi() async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getCallHistory'));
    request.fields.addAll({
      "user_id": userModel!.user_id,
      "security_code": userModel!.security_code,
      'page_no': "1",
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
            _callHistory = [];
          });
        }
      } else if (responseData['status'] == 1) {
        print("_callHistory..$_callHistory");
        try {
          setState(() {
            _callHistory = (responseData['call_history'] as List)
                .map((itemWord) => ReciviedModel.fromJson(itemWord))
                .toList();
            print("_callHistory...${_callHistory.toString()}");
          });
        } catch (e) {
          log('Exception...$e');
        }
      } else if (responseData['status'] == 6) {
        var baseDialog1 = BaseAlertDialog(
          title: "Your account has been login by another device.",
          content: "Please logout account another device",
          yesOnPressed: () async {
            Preference().setLoginBool(Preference.IS_LOGIN, false);
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
    print("_callHistory...${_callHistory.length}");

    setState(() {
      _isLoading = false;
    });
  }

//---for pagination
  void _sencallhistoryloadMore() async {
    if (_hasNextPage == true &&
        _isLoading == false &&
        _isLoadMoreRunning == false &&
        _controller3!.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      // print("intrest_id..$intrest_id");
      Map<String, dynamic> jsondatais =
          jsonDecode(Preference().getString(Preference.USER_MODEL)!);
      var user = UserModel.fromJson(jsondatais);
      if (jsondatais.isNotEmpty) {
        // print("interestID...${user.interest[1]['interest_id']}");
      }
      var request = http.MultipartRequest('POST',
          Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getCallHistory'));
      request.fields.addAll({
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        'page_no': _page.toString(),
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
            setState(() {
              List<ReciviedModel> tempcallHistoryData =
                  (responseData['call_history'] as List)
                      .map((itemWord) => ReciviedModel.fromJson(itemWord))
                      .toList();
              if (tempcallHistoryData.length > 0) {
                setState(() {
                  _callHistory.addAll(tempcallHistoryData);
                });
              }
            });
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
        } else if (responseData['status'] == 6) {
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
      print("datas...${_callHistory.length}");
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  _getguideApi() async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
        'POST', Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getGuidedNow'));
    request.fields.addAll({
      "user_id": userModel!.user_id,
      "security_code": userModel!.security_code,
      'page_no': "1",
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
            _guidenowlist = [];
          });
        }
      } else if (responseData['status'] == 1) {
        print("_guidenowlist..$_guidenowlist");
        try {
          setState(() {
            _guidenowlist = (responseData['guided_request'] as List)
                .map((itemWord) => ReciviedModel.fromJson(itemWord))
                .toList();
          });
        } catch (e) {
          log('Exception...$e');
        }
      } else if (responseData['status'] == 6) {
        var baseDialog1 = BaseAlertDialog(
          title: "Your account has been login by another device.",
          content: "Please logout account another device",
          yesOnPressed: () async {
            Preference().setLoginBool(Preference.IS_LOGIN, false);
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
    print("_guidenowlist...${_guidenowlist.length}");

    setState(() {
      _isLoading = false;
    });
  }

  //---for pagination
  void _senguideLoadMore() async {
    if (_hasNextPage == true &&
        _isLoading == false &&
        _isLoadMoreRunning == false &&
        _controller4!.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      // print("intrest_id..$intrest_id");
      Map<String, dynamic> jsondatais =
          jsonDecode(Preference().getString(Preference.USER_MODEL)!);
      var user = UserModel.fromJson(jsondatais);
      if (jsondatais.isNotEmpty) {
        // print("interestID...${user.interest[1]['interest_id']}");
      }
      var request = http.MultipartRequest('POST',
          Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getGuidedNow'));
      request.fields.addAll({
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        'page_no': _page.toString(),
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
            setState(() {
              List<ReciviedModel> tempgetguideData =
                  (responseData['guided_request'] as List)
                      .map((itemWord) => ReciviedModel.fromJson(itemWord))
                      .toList();
              if (tempgetguideData.length > 0) {
                setState(() {
                  _guidenowlist.addAll(tempgetguideData);
                });
              }
            });
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
        } else if (responseData['status'] == 6) {
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
      print("dataguide...${_guidenowlist.length}");
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  _getUserProfileApi() async {
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/getUserProfile'),
      body: {"user_id": userModel!.user_id, "session_user_id": ""},
    ).then(
      (response) {
        dynamic responce = json.decode(response.body);
        print("pppp$responce");
        currentWallectBalance = responce['user_detail']['user_wallet_balance'];
        rate_amount = responce['user_detail']['rate_amount'];
        call_reciver_id = responce['user_detail']['user_id'];

        notification_see = responce['user_detail']['new_notification'];
        blog_see = responce['user_detail']['new_blog'];
        request_see = responce['user_detail']['new_request'];

        Preference().setString(Preference.NEW_BLOG, blog_see);
        Preference().setString(Preference.NEW_REQUEST, request_see);
        Preference().setString(Preference.NEW_NOTIFICATION, notification_see);
        Preference()
            .setString(Preference.CURRENT_BALANCE, currentWallectBalance);
        Preference().setString(Preference.RATE_AMMOUNT, rate_amount);
        setState(() {});
      },
    );
  }

  _actionRequestApi(
      int requestAction, String req_date, String req_time, String note, index) {
    setState(() {
      _isLoading = true;
    });

    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/actionRequest'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "user_request_id": _recivedModelList[index].user_request_id,
        "request_status": requestAction.toString(),
        "request_date": req_date,
        "request_time": req_time,
        "teacher_note": teacherCon.text.toString()
      },
    ).then(
      (response) {
        print("object...${response.body}");
        dynamic res = json.decode(response.body);
        String mgs = res['message'];
        if (res['status'] == 1) {
          requestAction == 1
              ? showDialog(
                  context: context,
                  builder: (context) => acceptGuideDailog(),
                )
              : Navigator.pop(context);
          _getRecivedApi();
          _getguideApi();
          _getcallHistoryApi();
        } else if (res['status'] == 6) {
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
        } else {
          setState(() {
            _isLoading = false;
          });
        }
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
      } else if (responseData['status'] == 6) {
        var baseDialog1 = BaseAlertDialog(
          title: "Your account has been login by another device.",
          content: "Please logout account another device",
          yesOnPressed: () async {
            Preference().setLoginBool(Preference.IS_LOGIN, false);
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

  Widget acceptGuideDailog() {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 16,
                  left: 16,
                  right: 16,
                ),
                margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // CircleAvatar(
                    //   backgroundColor: Colors.transparent,
                    //   radius: Constants.avatarRadius,
                    //   child: ClipRRect(
                    //       borderRadius: BorderRadius.all(
                    //           Radius.circular(Constants.avatarRadius)),
                    //       child: Image.asset("assets/images/thanks.gif")),
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "You can connect with the guident from the Guide Now",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  //------Token Api-----//
  getTokenApi() async {
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://senpai.co.in/agora/DynamicKey/AgoraDynamicKey/php/sample/RtcTokenBuilder2Sample.php'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
      agora_Server_Certificate = responseData['app_certificate'];
      agora_Server_Id = responseData['app_id'];
      agora_Server_Channel = responseData['channel_name'];
      agora_Server_token = responseData['token_with_int'];
      Preference().setString(Preference.AGORA_APP_ID, agora_Server_Id);
      Preference().setString(Preference.AGORA_CHANNET_ID, agora_Server_Channel);
      Preference().setString(Preference.AGORA_TOKEN_ID, agora_Server_token);
      Preference()
          .setString(Preference.AGORA_CERTIFICATE, agora_Server_Certificate);
    } else {
      print(response.reasonPhrase);
    }
  }
}
