import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/model/StudyFiledModel.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/model/degreeModel.dart';
import 'package:senpai/newEditProfile/newEditProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/Button.dart';
import 'newInputFiled.dart';

class EducationPage extends StatefulWidget {
  final dynamic educationkey;
  final bool educationEditkey;
  const EducationPage(
      {Key? key, this.educationkey, required this.educationEditkey})
      : super(key: key);

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  List<DegreeModel> _degree = [];
  var DegreeData;
  String selectDegree = "";
  DegreeModel? degreeDropdownvalue;

  List<studyFieldModel> _fieldOFStudy = [];
  var FosData;
  String selectFos = "";
  studyFieldModel? fosDropdownvalue;

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

  DateTime selectEndtDate = DateTime.now();
  String endDate = "";

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

  TextEditingController schoolCon = TextEditingController();
  bool? _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectFos = "";
    selectDegree = "";
    print("educationkey....${widget.educationkey}");

    if (widget.educationEditkey == true) {
      schoolCon.text = widget.educationkey['institute'];
      startDate = widget.educationkey['start_date'];
      print("object..$startDate");
      endDate = widget.educationkey['end_date'];
      selectDegree = widget.educationkey['degree_name'];
      selectFos = widget.educationkey['field_name'];

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
    }
    DegreeModel degreeModel = DegreeModel("", "Select Degree", "", "");
    _degree.add(degreeModel);
    degreeDropdownvalue = _degree[0];
    studyFieldModel fieldModel =
        studyFieldModel("", "Select StudyField ", "", "");
    _fieldOFStudy.add(fieldModel);
    fosDropdownvalue = _fieldOFStudy[0];
    getDegreeData();
    getFOSData();
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 100, left: 5, right: 5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addExperience(),
            inputsFiled(),
          ],
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
            "Add education",
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
          _schoolInputFiled(),
          degreeDropdown(),
          fieldOfStudyDropdown(),
          StartDate(),
          EndDate(),
          // fieldOfStudyDropdown2()
        ],
      ),
    );
  }

  Widget _schoolInputFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: newTextFieldDesign(
        // lableText: "Title*",
        key: Key("schoolName"),
        inputHeaderName: 'School*',
        controller: schoolCon,
        keyBoardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        hintText: 'Ex:RGPV University',
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {},
        onSaved: (String? newValue) {},
        prefixIcon: null,
      ),
    );
  }

  Widget degreeDropdown() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Degree*"),
            Container(
              // color: Colors.red,
              height: MediaQuery.of(context).size.width * .1,
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<DegreeModel>(
                  // Initial Value
                  value: degreeDropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: _degree
                      .map<DropdownMenuItem<DegreeModel>>((DegreeModel value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value.degree_name,
                        style: subheader(context),
                      ),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (DegreeModel? newValue) {
                    setState(() {
                      degreeDropdownvalue = newValue!;
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

  Widget fieldOfStudyDropdown() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Field Of Study*"),
            Container(
              // color: Colors.red,
              height: MediaQuery.of(context).size.width * .1,
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<studyFieldModel>(
                  // Initial Value
                  value: fosDropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: _fieldOFStudy.map<DropdownMenuItem<studyFieldModel>>(
                      (studyFieldModel items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items.field_name,
                        style: subheader(context),
                      ),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (studyFieldModel? newValue) {
                    setState(() {
                      fosDropdownvalue = newValue!;
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

  onPresedLogin() {
    if (schoolCon.text.toString().isEmpty) {
      return showToastMessage("Enter School", context);
    } else if (degreeDropdownvalue!.degree_id.toString().isEmpty) {
      return showToastMessage("Select Degree.", context);
    } else if (fosDropdownvalue!.study_field_id.toString().isEmpty) {
      return showToastMessage("Select StudyField", context);
    } else if (startDate.toString().isEmpty) {
      return showToastMessage("Select Start Date", context);
    } else if (endDate.toString().isEmpty) {
      return showToastMessage("Select end Date", context);
    } else {
      _AddEducationApi();
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

  _AddEducationApi() async {
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
      Uri.parse('${APIConstants.senpaiBaseUrl}user/addUserEdu'),
      body: {
        "user_id": user.user_id,
        "security_code": user.security_code,
        "institute": schoolCon.text,
        "degree": degreeDropdownvalue!.degree_id,
        "field_study": fosDropdownvalue!.study_field_id,
        "start_date": startDate,
        "end_date": endDate,
        "is_delete": (widget.educationEditkey == true) ? "1" : "0",
        "del_edu": (widget.educationEditkey == true)
            ? widget.educationkey['user_education_id']
            : ""
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
        Preference().setString(Preference.EDUCATION_PRETANCE, "10");
          Navigator.pop(context, result1);
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

  getDegreeData() async {
    bool isExists = false;

    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getDegree');
    var response = await http.post(url, body: {});
    DegreeData = json.decode(response.body.toString());
    DegreeData = DegreeData['degree'];
    print("countryData....${response.body}");
    _degree.clear();

    DegreeModel degreeModel = DegreeModel("", "Select Degree", "", "");
    _degree.add(degreeModel);

    for (int i = 0; i < DegreeData.length; i++) {
      var degreeDataList = DegreeData[i];

      DegreeModel degreeModel = DegreeModel(
          degreeDataList['degree_id'],
          degreeDataList['degree_name'],
          degreeDataList['is_active'],
          degreeDataList['created']);
      try {
        if (selectDegree == degreeDataList['degree_name'].toString()) {
          isExists = true;
          setState(() {
            degreeDropdownvalue = degreeModel;
          });
        }
      } catch (e) {}
      _degree.add(degreeModel);
    }
    print(_degree.length);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    if (!isExists) degreeDropdownvalue = _degree[0];

    return json.decode(response.body.toString());
  }

  getFOSData() async {
    bool isExists = false;

    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getStudyField');
    var response = await http.post(url, body: {});
    FosData = json.decode(response.body.toString());
    FosData = FosData['study_field'];
    print("FosData....${response.body}");
    _fieldOFStudy.clear();

    studyFieldModel fieldModel =
        studyFieldModel("", "Select StudyField ", "", "");
    _fieldOFStudy.add(fieldModel);
    // DegreeModel degreeModel = DegreeModel("", "Select Degree", "", "");
    // _degree.add(degreeModel);

    for (int i = 0; i < FosData.length; i++) {
      var FosDataList = FosData[i];

      studyFieldModel fieldModel = studyFieldModel(
          FosDataList['study_field_id'],
          FosDataList['field_name'],
          FosDataList['is_active'],
          FosDataList['created']);
      try {
        if (selectFos == FosDataList['field_name'].toString()) {
          isExists = true;
          setState(() {
            fosDropdownvalue = fieldModel;
          });
        }
      } catch (e) {}
      _fieldOFStudy.add(fieldModel);
    }
    print(_fieldOFStudy.length);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    if (!isExists) fosDropdownvalue = _fieldOFStudy[0];

    return json.decode(response.body.toString());
  }
}
