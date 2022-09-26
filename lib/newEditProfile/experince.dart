import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:senpai/model/industryModel.dart';
import 'package:senpai/newEditProfile/newEditProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/Button.dart';
import 'newInputFiled.dart';
import 'package:http/http.dart' as http;

class ExpreincePage extends StatefulWidget {
  final dynamic expreincekey;
  final bool experinceEditkey;
  const ExpreincePage(
      {Key? key, this.expreincekey, required this.experinceEditkey})
      : super(key: key);

  @override
  State<ExpreincePage> createState() => _ExpreincePageState();
}

class _ExpreincePageState extends State<ExpreincePage> {
  String empDropdownvalue = 'Full-Time';
  String selectedEmply = "";
  var empItems = [
    'Full-Time',
    'Part-time',
    'Self-employed',
    'Freelance',
    'Internship',
    'Trainee',
  ];
  List<IndustryModel> _industry = [];
  var industryData;
  String selectedIndustry = "";
  IndustryModel? industryDropdownvalue;

  File? postGraduationLogo;
  String postGraduation_logo = "";
  bool _termsChecked = false;

  DateTime selectStartDate = DateTime.now();
  String startDate = "";

  _selectStartDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectStartDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectStartDate)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        selectStartDate = selected;
      });
    startDate =
        "${selectStartDate.year}-${selectStartDate.month}-${selectStartDate.day}";
    print("StartDate $startDate");
  }

  String endDate = "";

  DateTime selectEndtDate = DateTime.now();

  _selectEndDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectEndtDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectEndtDate)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        selectEndtDate = selected;
      });
    endDate =
        "${selectEndtDate.year}-${selectEndtDate.month}-${selectEndtDate.day}";
  }

  FocusNode? myFocusNode;
  final FocusNode titleFocus = FocusNode();
  final FocusNode companyNameFocus = FocusNode();
  final FocusNode LocationFocus = FocusNode();
  TextEditingController titleCon = TextEditingController();
  TextEditingController companyNameCon = TextEditingController();
  TextEditingController locationCon = TextEditingController();
  TextEditingController EndDateCon = TextEditingController();

  bool? _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndustry = "";
    selectedEmply = "";
    widget.expreincekey;
    if (widget.experinceEditkey == true) {
      titleCon.text = widget.expreincekey['exp_title'];
      companyNameCon.text = widget.expreincekey['company_name'];
      locationCon.text = widget.expreincekey['location'];
      startDate = widget.expreincekey['start_date'];
      print("object..$startDate");
      endDate = widget.expreincekey['end_date'];
      selectedEmply = widget.expreincekey['emp_type'];
      selectedIndustry = widget.expreincekey['type_name'];

      int ye = selectEndtDate.year;
      int me = selectEndtDate.month;
      int de = selectEndtDate.day;
      int ys = selectStartDate.year;
      int ms = selectStartDate.month;
      int ds = selectStartDate.day;
      try {
        ds = int.parse(startDate.split("-")[2]);
        ms = int.parse(startDate.split("-")[1]);
        ys = int.parse(startDate.split("-")[0]);
      } catch (e) {}

      try {
        de = int.parse(endDate.split("-")[2]);
        me = int.parse(endDate.split("-")[1]);
        ye = int.parse(endDate.split("-")[0]);
      } catch (e) {}
      selectStartDate = DateTime(ys, ms, ds);
      selectEndtDate = DateTime(ye, me, de);
      //  _industry=widget.expreincekey['type_name'];
      try {
        if (selectedEmply == widget.expreincekey['emp_type'].toString()) {
          // isExists = true;
          setState(() {
            empDropdownvalue = widget.expreincekey['emp_type'];
          });
        }
      } catch (e) {}
    }

    print("expreincekey${widget.expreincekey}");
    IndustryModel industryModel =
        IndustryModel("", "Select StudyField ", "", "");
    _industry.add(industryModel);
    industryDropdownvalue = _industry[0];
    getIndustryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: InkWell(
          onTap: (() {
            Navigator.pop(context);
          }),
          child: Icon(
            Icons.clear,
            color: black,
            size: 35,
          ),
        ),
      ),
      body: Stack(children: [
        allFiled(),
        LoaderIndicator(_isLoading!),
        Align(alignment: Alignment.bottomCenter, child: saveBtn())
      ]),
    );
  }

  Widget allFiled() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100, left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [addExperience(), inputsFiled()],
        ),
      ),
    );
  }

  Widget addExperience() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add experience",
            style: headerexplore(context),
          ),
          Text(
            "*indicates required",
            style: smollheaderlight(context),
          ),
        ],
      ),
    );
  }

  Widget inputsFiled() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _titleInputFiled(),
          _companyInputFiled(),
          _locationInputFiled(),
          employmentDropdown(),
          industryDropdown(),
          cureentCheckbox(),
          StartDate(),
          change(),
        ],
      ),
    );
  }

  Widget _titleInputFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: newTextFieldDesign(
        focusNode: titleFocus,
        key: Key("businessName"),
        inputHeaderName: 'Title*',
        controller: titleCon,
        keyBoardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        hintText: 'Ex:Retail Sales Manager',
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () =>
            {FocusScope.of(context).requestFocus(companyNameFocus)},
        onSaved: (String? newValue) {},
        prefixIcon: null,
      ),
    );
  }

  Widget _companyInputFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: newTextFieldDesign(
        key: Key("company"),
        keyBoardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        inputHeaderName: 'Company name*',
        hintText: 'Ex: Microsoft',
        focusNode: companyNameFocus,
        controller: companyNameCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () =>
            {FocusScope.of(context).requestFocus(LocationFocus)},
        onSaved: (String? newValue) {},
        prefixIcon: null,
      ),
    );
  }

  Widget _locationInputFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: newTextFieldDesign(
        key: Key("location"),
        keyBoardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        inputHeaderName: 'Location*',
        hintText: 'Ex:Indore ,India',
        focusNode: LocationFocus,
        controller: locationCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {FocusScope.of(context).unfocus()},
        onSaved: (String? newValue) {},
        prefixIcon: null,
      ),
    );
  }

  Widget employmentDropdown() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Employment Type"),
            Container(
              // color: Colors.red,
              height: MediaQuery.of(context).size.width * .1,
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  // Initial Value
                  value: empDropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: empItems.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: subheader(context),
                      ),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      empDropdownvalue = newValue!;
                    });
                  },
                ),
              ),
            ),
            Container(
              color: Colors.black54,
              height: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget industryDropdown() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Industry*"),
            Container(
              // color: Colors.red,
              height: MediaQuery.of(context).size.width * .1,
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<IndustryModel>(
                  // Initial Value
                  value: industryDropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: _industry.map<DropdownMenuItem<IndustryModel>>(
                      (IndustryModel items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items.type_name,
                        style: subheader(context),
                      ),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (IndustryModel? newValue) {
                    setState(() {
                      industryDropdownvalue = newValue!;
                    });
                  },
                ),
              ),
            ),
            Container(
              color: Colors.black54,
              height: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget StartDate() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Start date*"),
            InkWell(
              onTap: (() {
                _selectStartDate(context);
              }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "${selectStartDate.day}/${selectStartDate.month}/${selectStartDate.year}"),
                  InkWell(
                      onTap: (() {
                        _selectStartDate(context);
                      }),
                      child: Icon(Icons.calendar_month))
                ],
              ),
            ),
            Container(
              color: Colors.black54,
              height: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget cureentCheckbox() {
    return CheckboxListTile(
      activeColor: Theme.of(context).accentColor,
      title: Text('I am currently working in this role'),
      value: _termsChecked,
      onChanged: (bool? value) => setState(() => _termsChecked = value!),
    );
  }

  Widget change() {
    return (_termsChecked == true) ? EndDate2() : EndDate();
  }

  Widget EndDate() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("End date*"),
            InkWell(
              onTap: (() {
                _selectEndDate(context);
              }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "${selectEndtDate.day}/${selectEndtDate.month}/${selectEndtDate.year}"),
                  InkWell(
                      onTap: (() {
                        _selectEndDate(context);
                      }),
                      child: Icon(Icons.calendar_month))
                ],
              ),
            ),
            Container(
              color: Colors.black54,
              height: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget EndDate2() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("End date*"),
            InkWell(
              onTap: (() {}),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Present"),
                  InkWell(
                      onTap: (() {
                        _selectEndDate(context);
                      }),
                      child: Icon(Icons.calendar_month))
                ],
              ),
            ),
            Container(
              color: Colors.black54,
              height: 1,
            )
          ],
        ),
      ),
    );
  }

  onPresedLogin() {
    if (titleCon.text.toString().isEmpty) {
      return showToastMessage("Enter Title", context);
    } else if (companyNameCon.text.toString().isEmpty) {
      return showToastMessage("Enter your Company Name", context);
    } else if (locationCon.text.toString().isEmpty) {
      return showToastMessage("Enter your Location", context);
    } else if (empDropdownvalue.toString().isEmpty) {
      return showToastMessage("Select City.", context);
    } else if (industryDropdownvalue!.industry_type_id.toString().isEmpty) {
      return showToastMessage("Select IndustryType", context);
    } else if (startDate.toString().isEmpty) {
      return showToastMessage("Select Start Date", context);
    } else if (endDate.toString().isEmpty) {
      return showToastMessage("Select End Date", context);
    } else {
      _AddExperinceApi();
    }
  }

  Widget saveBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Button(
          key: Key('save_button'),
          buttonName: "Save",
          onPressed: () {
            onPresedLogin();
          },
        ),
      ),
    );
  }

  Widget Cretification() {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Color(0xffC4C4C4)),
            child: postGraduationLogo == null
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 18),
                    child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: MediaQuery.of(context).size.height / 5,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          await ImagePicker()
                                              // ignore: deprecated_member_use
                                              .pickImage(
                                                  source: ImageSource.gallery)
                                              .then((value) {
                                            if (value != null) {
                                              postGraduationLogo =
                                                  File(value.path);
                                            }
                                            setState(() {
                                              postGraduationLogo =
                                                  postGraduationLogo;
                                            });
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Icon(Icons.photo)),
                                    InkWell(
                                        onTap: () async {
                                          await ImagePicker()
                                              // ignore: deprecated_member_use
                                              .pickImage(
                                                  source: ImageSource.camera)
                                              .then((value) {
                                            if (value != null) {
                                              postGraduationLogo =
                                                  File(value.path);
                                            }
                                            setState(() {
                                              postGraduationLogo =
                                                  postGraduationLogo;
                                            });
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Icon(Icons.camera)),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: postGraduation_logo.length > 0
                            ? Image.network(
                                postGraduation_logo,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 0.05,
                              )
                            : Image.asset(
                                "assets/logo/add.png",
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 0.06,
                              )))
                : postGraduationimagee1(),
          )
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          //   child: Icon(
          //     Icons.add,
          //     size: 25,
          //   ),
          // )),
          ),
    );
  }

  Widget postGraduationimagee1() {
    return Container(
      // color: Colors.grey,
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.15,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            postGraduationLogo!,
            fit: BoxFit.cover,
          )),
    );
  }

  _AddExperinceApi() async {
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
        "user_id": user.user_id,
        "security_code": user.security_code,
        "is_delete": (widget.experinceEditkey == true) ? "1" : "0",
        "del_experience_id": (widget.experinceEditkey == true)
            ? widget.expreincekey['user_experience_id']
            : "",
        "exp_title": titleCon.text,
        "company_name": companyNameCon.text,
        "location": locationCon.text,
        "emp_type": empDropdownvalue,
        "industry": industryDropdownvalue!.industry_type_id,
        "start_date": startDate,
        "end_date": endDate,
        "currently_working": _termsChecked ? "1" : "0",
      },
    ).then(
      (response) {
        print("AddExperince...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
         Preference().setString(Preference.EXPERIANCE_PRETANCE, "15");
          Navigator.pop(context, result1);
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

  getIndustryData() async {
    bool isExists = false;
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getIndustryType');
    var response = await http.post(url, body: {});
    industryData = json.decode(response.body.toString());
    industryData = industryData['industry_type'];
    print("FosData....${response.body}");
    _industry.clear();
    IndustryModel industryModel =
        IndustryModel("", "Select StudyField ", "", "");
    _industry.add(industryModel);

    for (int i = 0; i < industryData.length; i++) {
      var industryDataList = industryData[i];
      IndustryModel industryModel = IndustryModel(
          industryDataList['industry_type_id'],
          industryDataList['type_name'],
          industryDataList['is_active'],
          industryDataList['created']);
      try {
        if (selectedIndustry == industryDataList['type_name'].toString()) {
          isExists = true;
          setState(() {
            industryDropdownvalue = industryModel;
          });
        }
      } catch (e) {}
      _industry.add(industryModel);
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    if (!isExists) industryDropdownvalue = _industry[0];

    return json.decode(response.body.toString());
  }
}
