// ignore_for_file: prefer_const_constructors, void_checks, file_names, prefer_typing_uninitialized_variables, unnecessary_const, unused_field, non_constant_identifier_names, avoid_print, unused_element, prefer_is_empty, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, sized_box_for_whitespace, avoid_unnecessary_containers, unused_local_variable, prefer_final_fields
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:senpai/Call/CallScreen.dart';
import 'package:senpai/Call/agora.config.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Common/mediumButton.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/DashBord.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/View/ReportForm.dart';
import 'package:senpai/View/ViewAllReview.dart';
import 'package:senpai/model/Language.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:senpai/model/intrestModel.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/model/receviedModel.dart';
import 'package:senpai/model/user_intrestModel.dart';
import 'package:senpai/newEditProfile/select_language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/InputField.dart';
import '../Common/colors.dart';
import '../newEditProfile/select_intrest.dart';
import 'FeedBack.dart';
import 'package:intl/intl.dart';

class ExploreDetail extends StatefulWidget {
  final dynamic detailKey;
  final dynamic request_Id;
  final dynamic user_request_Id;
  final dynamic receiver_Id;
  final dynamic rate_amount;
  final bool ReviewKey;
  final bool profliekey;
  final bool reportkey;
  final bool favirateKey;

  const ExploreDetail(
      {Key? key,
      this.detailKey,
      required this.ReviewKey,
      this.request_Id,
      this.user_request_Id,
      this.receiver_Id,
      this.rate_amount,
      required this.profliekey,
      required this.reportkey,
      required this.favirateKey})
      : super(key: key);

  @override
  State<ExploreDetail> createState() => _ExploreDetailState();
}

class _ExploreDetailState extends State<ExploreDetail> {
  String? _chosenValue;

  TextEditingController noteCon = TextEditingController();
  TextEditingController questionCon = TextEditingController();
  TextEditingController amountCon = TextEditingController();
  TextEditingController noteDonationCon = TextEditingController();
  late Razorpay _razorpay;
  static const platform = const MethodChannel("razorpay_flutter");
  String rate_amount = "";
  String dropdownvalue = 'Item 1';
  String is_favorite = "0";
  String is_blue_tick = "0";
  String badge_name = "";
  String badge_img = "";
  dynamic agora_Server_Id = "";
  dynamic agora_Server_Channel = "";
  dynamic agora_Server_token = "";
  dynamic agora_Server_Certificate = "";
  int? index;
  List<ReciviedModel> _recivedModelList = [];
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  // void main() {
  //   print(capitalize("this is a string"));
    
  //   // displays "This is a string"
  // }
void main(List<String> arguments) {
  var str = 'the quick brown fox jumps over the lazy dog';
  print(toBeginningOfSentenceCase(str));
}

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
 // String capitalizeFirstofEach(String s)=>s.split(" ").map((str) => str.capitalize).join(" ");
  
//   extension CapExtension on String {
//   String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
//   String get allInCaps => this.toUpperCase();
//   String get capitalizeFirstofEach => this.split(" ").map((str) => str.capitalize).join(" ");
// }




  String? discription = "";
  List usergetReview = [];
  List<IntrestModel> _intrest = [];

  List<UserIntrestModel> intrestDropdownList = [];
  UserIntrestModel? intrestDropdownvalue;
  // List<UserIntrestModel> intrestDropdownList2 = [];

  // UserIntrestModel? intrestDropdownvalue2;
  var userIntrestData;

  // IntrestModel? intrestDropdownvalue;

  var IntrestData;
  String Device_Token = "";
  String receiver_image = "";
  String receiver_t_user_wallet_balance = "";
  String User_Request_id = "";
  String request_id = "";
  String Receiver_teacher_id = " ";
  String User_Id = "";
  String UserName = "";
  String userImage = "";
  String avg_rating = "0.0";
  String no_calls = "";
  String guided_min = "";
  String start_time = "";
  String start_Year = "";
  String since_Year = "";
  bool isRequestSent = false;
  String end_time = "";
  String currentWallectBalance = "00";

  String callSetting = "0"; // 2 - Direct Call 0 Or 1 - Approch Mode

  List<LanguageModel> _language = [];
  dynamic getUserProfileData = [];
  dynamic direct_call;
  dynamic experience = [];
  dynamic education = [];
  dynamic location = [];
  dynamic occupation = [];
  dynamic intresetList = [];
  UserModel? userModel;
  double userWallerAmount = 0.0;


  void getUserModel() async {
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    userModel = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print("userName...${userModel!.user_id}");
    }
  }

  String convertDateIntoDateFormat(String date) {
    final DateTime parseDateTime = DateTime.parse(date);
    // final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateFormat formatter1 = DateFormat('MMM-yyyy');
    final String formattedDate = formatter1.format(parseDateTime);
    print(formattedDate);
    return formattedDate;
  }

  String convertmonthYear(String date) {
    print("newdate...$date");
    DateTime parseDateTime = DateTime.parse(date);
    // final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateFormat formatter1 = DateFormat('MMMM-yyyy');
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

  String showDeviceCurrentTime() {
    DateTime now = DateTime.now();
    DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    DateFormat timeFormatter = DateFormat('HH:mm:ss');
    return dateFormatter.format(now) + " " + timeFormatter.format(now);
  }

  bool? _isLoading = false;

  int _page = 1;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  ScrollController? _controller;

  @override
  void initState() {
    getUserModel();
    getTokenApi(); //TOKEN API
    usergetReview = [];
    print("device_date_time...${showDeviceCurrentTime()}");
    super.initState();
   
    // _controller = ScrollController()..addListener(loadMore);
    agora_Server_Id = "";
    agora_Server_Channel = "";
    agora_Server_token = "";
    agora_Server_Certificate = "";
    rate_amount = "";
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    print("wallet${Preference().getString(Preference.CURRENT_BALANCE)}");
    if (Preference().getString(Preference.CURRENT_BALANCE) == null) {
      Preference().setString(Preference.CURRENT_BALANCE, "0.0");
    }
    if (Preference().getString(Preference.CURRENT_BALANCE)!.toString().length >
        0) {
      userWallerAmount = double.parse(
          Preference().getString(Preference.CURRENT_BALANCE)!.toString());
    } else {
      userWallerAmount = 0.0;
    }
    is_favorite = "0";
    is_blue_tick = "0";
    rate_amount = "";
    direct_call;
    Device_Token = "";
    Receiver_teacher_id = " ";
    User_Request_id = "";
    User_Id = " ";
    UserName = "";
    userImage = "";
    start_Year = "";
    since_Year = "";
    end_time = "";
    start_time = "";
    badge_name = "";
    badge_img = "";
    widget.detailKey;
    print("detailKey....${widget.detailKey}");
    _getUserProfileApi();
    getReviewListApi();
  }

  ///-------razorPay
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
    // _controller!.removeListener(loadMore);
  }

  void openCheckout() async {
    var options = {
      //rzp_test_YUim5Ug1qOPHmu
      'key': Preference().getString(Preference
          .REZORPAY_KEY), //'rzp_test_wyp8TneX6OfATk', //'rzp_test_vbGc161A6tGYHa',
      'amount': 100,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log("sucess${response.paymentId!}");

    showToastMessage("SUCCESS: " + response.paymentId!, context);

    sendDonation(response.paymentId!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log("Error ${response.code.toString() + response.message!}");

    showToastMessage(
        "ERROR: " + response.code.toString() + " - " + response.message!,
        context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log(response.walletName!);
    showToastMessage("EXTERNAL_WALLET: " + response.walletName!, context);
  }

  ///-----razorpay

  //---Intreset
  void _IntresetNavigator(BuildContext context) async {
    List<String> interstIds = [];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SelectIntrest(
                interstIds: interstIds,
              )),
    );
    if (result != null) {
      _getUserProfileApi();
    }
  }

  void _LangeuageNAvigate(BuildContext context) async {
    List<String> languageIds = [];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SelectLaguage(languageIds: languageIds)),
    );
    if (result != null) {
      _getUserProfileApi();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: blueCom,
          centerTitle: true,
          title: Text(
            "Explore Detail",
            style: btnWhite(context),
          ),
          leading: InkWell(
              onTap: (() {
                Navigator.pop(context, currentWallectBalance);
              }),
              child: Icon(Icons.arrow_back)),
        ),
        body: Stack(
          children: [
            allFields(),
            LoaderIndicator(_isLoading!),
          ],
        ));
  }

  Widget allFields() {
    return SingleChildScrollView(
      child: Column(
        children: [
          detail(),
          callingRow(),
          _addLanguage(),
          _addIntrest(),
          _bio(),
          exprienceList(),
          educationList(),
          LocationList(),
          occputionList(),
          intrestedGuide()
        ],
      ),
    );
  }

  Widget detail() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: borderColor),
            color: white,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            detailRow(),
          ],
        ),
      ),
    );
  }

  Widget detailRow() {
    return Row(children: [
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 90.0,
                  width: 90.0,
                  decoration: BoxDecoration(
                    color: white,
                    border: Border.all(width: 1, color: grayShade),
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: (userImage.length > 0)
                        ? NetworkImage(
                            userImage,
                          )
                        : AssetImage('assets/images/uprofile.png')
                            as ImageProvider,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                      color: white,
                      border: Border.all(width: 1, color: Color(0xff646363)),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Center(
                      child: Text(
                        "Level 1",
                        style: verysmollheader(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),

                RichText(
                  text: TextSpan(
                    text: "Since ",
                    style: verysmollheader(context),
                    children: <TextSpan>[
                      TextSpan(
                          text: since_Year, style: smollheader(context).copyWith(color:Colors.black54)),
                    ],
                  ),
                ),

                // Text(
                //   // "since "+ convertDateIntoDateFormat(since_Year),
                //   "Since " + since_Year,
                //   style: smollheader(context),
                // ),
                // SizedBox(
                //   height: 2,
                // ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportPage(
                          other_userId: User_Id,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      (widget.reportkey == true)
                          ? Container(
                              decoration: BoxDecoration(
                                  color: blueCom,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text("Report",
                                      style: smollheader(context)
                                          .copyWith(color: white)),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 15,
                      ),
                      (widget.favirateKey == true)
                          ? IconButton(
                              onPressed: () {
                                favorateUser();
                              },
                              icon: Icon(
                                ((is_favorite == "0")
                                    ? Icons.favorite_outline
                                    : Icons.favorite),
                                color: ((is_favorite == "0")
                                    ? Colors.grey
                                    : Colors.red),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(
        width: 15,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.topRight,
            width: MediaQuery.of(context).size.width * 0.56,
            // color: Colors.red,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (badge_img.length > 0)
                    ? Container(
                        // height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.07,
                        child: Image(
                            image: (badge_img.length > 0)
                                ? NetworkImage(
                                    badge_img,
                                  )
                                : AssetImage('assets/logo/medal.png')
                                    as ImageProvider),
                      )
                    : Container(),
                Text(
                  badge_name.isEmpty ? "" : badge_name,
                  style: subheaderdark(context),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Row(
            children: [
              Text(
               
                // capitalize(UserName),
               UserName,
                style: bottomheader(context),
              ),
              (is_blue_tick == "1")
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Icon(
                        Icons.check_circle_outline_outlined,
                        color: Colors.blue,
                      ))
                  : Container()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(width: 1, color: Color(0xff646363)),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  child: Row(
                    children: [
                      Text(
                        avg_rating,
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
              SizedBox(
                width: 72,
              ),
              (widget.profliekey == true)
                  ? Container()
                  : InkWell(
                      onTap: () {
                        //  _getUserProfileApi();
                        setState(() {
                          _intrest = (getUserProfileData['interest'] as List)
                              .map(
                                  (itemWord) => IntrestModel.fromJson(itemWord))
                              .toList();
                          setState(() {});
                        });

                        _showDecline();
                      },
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 0.03,
                        // width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            // border: Border.all(width: 1, color: Color(0xff646363)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.call,
                                size: 15,
                                color: white,
                              ),
                              SizedBox(
                                width: 1,
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
            ],
          ),
          Container(
            // color: Colors.red,
            // width: MediaQuery.of(context).size.width * 0.6,
            child: RichText(
              text: TextSpan(
                text: "Start Time" + "    ",
                style: verysmollheader(context),
                children: <TextSpan>[
                  TextSpan(
                      text: (start_time.length == 0)
                          ? "09:00:00"
                          : converDateTime(start_time) + "\n",
                      style: smollheaderlight(context)),
                  TextSpan(
                      text: "End Time" + "      ",
                      style: verysmollheader(context)),
                  TextSpan(
                      text:
                          "${end_time.length == 0 ? "09:00:00" : converDateTime(end_time)}" +
                              "\n",
                      style: smollheaderlight(context)),
                  TextSpan(
                      text: "Call Rate" + "      ",
                      style: verysmollheader(context)),
                  TextSpan(
                      text:
                          "${rate_amount.length == 0 ? "0.0/min" : "\u20B9 " + rate_amount + " /min"}",
                      style: smollheaderlight(context))
                ],
              ),
            ),
          ),
          Container(
            // color: Colors.red,
            // width: MediaQuery.of(context).size.width * 0.6,
            child: RichText(
              text: TextSpan(
                text: "Call Setting" + "     ",
                style: verysmollheader(context),
                children: <TextSpan>[
                  TextSpan(
                      text: callSetting == "2"
                          ? "Direct Call"
                          : "Approch Mode Only",
                      style: smollheaderlight(context)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
        ],
      ),
    ]);
  }

  Widget _bio() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Image.asset("assets/logo/icon_summary.png"),
                    Container(
                      width: MediaQuery.of(context).size.width * .8,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: RichText(
                          text: TextSpan(
                            text: "Discription",
                            // "Write a summary to highlight your personality or work experience",
                            style: TextStyle(
                              color: black,
                              fontSize: MediaQuery.of(context).size.width * .04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                child: Container(
                  width: MediaQuery.of(context).size.width * .8,
                  // color: Colors.red,
                  child: RichText(
                    text: TextSpan(
                        text: discription, style: smollheaderlight(context)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// intrested guide on

  Widget intrestedGuide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // callingRow(),
        (widget.profliekey == true) ? Container() : sendCall(),
        (widget.profliekey == true) ? Container() : donation(),
        review()
      ],
    );
  }

  Widget callingRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
                color: white,
                border: Border.all(width: 1, color: Color(0xff646363)),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone,
                  size: 20,
                ),
                Text(
                  " No of Call:",
                  style: smollheader(context),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "${no_calls.length == 0 ? "0" : no_calls}",
                  style: smollheader(context),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
                color: white,
                border: Border.all(width: 1, color: Color(0xff646363)),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer,
                  size: 20,
                ),
                Text(
                  "Guided:",
                  style: smollheader(context),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "${guided_min.length == 0 ? "0" : guided_min}" + " min",
                  style: smollheader(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showDecline() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,

              // title: Text("Decline Appointment Request"),
              content: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 16,
                  left: 16,
                  right: 16,
                ),
                margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: grayShade,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.cancel_outlined,
                            )),
                      ),
                      Text(
                        "Send Approch / Call",
                        style: bottomheader(context),
                      ),
                      questionInput(),

                      // Text("Please select an option for why you declined."),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            // width: MediaQuery.of(context).size.width * .5,
                            // height: MediaQuery.of(context).size.height * .06,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: white,
                                // border: Border.all(width: 1, color: black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: DropdownButton<UserIntrestModel>(
                                hint: Text('Select one option'),
                                value: intrestDropdownvalue,
                                underline: Container(),
                                items: intrestDropdownList
                                    .map((UserIntrestModel value) {
                                  return DropdownMenuItem<UserIntrestModel>(
                                    value: value,
                                    child: Text(value.interest_name,
                                        style: verysmollheader(context)
                                        // TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                  );
                                }).toList(),
                                onChanged: (UserIntrestModel? newValue) {
                                  setState(() {
                                    intrestDropdownvalue = newValue!;
                                  });
                                },
                              ),
                            ),
                          )),

                      sendRequestBtn(index)
                    ]),
              ),
            );
          },
        );
      },
    );
  }

//send aproch call
  Widget sendCall() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            // border: Border.all(width: 1, color: borderColor),
            color: grayShade,
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Send Approch / Call",
                style: bottomheader(context),
              ),
              questionInput(),
              categoryDropdown(),
              // Text(
              //   "Note",
              //   style: bottomheader(context),
              // ),
              // noteInput(),
              SizedBox(
                height: 5,
              ),
              Center(child: sendRequestBtn(index))
            ],
          ),
        ),
      ),
    );
  }

  Widget questionInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: TextFieldDesign(
        key: Key("question"),
        textInputAction: TextInputAction.next,
        //focusNode: passwordFocus,
        hintText: 'Question ',
        controller: questionCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget sendRequestBtn(index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.06,
        child: mediumButton(
          key: Key('send_button'),
          buttonName: "Call / Send Request",
          onPressed: () {
            print("feedbackbtn...${widget.receiver_Id}");
            // print("feedbackbtn...${widget.w}");

            print("mycurrentWallectBalancebtn....${userModel!.rate_amount}");
            print(
                "mycurrentWallectBalancebtn....${Preference().getString(Preference.CURRENT_BALANCE)}");

            double cureentWallet = 0.0;
            try {
              cureentWallet = double.parse(
                  Preference().getString(Preference.CURRENT_BALANCE)!);
            } catch (e) {}

            print("mycurrentWallectBalancebtn....${cureentWallet}");
            print(
                "mycurrentWallectBalancebtn....${(double.parse(userModel!.rate_amount) * 5)}");
            if (!((double.parse(userModel!.rate_amount) * 5) < cureentWallet)) {
              return showToastMessage(
                  "you have no insufiicent balance", context);
            }

            if (questionCon.text.toString().trim().isEmpty) {
              return showToastMessage("Enter question", context);
            } else if (intrestDropdownvalue!.interest_id
                    .toString()
                    .trim()
                    .length ==
                0) {
              return showToastMessage("Selected your interest", context);
            } else if (userWallerAmount < 10) {
              showDialog(
                context: context,
                builder: (context) => walletpopupBox(),
              );
            } else {
              print("callSetting...$callSetting");
              // 1 - Approch Mode Only 2 - Direct Call
              if (callSetting == "2") {
                print("recevire.... ${Receiver_teacher_id},");
                sendAccepctRequest(); // Direct Call
              } else {
                if (!isRequestSent) {
                  isRequestSent = true;
                  sendRequestApi();
                } else {
                  return showToastMessage(
                      "Your have just sent a Request.", context);
                }
              }
            }
          },
        ),
      ),
    );
  }

  Widget categoryDropdown() {
    print("intrestDropdownvalue$intrestDropdownvalue");
    return Center(
      child: Container(
        // width: MediaQuery.of(context).size.width*0.05,
        width: MediaQuery.of(context).size.width * .8,
        height: MediaQuery.of(context).size.height * .06,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: white,
            // border: Border.all(width: 1, color: black),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UserIntrestModel>(
              // Initial Value
              value: intrestDropdownvalue,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: intrestDropdownList
                  .map<DropdownMenuItem<UserIntrestModel>>(
                      (UserIntrestModel items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(
                    items.interest_name,
                    style: verysmollheader(context),
                  ),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (UserIntrestModel? newValue) {
                setState(() {
                  intrestDropdownvalue = newValue!;
                });
                print(
                    "intrestDropdown_id...${intrestDropdownvalue!.interest_id.toString()}");
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget exprienceList() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Experience",
                  style: header(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: experience.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Container(
                        color: grayShade,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    "assets/images/experince.jpg",
                                    width: 80,
                                  ),
                                  Container(
                                    // color: Colors.red,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: RichText(
                                      text: TextSpan(
                                        text: experience[index]['exp_title'],
                                        style: subheaderdark(context),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: experience[index]
                                                      ['company_name'] +
                                                  "." +
                                                  " ",
                                              style: smollheadertext(context)),
                                          TextSpan(
                                              text: experience[index]
                                                      ['emp_type'] +
                                                  " ",
                                              style: smollheadertext(context)),
                                          TextSpan(
                                              text: experience[index]
                                                      ['type_name'] +
                                                  " ",
                                              style: smollheaderlight(context)),
                                          TextSpan(
                                              text: convertDateIntoDateFormat(
                                                      experience[index]
                                                          ['start_date']) +
                                                  " - " +
                                                  convertDateIntoDateFormat(
                                                      experience[index]
                                                          ['end_date']) +
                                                  "\t\t\t",
                                              style: smollheaderlight(context)),
                                          TextSpan(
                                              text: experience[index]
                                                  ['location'],
                                              style: smollheaderlight(context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider()
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget educationList() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Education",
                  style: header(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: education.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Container(
                        color: grayShade,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    "assets/logo/education.png",
                                    width: 100,
                                  ),
                                  Container(
                                    // color: Colors.red,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: RichText(
                                      text: TextSpan(
                                        text: education[index]['field_name'] +
                                            "\n",
                                        style: subheaderdark(context),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: education[index]
                                                      ['institute'] +
                                                  "\n",
                                              style: subheaderdark(context)),
                                          TextSpan(
                                              text: education[index]
                                                      ['degree_name'] +
                                                  "\n",
                                              style: smollheadertext(context)),
                                          TextSpan(
                                              text: convertDateIntoDateFormat(
                                                      education[index]
                                                          ['start_date']) +
                                                  "-" +
                                                  convertDateIntoDateFormat(
                                                      education[index]
                                                          ['end_date']),
                                              style: smollheaderlight(context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider()
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget occputionList() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Occupation",
                  style: header(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: occupation.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Container(
                        color: grayShade,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: RichText(
                                      text: TextSpan(
                                        text: occupation[index]
                                                ['occupation_title'] +
                                            "\n",
                                        style: subheaderdark(context),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: occupation[index]
                                                      ['occupation_type_name'] +
                                                  " \n",
                                              style: subheaderdark(context)),
                                          TextSpan(
                                              text: occupation[index]
                                                      ['occupation_name'] +
                                                  " \n",
                                              style: subheaderdark(context)),
                                          TextSpan(
                                              text: convertDateIntoDateFormat(
                                                      occupation[index]
                                                          ['start_date']) +
                                                  "\t\t\t" +
                                                  convertDateIntoDateFormat(
                                                      occupation[index]
                                                          ['end_date']),
                                              style: smollheaderlight(context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider()
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget LocationList() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Location",
                  style: header(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: location.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Container(
                        color: grayShade,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: RichText(
                                      text: TextSpan(
                                        text: location[index]['location_name'] +
                                            "\n",
                                        style: subheaderdark(context),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: location[index]
                                                      ['start_year'] +
                                                  " - " +
                                                  location[index]['end_year'] +
                                                  "\t\t\t",
                                              style: smollheaderlight(context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider()
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addIntrest() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Image.asset("assets/logo/icon_interest.png"),
                    Container(
                      width: MediaQuery.of(context).size.width * .7,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: RichText(
                          text: TextSpan(
                              text: "Interests",
                              style: TextStyle(
                                color: black,
                                fontSize:
                                    MediaQuery.of(context).size.width * .04,
                                fontWeight: FontWeight.bold,
                              )
                              // style: subheader(context)
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _IntrestWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _IntrestWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          child: Wrap(
            children: _intrest
                .map((intrestModel) => intrestChip(
                      intrestModel: intrestModel,
                      onTap: () {},
                      action: 'Add',
                    ))
                .toList(),
          ),
        ),
      ]),
    );
  }

  Widget intrestChip({
    intrestModel,
    onTap,
    action,
  }) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 5.0,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: black),
            ),
            child: Wrap(
              children: [
                Text(
                  '${intrestModel.interest_name}',
                  style: TextStyle(
                    color: black,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _addLanguage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Image.asset("assets/images/icon_translation.png"),
                    Container(
                      width: MediaQuery.of(context).size.width * .7,
                      // color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: RichText(
                          text: TextSpan(
                              text: " Langauges",
                              style: TextStyle(
                                color: black,
                                fontSize:
                                    MediaQuery.of(context).size.width * .04,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _languageWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          child: Wrap(
            children: _language
                .map((languageModel) => languageChip(
                      languageModel: languageModel,
                      onTap: () {},
                      action: 'Add',
                    ))
                .toList(),
          ),
        ),
      ]),
    );
  }

  Widget languageChip({
    languageModel,
    onTap,
    action,
  }) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 5.0,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: black),
            ),
            child: Wrap(
              children: [
                Text(
                  '${languageModel.language_name}',
                  style: TextStyle(
                    color: black,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ));
  }

  //Donation
  Widget donation() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            // border: Border.all(width: 1, color: borderColor),
            color: grayShade,
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Donation",
                style: bottomheader(context),
              ),
              Text(
                "Do You Want To Donate Any Amount",
                style: smollheaderlight(context),
              ),
              // AmountInput(),
              Row(
                children: [Expanded(child: AmountInput()), payBtn()],
              ),
              Text(
                "Note",
                style: bottomheader(context),
              ),
              noteDonationInput()
            ],
          ),
        ),
      ),
    );
  }

  Widget AmountInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: TextFieldDesign(
        key: Key("Amount"),
        textInputAction: TextInputAction.next,
        //focusNode: passwordFocus,
        keyBoardType: TextInputType.number,
        hintText: '\u20B9' + '10.00',
        controller: amountCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget payBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.06,
        child: mediumButton(
          key: Key('pay_button'),
          buttonName: "pay",
          onPressed: () {
            if (amountCon.text.toString().trim().isEmpty) {
              return showToastMessage("Enter amount", context);
            } else {
              openCheckout();
            }
          },
        ),
      ),
    );
  }

  Widget noteDonationInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: TextFieldDesign(
        key: Key("noteCon"),
        textInputAction: TextInputAction.next,
        //focusNode: passwordFocus,
        hintText: 'Enter Thankyou Note',

        prefixIcon: Icon(
          Icons.note,
          color: Colors.black54,
          size: 20,
        ),
        controller: noteDonationCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget noteInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: TextFieldDesign(
        key: Key("noteCon"),
        textInputAction: TextInputAction.next,
        //focusNode: passwordFocus,
        hintText: 'Note',

        prefixIcon: Icon(
          Icons.note,
          color: black,
          size: 20,
        ),
        controller: noteCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {},
        onSaved: (String? newValue) {},
      ),
    );
  }

// review
  Widget review() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(

            // border: Border.all(width: 1, color: borderColor),
            color: grayShade,
            // color: Colors.red,
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  usergetReview.length == 0
                      ? Container()
                      : Column(
                          children: [
                            Text(
                              "Review",
                              style: bottomheader(context),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            // Container(
                            //     height: 20,
                            //     width: 20,
                            //     decoration: BoxDecoration(
                            //         // color: Colors.red,
                            //         border: Border.all(
                            //           color: Colors.black,
                            //         ),
                            //         borderRadius:
                            //             BorderRadius.all(Radius.circular(20))),
                            //     child: Center(
                            //       child: Text(
                            //         "${usergetReview.length}",
                            //         style: verysmollheader(context),
                            //         // Icons.check_circle_outline_outlined,
                            //         // color: Colors.blue,
                            //       ),
                            //     ))
                          ],
                        ),
                  (widget.ReviewKey == true) ? writeReviewBtn() : Container()
                ],
              ),
              reviewList(),
              usergetReview.length == 0
                  ? Container()
                  : InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewAllReview(
                                      reviewUserId: widget.detailKey,
                                    )));
                      },
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "ViewAll",
                            style: blueheader(context),
                          )),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget writeReviewBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.045,
        child: mediumButton(
          key: Key('review_button'),
          buttonName: "write a Review",
          onPressed: () {
            print("feedbackbtn...${widget.receiver_Id}");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FeedBack(
                          receiver_id: widget.receiver_Id,
                          request_id: widget.request_Id,
                          call_amount: getUserProfileData['rate_amount'],
                          call_rate: getUserProfileData['rate_amount'],
                        )));
          },
        ),
      ),
    );
  }

  Widget reviewList() {
    return usergetReview.length == 0
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Container(
              height: MediaQuery.of(context).size.height / 4.5,
              child: ListView.builder(
                  // controller: _controller,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
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
                              horizontal: 20, vertical: 5),
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

  Widget _reviewRating() {
    return Padding(
      padding: const EdgeInsets.only(top: 00),
      child: RatingBar(
        initialRating: 0,
        allowHalfRating: true,
        direction: Axis.horizontal,
        itemCount: 5,
        itemSize: MediaQuery.of(context).size.width * .06,
        ratingWidget: RatingWidget(
            full: Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            half: Icon(
              Icons.star_half,
              color: Colors.yellow,
            ),
            empty: Icon(
              Icons.star_outline,
              color: Colors.yellow,
            )),
        onRatingUpdate: (value) {
          setState(
            () {
              //   _workratingValue = value;
            },
          );
        },
      ),
    );
  }

//-----
  Widget walletpopupBox() {
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
                    Text(
                      "Your wallet not amount.Please add wallet amount ",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Dashboard(),
                          ),
                        );
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

//-------Send Request thanks you popup
  Widget alertBox() {
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
                  boxShadow: const [
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
                      "Send Request",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 24,
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

//-----call Popup
  Widget callPopup() {
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
                  color: grayShade,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.cancel_outlined,
                          )),
                    ),
                    Text(
                      "Send Approch / Call",
                      style: bottomheader(context),
                    ),
                    questionInput(),
                    categoryDropdown(),
                    // Text(
                    //   "Note",
                    //   style: bottomheader(context),
                    // ),
                    // noteInput(),
                    SizedBox(
                      height: 5,
                    ),
                    Center(child: sendRequestBtn(index))
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  //-----Send Donation
  sendDonation(String transaction_Id) {
    setState(() {
      _isLoading = true;
    });

    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/sendDonation'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "receiver_id": User_Id,
        "amount": amountCon.text.toString(),
        "donation_note": noteDonationCon.text.toString(),
        "transaction_id": transaction_Id
      },
    ).then(
      (response) {
        print("donation...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          return showToastMessage("Donation sucess", context);
        } else if (result1['status'] == 6) {
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

  //-----Send Request
  sendRequestApi() {
    setState(() {
      _isLoading = true;
    });

    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/sendRequest'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "teacher_id": widget.detailKey,
        // "interest_id": "",
        "interest_id": intrestDropdownvalue!.interest_id.toString(),
        "question": questionCon.text.toString(),
        "note": noteCon.text.toString(),
        "request_date": showDeviceCurrentTime().split(" ")[0],
        "request_time": showDeviceCurrentTime().split(" ")[1],
        "call_rate": rate_amount,
      },
    ).then(
      (response) {
        print("only approch...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          return showDialog(
            context: context,
            builder: (context) => alertBox(),
          );
        } else if (result1['status'] == 6) {
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

//------Direct Call
  sendAccepctRequest() {
    //direct call api

    setState(() {
      _isLoading = true;
    });
    print("userid...${userModel!.user_id}");
    print("userid..${rate_amount}");

    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/sendAcceptedRequest'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "teacher_id": widget.detailKey,
        "interest_id": intrestDropdownvalue!.interest_id.toString(),
        "question": questionCon.text.toString(),
        "note": noteCon.text.toString(),
        "request_date": showDeviceCurrentTime().split(" ")[0],
        "request_time": showDeviceCurrentTime().split(" ")[1],
        "call_rate": rate_amount,
      },
    ).then(
      (response) {
        print("sendAccept...${response.body}");
        dynamic result1 = json.decode(response.body);

        String mgs = result1['message'];
        if (result1['status'] == 1) {
          request_id = result1['user_request_id'].toString();
          User_Request_id = result1['user_id'].toString();
          Receiver_teacher_id = result1['teacher_id'].toString();
          Device_Token = result1['t_device_token'].toString();
          receiver_image = result1['t_user_image'].toString();
          receiver_t_user_wallet_balance =
              result1['t_user_wallet_balance'].toString();
          setState(() {
            _isLoading = false;
          });
          dynamic vJsonOBJ = {
            "user_id": userModel?.user_id,
            "channel_name": channelId,
            "caller_name": userModel?.name,
            "receiver_name": UserName,
            "message": "Join call with channel name: $channelId",
            "device_token": Device_Token,
            "request_id": request_id,
            "user_request_id": User_Request_id,
            "receiver_id": Receiver_teacher_id,
            "rate_amount": rate_amount, // userModel?.rate_amount,
            "sender_image": userModel?.user_image,
            "receiver_image": receiver_image,
            "user_wallet_balance": receiver_t_user_wallet_balance,
            "app_id": agora_Server_Id,
            "aap_channel": agora_Server_Channel,
            "aap_token": agora_Server_token,
          };

          messageApi(); // send notification to receiver

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CallScreen(userData: vJsonOBJ, is_from: true),
            ),
          );
          setState(() {
            _isLoading = false;
          });
        } else if (result1['status'] == 6) {
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
//-----FCM Calling api

  messageApi() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAFlVQNVU:APA91bEwHTWTEiA0EIDxlRWVsdvGuEZYIR2dYiYWV1GCRGuNkLZNWcdNw1EU7L7QQ1aK1sDui4E3gelSQLmylUePgVvW3lKZUnCZDN-YFt4k6SuamBmmZRKu9McTfDmwzPagFvs5DBQe'
    };

    dynamic body = {
      "user_id": userModel?.user_id,
      "channel_name": channelId,
      "caller_name": userModel?.name,
      "receiver_name": UserName,
      "message": "Join call with channel name: $channelId",
      "device_token": Device_Token,
      "request_id": User_Request_id,
      "user_request_id": User_Request_id,
      "receiver_id": Receiver_teacher_id,
      "rate_amount": rate_amount,
      "sender_image": userModel?.user_image,
      "receiver_image": receiver_image,
      "user_wallet_balance": receiver_t_user_wallet_balance,
      "app_id": agora_Server_Id,
      "aap_channel": agora_Server_Channel,
      "aap_token": agora_Server_token,
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": Device_Token,
      "priority": "high",
      "notification": {
        "title": "${userModel?.name} is Calling Notification Payload...",
        "body": "Join Call with Channel Name:- $channelId",
        "text": "Text"
      },
      "data": {
        "title": "${userModel?.name} is Calling Data Payload....",
        "body": body
      }
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

//-------Facorate Api
  favorateUser() {
    setState(() {
      _isLoading = true;
    });

    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/favoriteUser'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "other_user_id": User_Id,
      },
    ).then(
      (response) {
        print("only approch...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          if (is_favorite == "0") {
            is_favorite = "1";
            return showToastMessage("Favorite", context);
          } else {
            is_favorite = "0";
            return showToastMessage("UnFavorite", context);
          }
          //  return showToastMessage("Favorite User", context);
        } else if (result1['status'] == 6) {
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

//--------- get User Profile
  _getUserProfileApi() async {
    setState(() {
      _isLoading = true;
    });
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/getUserProfile'),
      body: {
        "user_id": widget.detailKey,
        "session_user_id": userModel!.user_id
      },
    ).then(
      (response) {
        dynamic result1 = json.decode(response.body);
        getUserProfileData = result1['user_detail'];
        print("getUserProfileData...$getUserProfileData");
        print("getUserProfileData...${getUserProfileData['user_image']}");
        avg_rating = getUserProfileData['avg_rating'];
        setState(() {
          User_Id = getUserProfileData['user_id'];
          UserName = getUserProfileData['name'];
          userImage = getUserProfileData['user_image'];
          if (!avg_rating.isEmpty) {
            avg_rating = double.parse(avg_rating).toStringAsFixed(1);
          } else {
            avg_rating = "0.0";
          }

          no_calls = getUserProfileData['no_calls'];
          guided_min = getUserProfileData['guided_min'];
          start_time = getUserProfileData['start_time'];
          end_time = getUserProfileData['end_time'];
          callSetting = getUserProfileData['call_setting'].toString();
          rate_amount = getUserProfileData['rate_amount'];
          currentWallectBalance = getUserProfileData['user_wallet_balance'];
          is_favorite = getUserProfileData['is_favorite'].toString();
          is_blue_tick = getUserProfileData['is_blue_tick'].toString();
          badge_name = getUserProfileData['badge_name'];
          badge_img = getUserProfileData['badge_image'];
          since_Year = convertmonthYear(getUserProfileData['created']);
        });
        print("current...$currentWallectBalance");
        print("since_Year...$since_Year");

        print("UserImage...${userImage}");
        print("is_blue_tick...${is_blue_tick}");

        print("UserName...${UserName}");
        print("badge_name...${badge_name}");
        print("badge_img...${badge_img}");
        experience = getUserProfileData['experience'];

        education = getUserProfileData['study_field'];
        print("education...${education}");
        location = getUserProfileData['location'];
        print("location...${location}");
        occupation = getUserProfileData['occupation'];
        print("occupation...${occupation}");
        discription = getUserProfileData['user_bio'];
        print("discription...${discription}");
        _language = (getUserProfileData['language'] as List)
            .map((itemWord) => LanguageModel.fromJson(itemWord))
            .toList();
        // setState(() {});

        print("interest11${getUserProfileData['interest']}");

        _intrest = (getUserProfileData['interest'] as List)
            .map((itemWord) => IntrestModel.fromJson(itemWord))
            .toList();

//  intrestDropdownList=
        userIntrestData = getUserProfileData['interest'];
        intrestDropdownList.clear();
        UserIntrestModel intrestModel =
            UserIntrestModel("", "", "", "Select Intrest");
        intrestDropdownList.add(intrestModel);

        for (int i = 0; i < userIntrestData.length; i++) {
          var userIntrestDataList = userIntrestData[i];
          UserIntrestModel intrestModel = UserIntrestModel(
              userIntrestDataList['user_interest_id'],
              userIntrestDataList['interest_id'],
              userIntrestDataList['user_id'],
              userIntrestDataList['interest_name']);
          intrestDropdownList.add(intrestModel);
        }
        print("_intrestId...$_intrest");
        print("intrestDropdownvalue$_intrest");
        print("intrestDropdownList...$userIntrestData");
        setState(() {
          intrestDropdownvalue = intrestDropdownList[0];
        });

        start_Year = "";

        setState(() {});
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          intrestDropdownvalue = intrestDropdownList[0];
        }
      },
    );
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

//-------------new api
  getReviewListApi() async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/getUserReview'));
    request.fields.addAll({
      "user_id": widget.detailKey,
      "page_no": "1",
      "limit": "2",
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
}
