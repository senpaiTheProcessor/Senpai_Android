// ignore_for_file: prefer_const_constructors, avoid_print, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:senpai/Common/InputField.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
   


   
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Error Occurred: ${e.toString()} ");
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _UpdateConnectionState(result);
  }

  Future<void> _UpdateConnectionState(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      // showStatus(result, true);
    } else {
      showStatus(result, false);
    }
  }

  void showStatus(ConnectivityResult result, bool status) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content:
            Text("${status ? 'ONLINE\n' : 'OFFLINE\n'}${result.toString()} "),
        backgroundColor: status ? Colors.green : Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  UserModel? userModel;
  late Razorpay _razorpay;
  static const platform = const MethodChannel("razorpay_flutter");
  TextEditingController amountCon = TextEditingController();
  TextEditingController couponCon = TextEditingController();
  dynamic currentBalance = "00";
   dynamic walletCommission =00;
   dynamic callCommission =00;

  List walletHistoryData = [];
  bool? _isLoading = false;
  int _page = 1;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  ScrollController? _controller;
  String discount = "0";
  String resultCoupon = "0";
  String CouponId = "";
  dynamic actualAmount =00 ;
  dynamic totalWalletAmount =00;

  String orignal_ammount = "";
  int total_ammount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    
    discount = "0";
    orignal_ammount = " ";
    total_ammount = 0;
    currentBalance = "00";
    walletCommission =00;
   callCommission =00;
actualAmount =00 ;
    resultCoupon = "0";
    CouponId = "";
    totalWalletAmount =00;
    getUserModel();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    walletHistoryApi();
    _controller = ScrollController()..addListener(_loadMore);

    currentBalance = Preference().getString(Preference.CURRENT_BALANCE);
  }

  void getUserModel() async {
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    userModel = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print("userName...${userModel!.user_id}");
      print("object....${userModel!.device_token}");
      print("object2....${Preference().getString(Preference.DEVICE_TOKEN)}");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
    _controller!.removeListener(_loadMore);
  }

  void openCheckout() async {
    var options = {
      //rzp_test_YUim5Ug1qOPHmu
      'key': Preference().getString(Preference
          .REZORPAY_KEY), //'rzp_test_wyp8TneX6OfATk', // deven 'rzp_test_vbGc161A6tGYHa',
      'amount': total_ammount * 100,
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
    getCommission(response.paymentId!);
    // addWalletApi(response.paymentId!);

    // getCheckout("Online", response.paymentId!);
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId!,
    //     toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log("Error ${response.code.toString() + response.message!}");

    showToastMessage(
        "ERROR: " + response.code.toString() + " - " + response.message!,
        context);

    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log(response.walletName!);
    showToastMessage("EXTERNAL_WALLET: " + response.walletName!, context);

    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: " + response.walletName!,
    //     toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: blueCom,
        centerTitle: true,
        title: Text(
          "Wallet",
          style: btnWhite(context),
        ),
        leading: InkWell(
            onTap: (() {
              Navigator.pop(context, currentBalance.toString());
            }),
            child: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(
                child: Container(
                  //   height: MediaQuery.of(context).size.height/1.4,
                  child: Column(children: [
                    transation(),
                    rechargeWallet(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [payToProcess(), transfer()],
                      ),
                    ),
                    (resultCoupon == "1") ? goldrechargePack() : Container(),
                    discountApply(),
                    walletHistory(),
                  ]),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 5,bottom: 10),
              //   child: payToProcess(),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget transation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transation ",
            style: bottomheader(context),
          ),
          Container(
            decoration: BoxDecoration(
                color: white,
                border: Border.all(width: 1, color: Color(0xff646363)),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Current Balancet  :",
                    style: smollheader(context),
                  ),
                  Text(
                    "\u20B9" + currentBalance.toString(),
                    style: header(context),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget rechargeWallet() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
            color: grayShade, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: TextFieldDesign(
            key: Key("Amount"),
            textInputAction: TextInputAction.next,
            keyBoardType: TextInputType.phone,
            //focusNode: passwordFocus,
            hintText: 'Enter Amount',
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              child: Image.asset(
                "assets/logo/Amount.png",
                width: 10,
                height: 10,
              ),
            ),
            controller: amountCon,
            inputFormatterData: [],
            onChanged: (String value) {},
            onEditingComplete: () => {},
            onSaved: (String? newValue) {},
          ),
        ),
      ),
    );
  }

  Widget goldrechargePack() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
            color: white,
            border: Border.all(width: 1, color: Color(0xff646363)),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(children: [
          Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xffE5E5E5),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Wallet Discount",
                  textAlign: TextAlign.center,
                  style: bottomheader(context),
                ),
              )),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Amount",
                      style: smollheader(context),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Discount",
                      style: smollheader(context),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "\u20B9" + amountCon.text,
                      style: smollheader(context),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "- " + discount + " \u20B9",
                      style: smollheader(context),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: borderColor,
          ),
          // orignal_ammount=amountCon.text;
          // (amountCon.text-discount)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: bottomheader(context),
                ),
                Text(
                  "\u20B9" +
                      total_ammount.toString(), //((amountCon.text)-discount),
                  style: bottomheader(context),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget discountApply() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        // height: 48,
        child: TextFormField(
          keyboardType: TextInputType.text,
          controller: couponCon,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            counter: Offstage(),
            filled: true,
            suffixIcon: InkWell(
              onTap: (() {
                if (amountCon.text.toString().trim().isEmpty) {
                  return showToastMessage("Enter amount", context);
                } else if (couponCon.text.toString().trim().isEmpty) {
                  return showToastMessage("Enter Coupon", context);
                } else {
                  applycouponApi();
                }
              }),
              child: Container(
                  decoration: BoxDecoration(
                    color: blueCom,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0.0),
                        topRight: Radius.circular(12.0),
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(12.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    child: Text(
                      "Apply",
                      style: smollbtnWhite(context),
                    ),
                  )),
            ),
            fillColor: Color(0XFFFFFFFF),
            hintText: 'Have a Discount Code?',
            hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w600),
            errorStyle: TextStyle(/*fontFamily: monsterdRegular*/),
            contentPadding: const EdgeInsets.only(left: 8, top: 3),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: blueCom, width: 0.9),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black, width: 0.2),
            ),
          ),
        ),
      ),
    );
  }

// void getWalletCommission(){

//   var decimalConversion = commissionPercentage/100;
//   var actualAmount = decimalConversion* walletAmount;
//   print('get wallet commission...$actualAmount');
// }

  Widget walletHistory() {
    return walletHistoryData.length == 0
        ? Center(child: Text("No Data Found!"))
        : Container(
            height: MediaQuery.of(context).size.height / 2,
            child: ListView.builder(
              controller: _controller,
              itemCount: walletHistoryData.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                      color: white,
                      border: Border.all(width: 1, color: black),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity(vertical: -1),
                    leading: Container(
                      height: 55.0,
                      width: 55.0,
                      // decoration: BoxDecoration(
                      //     color: white,
                      //     border: Border.all(width: 1, color: grayShade),
                      //     borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: CircleAvatar(
                          radius: 50,
                          backgroundImage: ((walletHistoryData[index]
                                      ['other_user_id'] ==
                                  "0")
                              ? NetworkImage(userModel!.user_image)
                              : NetworkImage(walletHistoryData[index]
                                      ['other_user']['user_image'])
                                  //AssetImage('assets/images/profile.png')
                                  as ImageProvider)),
                    ),
                    title: Text(
                      (walletHistoryData[index]['other_user_id'] == "0"
                          ? userModel!.name
                          : walletHistoryData[index]['other_user']['name']
                              .toString()),
                      style: smollheader(context),
                    ),
                    subtitle: Text(
                      convertTime((walletHistoryData != null)
                          ? walletHistoryData[index]['created']
                          : ""),
                      style: verysmollheader2(context),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          ((walletHistoryData[index]['transaction_type']
                                      .toString() ==
                                  "1")
                              ? ("+" + walletHistoryData[index]['amount'])
                              : ("-" + walletHistoryData[index]['amount'])),
                          style: smollheader(context).copyWith(
                            color: walletHistoryData[index]
                                        ["transaction_type"] ==
                                    "1"
                                ? Colors.green
                                : Colors.redAccent,
                          ),
                        ),
                        (walletHistoryData[index]['is_settle'] == "1")
                            ? Text(
                                "Settled Ammount",
                                style: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                    color: blueCom),
                              )
                            : Text("")
                      ],
                    ),
                    isThreeLine: true,
                  ),
                ),
              ),
            ));
  }

  Widget payToProcess() {
    return InkWell(
      onTap: () {
        if (amountCon.text.toString().trim().isEmpty) {
          return showToastMessage("Enter amount", context);
        } else {
          total_ammount =
              int.parse(amountCon.text.toString()) - int.parse(discount);
          openCheckout();
        }
      },
      child: Container(
          width: MediaQuery.of(context).size.width / 2,
          // height: MediaQuery.of(context).size.height *0.06,
          color: blueCom,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
                child: Text(
              "Proceed To Pay",
              style: btnWhite(context),
            )),
          )),
    );
  }

  Widget transfer() {
    return InkWell(
      onTap: () {
        launch(
            'mailto:preetipateriya1997@gmail.com?subject=Withdraw a certain amount&body=Please send your UPI or account information to the address listed below if you would like to withdraw a certain amount.'
            '\n\n'
            'Account holder name'
            '\n'
            'account number'
            '\n'
            'IFSC code'
            '\n'
            'included in the details.');
      },

      // Please send your UPI or account information to the address listed below if you would like to withdraw a certain amount. Account holder name, account number, and IFSC code are included in the details.
      child: Container(
          width: MediaQuery.of(context).size.width / 3,
          // height: MediaQuery.of(context).size.height *0.06,
          color: blueCom,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
                child: Text(
              "Transfer",
              style: btnWhite(context),
            )),
          )),
    );
  }

  applycouponApi() {
    setState(() {
      _isLoading = true;
    });
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/applyCoupon'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "coupon_code": couponCon.text.toString(),
        "amount": amountCon.text.toString()
      },
    ).then(
      (response) {
        print("coupon..${response.body}");
        dynamic result1 = json.decode(response.body);

        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          discount = result1['discount'];

          print("dis..$discount");
          setState(() {
            discount = result1['discount'];
            resultCoupon = result1['status'].toString();
            CouponId = result1['coupon_id'];
            print("dis..$resultCoupon");
            print("dis..$CouponId");
            total_ammount =
                int.parse(amountCon.text.toString()) - int.parse(discount);
          });
          showToastMessage(mgs, context);
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>super.widget));
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
          return showToastMessage(mgs, context);
        }
      },
    );
  }

  getCommission(String transactionId) async {
    var request = http.Request('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}/UserAlpha/getCommission'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
      log("responseData...$responseData");
      walletCommission =responseData['wallet_commission'];
      callCommission =responseData['call_commission'];  
      print("commissions...$walletCommission..$callCommission");

      Preference().setString(Preference.Call_commission, responseData['call_commission']);
var decimalConversion = int.parse(walletCommission)/100;
  actualAmount = decimalConversion * int.parse(amountCon.text);
  totalWalletAmount =int.parse(amountCon.text) - actualAmount;

  print('get wallet commission...$actualAmount');
  print('get wallet commission...$totalWalletAmount');
  print('get callCommission...${Preference().getString(Preference.Call_commission)}');
  

     addWalletApi(transactionId);
    } else {
      print(response.reasonPhrase);
    }
  }

  addWalletApi(String transaction_Id) {

    print("");
    //  setState(() {
    //     _isLoading = true;
    //   });
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/addWallet'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "transaction_id": transaction_Id,
        "amount": totalWalletAmount.toString(),//amountCon.text.toString(), //This is wallet amount 
        "actual_amount": amountCon.text.toString(),   //total_ammount.toString(),//This is recharge amount
        "commission_amount": actualAmount.toString(),
        "commission": walletCommission.toString(),
        "coupon_id": CouponId,
        "discount": discount,

     
      },
    ).then(
      (response) {
        print("resGuide..${response.body}");
        dynamic result1 = json.decode(response.body);
        setState(() {
          currentBalance = result1['wallet_balance'].toString();
          Preference().setString(Preference.CURRENT_BALANCE, currentBalance);
        });
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          addwalletNotification(amountCon.text.toString());
          walletHistoryApi();
          Preference().setString(Preference.WALLET_PROFILE_PRETANCE, '30');
          return showToastMessage("Add wallet Successfully", context);
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
          return showToastMessage(mgs, context);
        }
      },
    );
  }

  walletHistoryApi() async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getWalletHistory'));
    request.fields.addAll({
      "user_id": userModel!.user_id,
      "security_code": userModel!.security_code,
      "page_no": "1",
      "limit": "10"
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
            walletHistoryData = [];
          });
        }
      } else if (responseData['status'] == 1) {
        print("walletHistoryData$walletHistoryData");
        if (mounted) {
          setState(() {
            walletHistoryData = responseData['wallet_history'];
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
    print("datas...${walletHistoryData.length}");

    setState(() {
      _isLoading = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isLoading == false &&
        _isLoadMoreRunning == false &&
        _controller!.position.extentAfter < 300) {
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
          Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/getWalletHistory'));
      request.fields.addAll({
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "page_no": _page.toString(),
        "limit": "10"
      });

      http.StreamedResponse response = await request.send();
      print("request...${request.fields}");
      if (response.statusCode == 200) {
        dynamic responseJson = await response.stream.bytesToString();
        dynamic responseData = json.decode(responseJson);

        print("load1..$responseData");
        if (responseData['status'] == 1) {
          List tempwalletHistoryData = responseData['wallet_history'];
          if (tempwalletHistoryData.length > 0) {
            setState(() {
              walletHistoryData.addAll(tempwalletHistoryData);
            });
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
      print("datas...${walletHistoryData.length}");
      if (mounted) {
        setState(() {
          _isLoadMoreRunning = false;
        });
      }
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
  //------convert zoneTime

  String convertTime(String vCreateTime) {
    // var dateTime =
    //     DateFormat("yyyy-MM-dd HH:mm:ss").parse("2022-07-04 08:51:57", true);
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(vCreateTime, true);
    var dateLocal = dateTime.toLocal();
    print("current..$dateLocal");
    return DateFormat('dd MMM,hh:mm a').format(dateLocal);
  }

  addwalletNotification(String amountCon) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAHO81Zwg:APA91bF1YYNjBumn6Fnb5Ii9-ChHCwxdN7to_xyk0NJbUq4-IDRBMtIbU00KeH4n2Y_2aIzCZZzBD5NyHV_ZrvA1R_db_z0_zpfr2u6rI9rzU6hFLTeDzphaYuxKSalTsvcBZtWIDnm2'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      //userModel!.device_token
      "to": Preference().getString(Preference.DEVICE_TOKEN),
      "priority": "high",
      "notification": {
        "title": "Add Wallet Amount",
        "body": "Recharge your Wallet amount " + amountCon + "\u20B9"
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
    } else {
      print(response.reasonPhrase);
    }
  }
}
