// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unused_field, prefer_typing_uninitialized_variables, unrelated_type_equality_checks, avoid_print, prefer_final_fields, prefer_is_empty, sized_box_for_whitespace, file_names, prefer_adjacent_string_concatenation, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_local_variable, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/borderInputFileds.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/model/Language.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:senpai/model/cityModel.dart';
import 'package:senpai/model/countryModel.dart';
import 'package:senpai/model/intrestModel.dart';
import 'package:senpai/model/stateModel.dart';
import 'package:senpai/newEditProfile/Location.dart';
import 'package:senpai/newEditProfile/bio.dart';
import 'package:senpai/newEditProfile/education.dart';
import 'package:senpai/newEditProfile/occupation.dart';
import 'package:senpai/newEditProfile/select_intrest.dart';
import 'package:senpai/newEditProfile/select_language.dart';
import 'package:senpai/src/cropper.dart';
import 'package:senpai/src/options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/Button.dart';
import 'experince.dart';
import 'package:http/http.dart' as http;

class NewEditProfile extends StatefulWidget {
  const NewEditProfile({Key? key}) : super(key: key);

  @override
  State<NewEditProfile> createState() => _NewEditProfileState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _NewEditProfileState extends State<NewEditProfile> {
  UserModel? userModel;
  File? profileLogo;
  AppState? state = AppState.free;

  void getUserModel() async {
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    userModel = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      nameCon.text = userModel!.name;
      emailCon.text = userModel!.email_id;
      mobCon.text = userModel!.mobile_number;
      setState(() {
        perminCon.text = Preference().getString(Preference.RATE_AMMOUNT)!;
      }); //userModel!.rate_amount;

      print("userName...${userModel!.name}");
      print("mobile_number..${userModel!.mobile_number}");
      print("language_id...${userModel!.language_id}");
      print("interest_id...${userModel!.interest_id}");
      print("country_id...${userModel!.country_id}");
      print("state_id...${userModel!.state_id}");
      print("city_id...${userModel!.city_id}");
      print("email_id...${userModel!.email_id}");
      print("security_code...${userModel!.security_code}");
      print("languageModel...${userModel!.language}");
      print("interstedModel...${userModel!.interest}");
      print("user_Image...${userModel!.user_image}");
      print("rate_amount...${userModel!.rate_amount}");
      print("rate_amount...${Preference().getString(Preference.RATE_AMMOUNT)}");

      for (var element in userModel!.language) {
        _language.add(LanguageModel(
          language_id: element['language_id'],
          language_name: element['language_name'],
        ));
        print("language_id...${element['language_id']}");
      }
      for (var element in userModel!.interest) {
        _intrest.add(IntrestModel(
          interest_id: element['interest_id'],
          interest_name: element['interest_name'],
        ));
        print("language_id...${element['interest_id']}");
      }
    }
  }

  bool? _isLoading = false;
  List<Country> _country = [];
  var countryData;
  Country? countryDropdownvalue;

  List<StateModel> _state = [];
  var stateData;
  StateModel? stateDropdownvalue;

  List<CityModel> _city = [];
  var cityData;
  CityModel? cityDropdownvalue;

  List stateDataList = [];

  FocusNode? myFocusNode;
  final FocusNode perminFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode mobFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode bioFocus = FocusNode();

  TextEditingController perminCon = TextEditingController();
  TextEditingController mobCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  // TextEditingController countryCon = TextEditingController();
  // TextEditingController stateCon = TextEditingController();
  // // TextEditingController cityCon = TextEditingController();
  // TextEditingController languageCon = TextEditingController();
  // TextEditingController bioCon = TextEditingController();

  File? photoProfile;
  String business_logo = "";

  ImagePicker pickImage = ImagePicker();
  DateTime selectedDateIndustrialformYear = DateTime.now();

  //-----------imagepicker-----------

  String? discription = "";
  List<IntrestModel> _intrest = [];
  var IntrestData;
  List<LanguageModel> _language = [];
  final List<String> _languageIds = [];
  final List<String> _intrestIds = [];
  dynamic getUserProfileData = [];
  dynamic experience = [];
  dynamic education = [];
  dynamic location = [];
  dynamic occupation = [];
  dynamic intresetList = [];
  dynamic currentWallectBalance = "";
  dynamic rate_ammount = "";

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

  //---Intreset
  void _IntresetNavigator(BuildContext context) async {
    List<String> interstIds = [];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SelectIntrest(interstIds: interstIds)),
    );
    if (result != null) {
      _getUserProfileApi();
    }
  }

  void _BioNavigator(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => summaryPage(
                bioKey: discription,
              )),
    );
    if (result != null) {
      setState(() {
        print("result_bio..." + result.toString());
        setState(() {
          discription = result.toString();
        });

        setState(() {});
      });
    }
  }

  String datemain(String dateStr) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    DateFormat dateFormat1 = DateFormat('dd MMM yyyy');
    DateTime dateTime = dateFormat.parse(dateStr);
    return dateFormat1.format(dateTime);
  }

  void _experienceNavigator(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ExpreincePage(
                experinceEditkey: false,
              )),
    );
    if (result != null) {
      setState(() {
        print("result_Experince..." + result.toString());
        // setState(() {
        //   discription = result.toString();
        // });

        setState(() {
          _getUserProfileApi();
        });
      });
    }
  }

  void _experienceNavigator2(BuildContext context, index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ExpreincePage(
                experinceEditkey: true,
                expreincekey: experience[index],
              )),
    );
    if (result != null) {
      setState(() {
        print("result_Experince..." + result.toString());
        // setState(() {
        //   discription = result.toString();
        // });

        setState(() {
          _getUserProfileApi();
        });
      });
    }
  }

  void _educationNavigator(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EducationPage(
                educationEditkey: false,
              )),
    );
    if (result != null) {
      setState(() {
        print("result_Experince..." + result.toString());
        setState(() {
          _getUserProfileApi();
        });
      });
    }
  }

  void _educationNavigator2(BuildContext context, index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EducationPage(
                educationEditkey: true,
                educationkey: education[index],
              )),
    );
    if (result != null) {
      setState(() {
        print("result_Experince..." + result.toString());
        setState(() {
          _getUserProfileApi();
        });
      });
    }
  }

  void _locationNavigator(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LocationPage(
                locationEditkey: false,
              )),
    );
    if (result != null) {
      setState(() {
        print("result_Experince..." + result.toString());

        setState(() {
          _getUserProfileApi();
        });
      });
    }
  }

  void _locationNavigator2(BuildContext context, index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LocationPage(
              locationEditkey: true, locationkey: location[index])),
    );
    if (result != null) {
      setState(() {
        print("result_Experince..." + result.toString());

        setState(() {
          _getUserProfileApi();
        });
      });
    }
  }

  void _occupationNavigator(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OccupationPage(
                occupationEditkey: false,
              )),
    );
    if (result != null) {
      setState(() {
        print("result_Experince..." + result.toString());

        setState(() {
          _getUserProfileApi();
        });
      });
    }
  }

  void _occupationNavigator2(BuildContext context, index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OccupationPage(
              occupationEditkey: true, occupationkey: occupation[index])),
    );
    if (result != null) {
      setState(() {
        print("result_Experince..." + result.toString());

        setState(() {
          _getUserProfileApi();
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    rate_ammount = Preference().getString(Preference.RATE_AMMOUNT);
    print("rate..${rate_ammount}");
    getUserModel();
    //  perminCon.text=rate_ammount;
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
    getStateData(userModel!.country_id);
    getcityData(userModel!.state_id);
    _getUserProfileApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: blueCom,
          centerTitle: true,
          title: Text(
            "Edit Proflie",
            style: btnWhite(context),
          ),
          leading: InkWell(
              onTap: (() {
                Navigator.pop(context, userModel!.user_image);
              }),
              child: Icon(Icons.arrow_back)),
        ),
        body: Stack(
          children: [
            allField(),
            LoaderIndicator(_isLoading!),
          ],
        ));
  }

  Widget allField() {
    return SingleChildScrollView(
        child: Column(children: [
      editProflie(),
      _bio(),
      _addLanguage(),
      _addIntrest(),
      exprienceList(),
      educationList(),
      LocationList(),
      occputionList(),
      updateProfileBtn()
    ]));
  }

  Widget editProflie() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              color: white,
              border: Border.all(width: 1, color: Color(0xff646363)),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(children: [
            inputFleilds(),
          ])),
    );
  }


  Widget inputFleilds() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        // img(),
        profileAndLogo(),
        // Text(
        //   "Since Year 2015 ",
        //   style: verysmollheader(context),
        // ),
        SizedBox(
          height: 10,
        ),
        perMiniteInput(),
        nameInput(),
        phoneInput(),
        emailInput(),
        countryDropdown(),
        stateDropdown(),
        cityDropdown(),
        SizedBox(
          height: 6,
        ),
      ],
    );
  }

//---------------------image crop start
  Widget profileAndLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(clipBehavior: Clip.none, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(width: 1, color: grayShade),
                  borderRadius: const BorderRadius.all(Radius.circular(80))),
              child: profileLogo == null
                  ? ((userModel!.user_image.length > 0)
                      ? ClipOval(
                          child: Image.network(
                            userModel!.user_image,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset('assets/images/uprofile.png'))
                  : imagee2(),
            ),
          ),
          Positioned(
            top: 80,
            right: 10,
            child: InkWell(
                onTap: () {
                  //if (state == AppState.free)
                  _bottomsheet();
                  // else if (state == AppState.picked)
                  //   _cropImage();
                  // else if (state == AppState.cropped) _clearImage();
                },
                child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(width: 2, color: white),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: _buildButtonIcon())),
          ),
        ])
      ],
    );
  }

  Widget _buildButtonIcon() {
    // if (state == AppState.free)
    return Icon(Icons.add, color: black);
    // else
    // if (state == AppState.picked)
    //   return Icon(Icons.crop, color: black);
    // else if (state == AppState.cropped)
    //   return Icon(Icons.clear, color: black);
    // else
    //   return Container();
    // else;
    // return Container(state == AppState.free);
  }

  Widget imagee2() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          color: white,
          border: Border.all(width: 1, color: grayShade),
          borderRadius: const BorderRadius.all(Radius.circular(80))),
      child: ClipOval(
        child: Image.file(
          profileLogo!,
          fit: BoxFit.cover,
          height: 10,
          width: 15,
        ),
      ),
    );
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: profileLogo!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: blueCom,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      profileLogo = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
      Navigator.pop(context);
      updateProfile();
    }
  }

  void _clearImage() {
    profileLogo = null;
    setState(() {
      state = AppState.free;
    });
  }

  Widget? _bottomsheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: () async {
                      // await ImagePicker()
                      //     // ignore: deprecated_member_use
                      //     .pickImage(source: ImageSource.gallery)
                      //     .then((value) {
                      //   if (value != null) {
                      //     profileLogo = File(value.path);
                      //   }
                      //   setState(() {
                      //   profileLogo = profileLogo;
                      //   });
                      //   Navigator.pop(context);
                      // });
                      final pickedImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      profileLogo =
                          pickedImage != null ? File(pickedImage.path) : null;
                      if (profileLogo != null) {
                        setState(() {
                          state = AppState.picked;
                        });
                        _cropImage();
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_camera_back_outlined,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .03,
                        ),
                        Text("Pick From Gallery"),
                      ],
                    )),
                InkWell(
                    onTap: () async {
                      final pickedImage = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      profileLogo =
                          pickedImage != null ? File(pickedImage.path) : null;
                      if (profileLogo != null) {
                        setState(() {
                          state = AppState.picked;
                        });
                        _cropImage();
                      }
                      // await ImagePicker()
                      //     // ignore: deprecated_member_use
                      //     .pickImage(source: ImageSource.camera)
                      //     .then((value) {
                      //   if (value != null) {
                      //     profileLogo = File(value.path);
                      //   }
                      //   setState(() {
                      //     profileLogo = profileLogo;
                      //   });
                      //   Navigator.pop(context);
                      // });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .03,
                        ),
                        Text("Pick From Camera"),
                      ],
                    )),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget perMiniteInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 0.2),
        ),
        child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "\u20B9" + "  ${perminCon.text}" + ' /min',
                style: TextStyle(
                    //   color: WeatherTheme.weatherBalck,
                    color: black,
                    fontSize: 13,
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.w600
                    // fontFamily: "helvetica-light-587ebe5a59211",
                    ),
              ),
            )),
      ),
    );
  }

  Widget nameInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: TextFieldDesignBorder(
        key: Key("Name"),
        textInputAction: TextInputAction.next,
        keyBoardType: TextInputType.name,
        focusNode: nameFocus,
        hintText: "Name",
        controller: nameCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () =>
            {FocusScope.of(context).requestFocus(mobFocus)},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget phoneInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: TextFieldDesignBorder(
        key: Key("Phone"),
        textInputAction: TextInputAction.next,
        keyBoardType: TextInputType.phone,
        focusNode: mobFocus,
        hintText: "Phone",
        controller: mobCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () =>
            {FocusScope.of(context).requestFocus(emailFocus)},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: TextFieldDesignBorder(
        key: Key("Email"),
        textInputAction: TextInputAction.next,
        keyBoardType: TextInputType.emailAddress,
        focusNode: emailFocus,
        hintText: "Email",
        controller: emailCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () =>
            {FocusScope.of(context).requestFocus(bioFocus)},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget exprienceList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
                  InkWell(
                      onTap: (() {
                        _experienceNavigator(context);
                      }),
                      child: Icon(
                        Icons.add,
                        size: 35,
                      ))
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
                                      width: 60,
                                    ),
                                    Container(
                                      // color: Colors.red,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: RichText(
                                        text: TextSpan(
                                          text: experience[index]['exp_title'],
                                          style: subheaderdark(context),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:"\n" + experience[index]
                                                        ['company_name'] +
                                                    "." +
                                                    " ",
                                                style:
                                                    smollheadertext(context)),
                                            TextSpan(
                                                text: experience[index]
                                                        ['emp_type'] +
                                                    " ",
                                                style:
                                                    smollheadertext(context)),
                                            TextSpan(
                                                text: experience[index]
                                                        ['type_name'] +
                                                    " ",
                                                style:
                                                    smollheaderlight(context)),
                                            TextSpan(
                                                text: datemain(
                                                      experience[index]
                                                          ['start_date'],
                                                    )
                                                    //  experience[index]
                                                    //         ['start_date']
                                                    +
                                                    " - " +
                                                    datemain(
                                                      experience[index]
                                                          ['end_date'],
                                                    ) +
                                                    "\t\t\t",
                                                style:
                                                    smollheaderlight(context)),
                                            TextSpan(
                                                text: experience[index]
                                                    ['location'],
                                                style:
                                                    smollheaderlight(context)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: (() {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             ExpreincePage(
                                          //               expreincekey:
                                          //                   experience[index],experinceEditkey:true

                                          //             )));
                                          _experienceNavigator2(context, index);
                                        }),
                                        child: Icon(Icons.edit)),
                                    InkWell(
                                        onTap: (() {
                                          deleteExperiancesByID(
                                              experience[index]
                                                  ['user_experience_id']);
                                        }),
                                        child: Icon(
                                          Icons.delete_outline_outlined,
                                          color: Colors.red,
                                        ))
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
      ),
    );
  }

  Widget educationList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
                  InkWell(
                      onTap: (() {
                        _educationNavigator(context);
                      }),
                      child: Icon(
                        Icons.add,
                        size: 35,
                      ))
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
                                    // Container(
                                    //   height: 70.0,
                                    //   width: 70.0,
                                    //   decoration: BoxDecoration(
                                    //       color: white,
                                    //       border: Border.all(
                                    //           width: 1, color: grayShade),
                                    //       borderRadius: const BorderRadius.all(
                                    //           Radius.circular(50))),
                                    //   child: const CircleAvatar(
                                    //     radius: 50,
                                    //     backgroundImage:
                                    //         ("https://picsum.photos/250?image=9" ==
                                    //                 0)
                                    //             ? NetworkImage(
                                    //                 "https://picsum.photos/250?image=9",
                                    //               )
                                    //             : AssetImage(
                                    //                     'assets/images/ps.png')
                                    //                 as ImageProvider,
                                    //   ),
                                    // ),
                                    Image.asset(
                                      "assets/logo/education.png",
                                      width: 60,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      // color: Colors.red,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
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
                                                style:
                                                    smollheadertext(context)),
                                            TextSpan(
                                                text: datemain(
                                                      education[index]
                                                          ['start_date'],
                                                    ) +
                                                    "-" +
                                                    datemain(
                                                      education[index]
                                                          ['end_date'],
                                                    ),
                                                style:
                                                    smollheaderlight(context)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: (() {
                                          _educationNavigator2(context, index);
                                        }),
                                        child: Icon(Icons.edit)),
                                    InkWell(
                                        onTap: (() {
                                          _deleteEducationApi(education[index]
                                              ['user_education_id']);
                                        }),
                                        child: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ))
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
      ),
    );
  }

  Widget occputionList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "occupation",
                    style: header(context),
                  ),
                  InkWell(
                      onTap: (() {
                        _occupationNavigator(context);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => OccupationPage()));
                      }),
                      child: Icon(
                        Icons.add,
                        size: 35,
                      ))
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
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: RichText(
                                        text: TextSpan(
                                          text: occupation[index]
                                                  ['occupation_title'] +
                                              "\n",
                                          style: subheaderdark(context),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: occupation[index][
                                                        'occupation_type_name'] +
                                                    " \n",
                                                style: subheaderdark(context)),
                                            TextSpan(
                                                text: occupation[index]
                                                        ['occupation_name'] +
                                                    " \n",
                                                style: subheaderdark(context)),
                                            TextSpan(
                                                text: datemain(
                                                      occupation[index]
                                                          ['start_date'],
                                                    ) +
                                                    "\t\t\t" +
                                                    datemain(
                                                      occupation[index]
                                                          ['end_date'],
                                                    ),
                                                style:
                                                    smollheaderlight(context)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: (() {
                                          _occupationNavigator2(context, index);
                                        }),
                                        child: Icon(Icons.edit)),
                                    InkWell(
                                        onTap: (() {
                                          _deleteoccupationApi(occupation[index]
                                              ['user_occupation_id']);
                                        }),
                                        child: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ))
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
      ),
    );
  }

  Widget LocationList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
                  InkWell(
                      onTap: (() {
                        _locationNavigator(context);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => LocationPage()));
                      }),
                      child: Icon(
                        Icons.add,
                        size: 35,
                      ))
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
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: RichText(
                                        text: TextSpan(
                                          text: location[index]
                                                  ['location_name'] +
                                              "\n",
                                          style: subheaderdark(context),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: location[index]
                                                        ['start_year'] +
                                                    " - " +
                                                    location[index]
                                                        ['end_year'] +
                                                    "\t\t\t",
                                                style:
                                                    smollheaderlight(context)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: (() {
                                          _locationNavigator2(context, index);
                                        }),
                                        child: Icon(Icons.edit)),
                                    InkWell(
                                        onTap: (() {
                                          _deleteLocationApi(location[index]
                                              ['user_location_id']);
                                        }),
                                        child: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ))
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
      ),
    );
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
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Align(
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
                              text:
                                  "Write a summary to highlight your personality or work experience",
                              style: TextStyle(
                                color: black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

                      _BioNavigator(context);
                    }),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .36,
                      height: MediaQuery.of(context).size.height * .04,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Text("Add a summary"),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .8,
                // color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
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

  Widget countryDropdown() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.width * .12,
        width: MediaQuery.of(context).size.width * .85,
        decoration: BoxDecoration(
          border: Border.all(width: 0.2, color: black),
          borderRadius: BorderRadius.circular(28.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Country>(
              value: countryDropdownvalue,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: _country.map<DropdownMenuItem<Country>>((Country items) {
                return DropdownMenuItem<Country>(
                  value: items,
                  child: Text(
                    items.country_name,
                    style: verysmollheader2(context),
                  ),
                );
              }).toList(),
              onChanged: (Country? newValue) {
                setState(() {
                  countryDropdownvalue = newValue!;
                });
                getStateData(countryDropdownvalue?.country_id);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget stateDropdown() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          height: MediaQuery.of(context).size.width * .12,
          width: MediaQuery.of(context).size.width * .85,
          decoration: BoxDecoration(
            border: Border.all(width: 0.2, color: black),
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<StateModel>(
                // Initial Value
                value: stateDropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: _state
                    .map<DropdownMenuItem<StateModel>>((StateModel items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(
                      items.state_name,
                      style: verysmollheader2(context),
                    ),
                  );
                }).toList(),
                onChanged: (StateModel? newValue) {
                  setState(() {
                    stateDropdownvalue = newValue!;
                    getcityData(stateDropdownvalue?.state_id);
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
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Container(
          height: MediaQuery.of(context).size.width * .12,
          width: MediaQuery.of(context).size.width * .85,
          decoration: BoxDecoration(
            border: Border.all(width: 0.2, color: black),
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CityModel>(
                value: cityDropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: _city.map((CityModel items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(
                      items.city_name,
                      style: verysmollheader2(context),
                    ),
                  );
                }).toList(),
                onChanged: (CityModel? newValue) {
                  setState(() {
                    cityDropdownvalue = newValue!;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget updateProfileBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Button(
          key: Key('updateProfile_button'),
          buttonName: "Update Profile",
          onPressed: () {
            // _updateProfileApi();
            updateProfile();
          },
        ),
      ),
    );
  }

  Widget _addLanguage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: RichText(
                            text: TextSpan(
                                text:
                                    "Select Interest to showcase your expertise",
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
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    deleteLanguageByID(
                        languageModel, languageModel.language_id);
                  },
                  child: Icon(
                    Icons.delete,
                    color: black,
                  ),
                )
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
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    deleteInterstedByID(intrestModel, intrestModel.interest_id);
                  },
                  child: Icon(
                    Icons.delete,
                    color: black,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  getCountryData() async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getCountry');
    var response = await http.post(url, body: {});
    countryData = json.decode(response.body.toString());
    countryData = countryData['country'];
    for (int i = 0; i < countryData.length; i++) {
      var countryDataList = countryData[i];
      Country country = Country(
          countryDataList['country_id'],
          countryDataList['country_name'],
          countryDataList['country_code'],
          countryDataList['country_phone_code']);
      if (countryDataList['country_id'] == (userModel!.country_id)) {
        setState(() {
          countryDropdownvalue = country;
        });
      }
      _country.add(country);
    }
    setState(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  getStateData(String country_Id) async {
    print('country_id...$country_Id');
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getState');
    var response = await http.post(url, body: {"country_id": country_Id});
    dynamic stateRes = json.decode(response.body.toString());
    _state.clear();
    StateModel stateModel = StateModel(
      "",
      "",
      "Select State",
    );
    _state.add(stateModel);
    stateDropdownvalue = _state[0];

    stateData = stateRes['state'];
    print("stateData....${response.body}");
    for (int i = 0; i < stateData.length; i++) {
      var stateDataList = stateData[i];
      StateModel stateModel = StateModel(stateDataList['country_id'],
          stateDataList['state_id'], stateDataList['state_name']);
      if (stateDataList['state_id'] == (userModel!.state_id)) {
        setState(() {
          stateDropdownvalue = stateModel;
        });
      }
      _state.add(stateModel);
    }
    setState(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  //-----------Get state-------------
  getcityData(String state_id) async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getCity');
    var response = await http.post(url, body: {"state_id": state_id});
    dynamic cityRes = json.decode(response.body.toString());
    cityData = cityRes['city'];
    print("cityData....${response.body}");
    _city.clear();
    CityModel cityModel = CityModel("", "", "Select City");
    _city.add(cityModel);
    setState(() {
      cityDropdownvalue = _city[0];
    });

    try {
      for (int i = 0; i < cityData.length; i++) {
        var cityDataList = cityData[i];
        CityModel cityModel = CityModel(cityDataList['city_id'],
            cityDataList['state_id'], cityDataList['city_name']);
        if (cityDataList['city_id'] == (userModel!.city_id)) {
          setState(() {
            cityDropdownvalue = cityModel;
          });
        }
        _city.add(cityModel);
      }
    } catch (e) {
      print("Execption....$e");
    }
    setState(() {});
    setState(() {
      _isLoading = false;
    });
  }

  _getUserProfileApi() async {
    setState(() {
      _isLoading = true;
    });
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/getUserProfile'),
      body: {"user_id": userModel!.user_id, "session_user_id": ""},
    ).then(
      (response) {
        dynamic result1 = json.decode(response.body);
        getUserProfileData = result1['user_detail'];
        currentWallectBalance = getUserProfileData['user_wallet_balance'];
        Preference()
            .setString(Preference.CURRENT_BALANCE, currentWallectBalance);
        saveUserData(getUserProfileData['user_image'].toString());
        setState(() {
          userModel!.user_image = getUserProfileData["user_image"];
        });
        print("getUserProfileData...$getUserProfileData");
        rate_ammount = getUserProfileData['rate_amount'];
        print("rate_ammount...$rate_ammount");
        Preference().setString(Preference.RATE_AMMOUNT, rate_ammount);
        setState(() {
          perminCon.text = Preference().getString(Preference.RATE_AMMOUNT)!;
        });

        experience = getUserProfileData['experience'];
        print("experience...$experience");
        print("experience...${experience.length}");
        education = getUserProfileData['study_field'];
        print("education...${education}");

        print("education...${education.length}");
        location = getUserProfileData['location'];
        print("location...$location");

        print("location...${location.length}");
        occupation = getUserProfileData['occupation'];
        print("occupation...$occupation");

        print("occupation...${occupation.length}");
        discription = getUserProfileData['user_bio'];
        print("discription...$discription");

        _language = (getUserProfileData['language'] as List)
            .map((itemWord) => LanguageModel.fromJson(itemWord))
            .toList();
        setState(() {});
        _intrest = (getUserProfileData['interest'] as List)
            .map((itemWord) => IntrestModel.fromJson(itemWord))
            .toList();
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
        }
      },
    );
  }

  void saveUserData(String userImage) {
    print("$userImage");
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    //jsondatais['user_image']=userImage;
    userModel = UserModel.fromJson(jsondatais);
    userModel!.user_image = userImage;
    // //dynamic userJsonObject = userResponse['user'];
    // UserModel userModel = UserModel.fromJson(userResponse);
    String userModelStr = jsonEncode(userModel);
    print("saveUserVerification $userModelStr");
    Preference().setString(Preference.USER_MODEL, userModelStr);
    getUserModel();
  }

  void deleteLanguageByID(dynamic dataToRemove, String language_id) async {
    setState(() {
      _isLoading = true;
    });
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/addUserLanguage'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "is_delete": "1",
        "del_language": language_id,
        "language_id": ""
      },
    ).then(
      (response) {
        print("language_add...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _language.remove(dataToRemove);
          });
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

          _getUserProfileApi();
        }
      },
    );
  }

  void deleteInterstedByID(dynamic dataToRemove, String interest_id) async {
    setState(() {
      _isLoading = true;
    });
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/addInterest'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "is_delete": "1",
        "del_interest_id": interest_id,
        "interest_id": "",
      },
    ).then(
      (response) {
        print("add interest...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _intrest.remove(dataToRemove);
          });
          setState(() {
            _isLoading = false;
          });
        }else if (result1['status'] == 6) {
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

  void deleteExperiancesByID(String user_experience_id) {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    var user = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print(user.name);
    }
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/addUserExp'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "is_delete": "1",
        "del_experience_id": user_experience_id,
        "exp_title": "",
        "company_name": "",
        "location": "",
        "emp_type": "",
        "industry": "",
        "start_date": "",
        "end_date": "",
        "currently_working": "",
      },
    ).then(
      (response) {
        print("AddEducation...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          _getUserProfileApi();
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => NewEditProfile()));
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
        }else {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }

  _deleteEducationApi(String user_education_id) async {
    setState(() {
      _isLoading = true;
    });

    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/addUserEdu'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "institute": "",
        "degree": "",
        "field_study": "",
        "start_date": "",
        "end_date": "",
        "is_delete": "1",
        "del_edu": user_education_id
      },
    ).then(
      (response) {
        print("delete EDU...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          _getUserProfileApi();
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => NewEditProfile()));
        }else if (result1['status'] == 6) {
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

  _deleteLocationApi(String user_location_id) async {
    setState(() {
      _isLoading = true;
    });

    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/addLocationCred'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "is_delete": "1",
        "del_user_location": user_location_id,
        "location_name": "",
        "start_year": "",
        "end_year": "",
        "current_live": ""
      },
    ).then(
      (response) {
        print("Loation...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });

          _getUserProfileApi();
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => NewEditProfile()));
        }else if (result1['status'] == 6) {
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

  _deleteoccupationApi(String user_occupation_id) async {
    setState(() {
      _isLoading = true;
    });

    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/addUserOccupation'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "is_delete": "1",
        "del_user_occup": user_occupation_id,
        "occupation_title": "",
        "occupation_id": "",
        "occupation_type_id": "",
        "start_date": "",
        "end_date": ""
      },
    ).then(
      (response) {
        print("ocupation...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });

          _getUserProfileApi();

          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => NewEditProfile()));
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

  updateProfile() async {
    setState(() {
      _isLoading = true;
    });
    var request = http.MultipartRequest('POST',
        Uri.parse('${APIConstants.senpaiBaseUrl}user/updateUserProfile'));
    request.fields.addAll({
      "user_id": userModel!.user_id,
      "security_code": userModel!.security_code,
      "name": userModel!.name,
      "email_id": userModel!.email_id,
      "mobile_number": userModel!.mobile_number,
      "country_id": userModel!.country_id,
      "state_id": userModel!.state_id,
      "city_id": userModel!.city_id,
      "device_type": "1",
      "rate_amount": perminCon.text,
    });
    if (profileLogo != null)
      request.files.add(
          await http.MultipartFile.fromPath('user_image', profileLogo!.path));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic responseJson = await response.stream.bytesToString();
      dynamic responseData = json.decode(responseJson);
      String mgs = responseData['message'];
      print("responec......$responseData");
      if (responseData['status'] == 1) {
        setState(() {
          _isLoading = false;
        });
        Preference().setString(Preference.EDIT_PROFILE_PRETANCE, '10');
        // Navigator.pop(context);
        showToastMessage("Proflie Updated", context);
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
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}
