// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senpai/Common/Button.dart';
import 'package:senpai/Common/InputField.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/View/DashBord.dart';
import 'package:senpai/View/Verification.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/model/Language.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:senpai/model/cityModel.dart';
import 'package:senpai/model/countryModel.dart';
import 'package:senpai/model/intrestModel.dart';
import 'package:senpai/newEditProfile/select_intrest.dart';
import 'package:senpai/newEditProfile/select_language.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Prefrence/prefrence.dart';
import '../model/stateModel.dart';

class Registion extends StatefulWidget {
  const Registion({Key? key}) : super(key: key);

  @override
  State<Registion> createState() => _RegistionState();
}

class _RegistionState extends State<Registion> {
  //------------api values----------

  dynamic otp_ID = "";

  List<Country> _country = [];
  var countryData;
  Country? countryDropdownvalue;

  List<StateModel> _state = [];
  var stateData;
  StateModel? stateDropdownvalue;

  List<CityModel> _city = [];
  var cityData;
  CityModel? cityDropdownvalue;

  List<IntrestModel> _intrest = [];
  var IntrestData;
  final List<LanguageModel> _language = [];
  final List<String> _languageIds = [];
  final List<String> _intrestIds = [];
  final List<String> _intrestIds1 = [];

  //------api values end

  FocusNode? myFocusNode;
  final FocusNode mobFocus = FocusNode();
  final FocusNode codeFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode countryFocus = FocusNode();
  final FocusNode stateFocus = FocusNode();
  final FocusNode cityFocus = FocusNode();
  final FocusNode languageFocus = FocusNode();
  TextEditingController codeCon = TextEditingController();
  TextEditingController mobCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController countryCon = TextEditingController();
  TextEditingController stateCon = TextEditingController();
  TextEditingController cityCon = TextEditingController();
  TextEditingController languageCon = TextEditingController();

  void _LangeuageNAvigate(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SelectLaguage(languageIds: _languageIds)),
    );
    if (result != null) {
      _language.clear();
      _languageIds.clear();
      for (var item in result) {
        print("result_language...${item.toString()}");
        print("result_language...${item.language_id.toString()}");
        if (item.is_selected == "1") {
          _language.add(item);
          _languageIds.add(item.language_id);
        }
      }
      print("result_selected112...${_languageIds.join(",")}");
      setState(() {});
    }
  }

  //---Intreset
  void _IntresetNavigator(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SelectIntrest(
                interstIds: _intrestIds,
              )),
    );
    if (result != null) {
      _intrest.clear();
      _intrestIds.clear();
      for (var item in result) {
        print("result_Intreset...${item.toString()}");
        print("result_Intreset...${item.interest_id.toString()}");
        if (item.is_selected == "1") {
          _intrest.add(item);
          _intrestIds.add(item.interest_id);
          _intrestIds1.add(item.interest_name);
        }
      }
      print("result_selectedIntreset112...${_intrestIds1.join(",")}");
      setState(() {});
    }
  }

  bool value = false;
  bool _obscureText = true;
  bool _termsChecked = false;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool? _isLoading = false;
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
      showStatus(result, true);
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

  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationId = "";

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);
    Country country = Country("", "Select Country", "", "");
    _country.add(country);
    countryDropdownvalue = _country[0];
    StateModel stateModel = StateModel(
      "",
      "",
      "Select State",
    );
    _state.add(stateModel);
    stateDropdownvalue = _state[0];
    CityModel cityModel = CityModel("", "", "Select City");
    _city.add(cityModel);
    cityDropdownvalue = _city[0];
    getCountryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: blueCom,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Registration",
            style: btnWhite(context),
          ),
        ),
        body: Stack(
          children: [allFileds(), LoaderIndicator(_isLoading!)],
        ));
  }

  Widget allFileds() {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        headers(),
        inputs(),
        _addLanguage(),
        _addIntrest(),
        termCondition(),
        registrationBtn(),
        registionText()
      ]),
    );
  }

  Widget headers() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 10),
            child: Image.asset(
              "assets/logo/logo_senpai.png",
            ),
          ),
          Text("Sign-up", style: header(context)),
          Text("Create a new account", style: subheader(context))
        ],
      ),
    );
  }

  Widget inputs() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 17),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: Color(0xffF4F4F4)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Column(children: [
            nameInput(),
            mobileInput(),
            emailInput(),
            countryDropdown(),
            stateDropdown(),
            cityDropdown(),
            passwordInput(),
          ]),
        ),
      ),
    );
  }

  Widget nameInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: TextFieldDesign(
        key: Key("Name"),
        textInputAction: TextInputAction.next,
        controller: nameCon,
        keyBoardType: TextInputType.text,
        focusNode: nameFocus,
        hintText: 'Name *',
        prefixIcon: Icon(
          Icons.person_outline,
          color: black,
          size: 20,
        ),
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () =>
            {FocusScope.of(context).requestFocus(mobFocus)},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget mobileInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: TextFieldDesign(
              key: Key("Phone"),
              textInputAction: TextInputAction.next,
              controller: codeCon,
              keyBoardType: TextInputType.phone,
              maxlength: 6,
              focusNode: codeFocus,
              hintText: 'Country Code*',
              inputFormatterData: [],
              onChanged: (String value) {},
              onEditingComplete: () =>
                  {FocusScope.of(context).requestFocus(mobFocus)},
              onSaved: (String? newValue) {},
            ),
          ),
          Flexible(
            flex: 3,
            child: TextFieldDesign(
              key: Key("Phone"),
              textInputAction: TextInputAction.next,
              controller: mobCon,
              keyBoardType: TextInputType.phone,
              maxlength: 14,
              focusNode: mobFocus,
              hintText: 'Phone *',
              prefixIcon: Icon(
                Icons.call_outlined,
                color: black,
                size: 20,
              ),
              inputFormatterData: [],
              onChanged: (String value) {},
              onEditingComplete: () =>
                  {FocusScope.of(context).requestFocus(emailFocus)},
              onSaved: (String? newValue) {},
            ),
          ),
          // CountryPickerDropdown(
          //   initialValue: 'in',
          //   itemBuilder: _buildDropdownItem,
          //   onValuePicked: (Country country) {
          //     print("${country.name}");
          //   },
          // )
        ],
      ),
    );
  }

  // Widget _buildDropdownItem(Country country) => Container(
  //       child: Row(
  //         children: <Widget>[
  //           CountryPickerUtils.getDefaultFlagImage(country),
  //           SizedBox(
  //             width: 8.0,
  //           ),
  //           Text("+${country.phoneCode}(${country.isoCode})"),
  //         ],
  //       ),
  //     );

  Widget emailInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: TextFieldDesign(
        key: Key("Email"),
        textInputAction: TextInputAction.next,
        controller: emailCon,
        keyBoardType: TextInputType.emailAddress,
        focusNode: emailFocus,
        hintText: 'Email *',
        prefixIcon: Icon(
          Icons.email_outlined,
          color: black,
          size: 20,
        ),
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () =>
            {FocusScope.of(context).requestFocus(countryFocus)},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget countryInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: TextFieldDesign(
        key: Key("Country"),
        textInputAction: TextInputAction.next,
        controller: countryCon,
        keyBoardType: TextInputType.text,
        focusNode: countryFocus,
        hintText: 'Country',
        prefixIcon: Icon(
          Icons.email_outlined,
          color: black,
          size: 20,
        ),
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () =>
            {FocusScope.of(context).requestFocus(stateFocus)},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget stateInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: TextFieldDesign(
        key: Key("State"),
        textInputAction: TextInputAction.next,
        controller: stateCon,
        keyBoardType: TextInputType.text,
        focusNode: stateFocus,
        hintText: 'State',
        prefixIcon: Icon(
          Icons.email_outlined,
          color: black,
          size: 20,
        ),
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () =>
            {FocusScope.of(context).requestFocus(cityFocus)},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget cityInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: TextFieldDesign(
        key: Key("City"),
        textInputAction: TextInputAction.next,
        controller: cityCon,
        keyBoardType: TextInputType.text,
        focusNode: cityFocus,
        hintText: 'City',
        prefixIcon: Icon(
          Icons.location_on_outlined,
          color: black,
          size: 20,
        ),
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () =>
            {FocusScope.of(context).requestFocus(languageFocus)},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget langagueInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: TextFieldDesign(
        key: Key("Language"),
        textInputAction: TextInputAction.next,
        controller: languageCon,
        keyBoardType: TextInputType.text,
        focusNode: languageFocus,
        hintText: 'Language *',
        prefixIcon: Icon(
          Icons.email_outlined,
          color: black,
          size: 20,
        ),
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () =>
            {FocusScope.of(context).requestFocus(passwordFocus)},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: TextFieldDesign(
        key: Key("Password"),
        textInputAction: TextInputAction.done,
        controller: passwordCon,
        keyBoardType: TextInputType.text,
        obsecureText: _obscureText,
        focusNode: passwordFocus,
        hintText: 'Password *',
        prefixIcon: Icon(
          Icons.lock,
          color: black,
          size: 20,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
              color: black, size: 20),
        ),
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {FocusScope.of(context).unfocus()},
        onSaved: (String? newValue) {},
      ),
    );
  }

  //-----------by shraddha--------------

  onPresedLogin() {
    if (nameCon.text.toString().trim().isEmpty) {
      return showToastMessage("Enter  Name", context);
    } else if (!RegExp('[a-zA-Z]').hasMatch(nameCon.text.toString())) {
      return showToastMessage("Enter a valid Name", context);
    } else if (codeCon.text.toString().trim().isEmpty) {
      return showToastMessage("Enter Country code", context);
    } else if (mobCon.text.toString().trim().isEmpty) {
      return showToastMessage("Enter your Mobile Number", context);
    } else if (mobCon.text.length < 10 || mobCon.text.length > 14) {
      return showToastMessage("Enter a valid Mobile Number", context);
    } else if (emailCon.text.trim().toString().isEmpty) {
      return showToastMessage("Enter your Email", context);
    } else if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(emailCon.text.trim().toString())) {
      return showToastMessage("Enter a valid Email", context);
    } else if (countryDropdownvalue!.country_id.toString().isEmpty) {
      return showToastMessage("Select Country.", context);
    } else if (stateDropdownvalue!.state_id.toString().isEmpty) {
      return showToastMessage("Select State.", context);
    } else if (cityDropdownvalue!.city_id.toString().isEmpty) {
      return showToastMessage("Select City.", context);
    } else if (passwordCon.text.toString().isEmpty) {
      return showToastMessage("Enter your Password", context);
    } else if (_language.length == 0) {
      return showToastMessage("Select Language.", context);
    } else if (_intrest.length == 0) {
      return showToastMessage("Select Interest.", context);
    } else if (_termsChecked != true) {
      return showToastMessage("You need to accept terms & condition.", context);
    } else {
      saveUserData();
      emailMoblieAlredayExitApi();
    }
  }

  Widget registrationBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Button(
          key: Key('registration_button'),
          buttonName: "Registration",
          onPressed: () {
            onPresedLogin();
          },
        ),
      ),
    );
  }

  Widget registionText() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: RichText(
          text: TextSpan(
            text: 'Already have an account?',
            style: bottomheader(context),
            children: [
              TextSpan(text: ' Login here.', style: blueheader(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget termCondition() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: CheckboxListTile(
        activeColor: Theme.of(context).accentColor,
        title: Text(
          'By clicking Signup you agree all the Terms & Conditions.',
          style: verysmollheader(context).copyWith(fontSize: 9),
        ),
        value: _termsChecked,
        onChanged: (bool? value) => setState(() {
          _termsChecked = value!;
          _showMyDialog();
        }),

        // setState(() => _termsChecked = value!),
      ),
    );
  }

  Widget countryDropdown() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: MediaQuery.of(context).size.width * .12,
          width: MediaQuery.of(context).size.width * .85,
          decoration: BoxDecoration(
            color: Color(0XFFFFFFFF),
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Country>(
                value: countryDropdownvalue,
                icon: Icon(Icons.keyboard_arrow_down),
                items: _country.map<DropdownMenuItem<Country>>((Country value) {
                  return DropdownMenuItem<Country>(
                    value: value,
                    child: Text(
                      value.country_name,
                      style: verysmollheader2(context),
                    ),
                  );
                }).toList(),
                onChanged: (Country? value) {
                  setState(() {
                    countryDropdownvalue = value!;
                    print("${countryDropdownvalue!.country_id}");
                    getStateData(countryDropdownvalue!.country_id);
                    _city.clear();
                    CityModel cityModel = CityModel("", "", "Select City");
                    _city.add(cityModel);
                    cityDropdownvalue = _city[0];
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget stateDropdown() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Container(
          height: MediaQuery.of(context).size.width * .12,
          width: MediaQuery.of(context).size.width * .85,
          decoration: BoxDecoration(
            color: Color(0XFFFFFFFF),
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<StateModel>(
                value: stateDropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: _state
                    .map<DropdownMenuItem<StateModel>>((StateModel value) {
                  return DropdownMenuItem<StateModel>(
                    value: value,
                    child: Text(
                      value.state_name,
                      style: verysmollheader2(context),
                    ),
                  );
                }).toList(),
                onChanged: (StateModel? value) {
                  setState(() {
                    stateDropdownvalue = value!;
                    getcityData(stateDropdownvalue!.state_id);
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cityDropdown() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        child: Container(
          height: MediaQuery.of(context).size.width * .12,
          width: MediaQuery.of(context).size.width * .85,
          decoration: BoxDecoration(
            color: Color(0XFFFFFFFF),
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CityModel>(
                value: cityDropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items:
                    _city.map<DropdownMenuItem<CityModel>>((CityModel value) {
                  return DropdownMenuItem<CityModel>(
                    value: value,
                    child: Text(
                      value.city_name,
                      style: verysmollheader2(context),
                    ),
                  );
                }).toList(),
                onChanged: (CityModel? value) {
                  setState(() {
                    cityDropdownvalue = value!;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  //------------Country---------------
  getCountryData() async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getCountry');
    var response = await http.post(url, body: {});
    countryData = json.decode(response.body.toString());
    countryData = countryData['country'];
    print("countryData....${response.body}");
    _country.clear();
    Country country = Country("", "Select Country", "", "");
    _country.add(country);
    for (int i = 0; i < countryData.length; i++) {
      var countryDataList = countryData[i];
      Country country = Country(
          countryDataList['country_id'],
          countryDataList['country_name'],
          countryDataList['country_code'],
          countryDataList['country_phone_code']);
      _country.add(country);
    }
    print(_country.length);
    print("country....$countryData");
    print("country....${countryData[1]['country_name']}");
    print("${countryData[1]['country_id']}");
    setState(() {
      setState(() {
        _isLoading = false;
      });
      countryDropdownvalue = _country[0];
      print(countryDropdownvalue!.country_id);
    });
    return json.decode(response.body.toString());
  }

  //-----------Get state-------------
  getStateData(String country_Id) async {
    setState(() {
      _isLoading = true;
    });
    print(country_Id);
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getState');
    var response = await http.post(url, body: {"country_id": country_Id});
    stateData = json.decode(response.body.toString());
    stateData = stateData['state'];
    print("stateData....${response.body}");
    _state.clear();

    StateModel stateModel = StateModel(
      "",
      "",
      "Select State",
    );
    _state.add(stateModel);
    try {
      for (int i = 0; i < stateData.length; i++) {
        var stateDataList = stateData[i];
        StateModel stateModel = StateModel(stateDataList['country_id'],
            stateDataList['state_id'], stateDataList['state_name']);
        _state.add(stateModel);
      }
    } catch (e) {}
    print(_state.length);
    setState(() {
      setState(() {
        _isLoading = false;
      });
      stateDropdownvalue = _state[0];
    });
    return json.decode(response.body.toString());
  }

  //-----------Get state-------------
  getcityData(String state_id) async {
    setState(() {
      _isLoading = true;
    });
    print(state_id);

    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getCity');
    var response = await http.post(url, body: {"state_id": state_id});
    cityData = json.decode(response.body.toString());
    cityData = cityData['city'];
    print("cityData....${response.body}");
    _city.clear();
    CityModel cityModel = CityModel("", "", "Select City");
    _city.add(cityModel);
    try {
      for (int i = 0; i < cityData.length; i++) {
        var cityDataList = cityData[i];
        CityModel cityModel = CityModel(cityDataList['city_id'],
            cityDataList['state_id'], cityDataList['city_name']);
        _city.add(cityModel);
      }
    } catch (e) {}
    print(_city.length);
    setState(() {
      setState(() {
        _isLoading = false;
      });
      cityDropdownvalue = _city[0];
    });
    return json.decode(response.body.toString());
  }

//-----sendOtp----
  sendOTPSignUp() async {
    setState(() {
      _isLoading = true;
    });
    http.post(
      Uri.parse("${APIConstants.senpaiBaseUrl}user/sendOtp"),
      body: {
        "mobile_number": mobCon.text,
      },
    ).then(
      (response) {
        print("Optsend.....${response.body}");
        dynamic result = json.decode(response.body);
        String message = result['message'];
        if (result['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          Preference()
              .setString(Preference.OTP_ID, result['otp_id'].toString());

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Verification(
                        moblieKey: mobCon.text,
                      )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(message),
            ),
          );
        }
      },
    );
  }

  Widget _addLanguage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 17),
      child: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Languages",
                    style: bottomheader(context),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Align(
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
                                text:
                                    "Select Langauges to showcase your expertise",
                                style: subheader(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (() {
                      FocusScope.of(context).unfocus();

                      _LangeuageNAvigate(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectLaguage()));
                    }),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .36,
                      height: MediaQuery.of(context).size.height * .04,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Text("Add Language"),
                      ),
                    ),
                  ),
                ),
              ),
              _languageWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _addIntrest() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 17),
      child: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Interests",
                    style: bottomheader(context),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Align(
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
                                text:
                                    "Select Intrest to showcase your expertise",
                                style: subheader(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (() {
                      FocusScope.of(context).unfocus();
                      _IntresetNavigator(context);
                    }),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .36,
                      height: MediaQuery.of(context).size.height * .04,
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Text("Add Interest"),
                      ),
                    ),
                  ),
                ),
              ),
              _IntrestWidget()
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
              ],
            ),
          ),
        ));
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

  //--------------check moblie number----
  emailMoblieAlredayExitApi() async {
    setState(() {
      _isLoading = true;
    });
    http.post(
      Uri.parse("${APIConstants.senpaiBaseUrl}user/checkEmail"),
      body: {"mobile_number": mobCon.text, "email_id": emailCon.text},
    ).then(
      (response) {
        dynamic result = json.decode(response.body);
        String message = result['message'];
        if (result['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          //---New changes
          //  sendOTPSignUp();
          Preference().setString(Preference.PASSWORD, passwordCon.text);

          fetchotp();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(message),
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }

  void saveUserData() {
    UserModel userModel = UserModel(
        name: nameCon.text.toString(),
        email_id: emailCon.text.toString(),
        mobile_number: mobCon.text.toString(),
        country_id: countryDropdownvalue!.country_id,
        state_id: stateDropdownvalue!.state_id,
        city_id: cityDropdownvalue!.city_id,
        language_id: _languageIds.join(","),
        interest_id: _intrestIds.join(","),
        rate_amount: '',
        device_type: "1",
        device_token: Preference().getString(Preference.DEVICE_TOKEN)!,
        user_image: "",
        user_id: '',
        user_unique_id: '',
        security_code: '',
        language: [],
        interest: [],
        start_time: '',
        end_time: '');
    String userModelStr = jsonEncode(userModel);
    print("saveuserData...$userModelStr");
    print("saveuserData...${_intrestIds.join(",")}");

    Preference().setString(Preference.USER_MODEL, userModelStr);
    getUserModel();
  }

  void getUserModel() async {
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    var user = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print("mobile...${user.name}");
      print("mobile...${user.mobile_number}");
      print("language...${user.language_id}");
      print("intreset...${user.interest_id}");
      print("intreset...${user.rate_amount}");
      print("start_time...${user.start_time}");
      print("end_time...${user.end_time}");
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            height: 30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: Center(
              child: Text(
                "Terms and Conditions".toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
          content: Container(
            height: 100,
            width: 90,
            decoration: BoxDecoration(
                // color: Colors.red,
                ),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    text:
                        "By accepting all terms and privacy and data security purprose, visit our link:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    launch(
                        "https://senpai.co.in/index.php/UserAlpha/getPolicy/1");
                  },
                  child: Text(
                    "https://senpai.co.in/index.php/UserAlpha/getPolicy/1",
                    style: TextStyle(color: Colors.blue, fontSize: 10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) => Dashboard()));
                    },
                    child: Container(
                      height: 28,
                      width: MediaQuery.of(context).size.width * .3,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Agree',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchotp() async {
    await auth.verifyPhoneNumber(
      phoneNumber: codeCon.text + mobCon.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
          return showToastMessage("hone number is not valid.", context);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // this.verificationId = verificationId;
        print("vId$verificationId");

        setState(() {
          verificationId = verificationId;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Verification(
                      // phonenumber: _phonenumber.text,
                      // auth: auth,
                      verificationID: verificationId)));
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Future<void> verify() async {
  //   PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
  //       verificationId: verificationId, smsCode: otpController.text);

  //   signInWithPhoneAuthCredential(phoneAuthCredential);
  // }
}
