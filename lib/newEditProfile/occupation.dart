// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers, avoid_print, unnecessary_new, prefer_final_fields, prefer_typing_uninitialized_variables, unused_field, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/model/OccupationTypeModel.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:senpai/model/ocuupationModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/Button.dart';
import 'newInputFiled.dart';
import 'package:http/http.dart' as http;

class OccupationPage extends StatefulWidget {
  final dynamic occupationkey;
  final bool occupationEditkey;
  const OccupationPage(
      {Key? key, this.occupationkey, required this.occupationEditkey})
      : super(key: key);

  @override
  State<OccupationPage> createState() => _OccupationPageState();
}

class _OccupationPageState extends State<OccupationPage> {
  TextEditingController occupationCon = TextEditingController();

  List<OccupationModel> _occupation = [];
  var OccupationData;
  String select_occupation_name = "";
  OccupationModel? occupationDropdownvalue;

  List<OccupationTypeModel> _occupationType = [];
  var OccupationTypeData;
  String select_occupation_type_name = "";
  OccupationTypeModel? occupationTypeDropdownvalue;

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

  @override
  void initState() {
    super.initState();
    print("occupatin..${widget.occupationkey}");
    select_occupation_name = "";
    select_occupation_type_name = "";
    if (widget.occupationEditkey == true) {
      occupationCon.text = widget.occupationkey['occupation_title'];
      startDate = widget.occupationkey['start_date'];
      print("object..$startDate");
      endDate = widget.occupationkey['end_date'];
      select_occupation_name = widget.occupationkey['occupation_name'];
      select_occupation_type_name =
          widget.occupationkey['occupation_type_name'];

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
    OccupationModel occupationModel = new OccupationModel(
      "",
      "Select Occupation",
    );

    _occupation.add(occupationModel);
    occupationDropdownvalue = _occupation[0];

    OccupationTypeModel occupationTypeModel =
        new OccupationTypeModel(" ", "", "Select Occupation");
    _occupationType.add(occupationTypeModel);
    occupationTypeDropdownvalue = _occupationType[0];

    getoccupationData();
  }

  bool? _isLoading = false;

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
          child: const Icon(
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
            "Add Occupation",
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
          _occupationInputFiled(),
          occupationDropdown(),
          employmentDropdown(),
          StartDate(),
          EndDate()
        ],
      ),
    );
  }

  Widget _occupationInputFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: newTextFieldDesign(
        // lableText: "Title*",
        key: Key("occupation"),
        inputHeaderName: 'Occupation Title*',
        controller: occupationCon,
        keyBoardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        hintText: 'Ex:Retail Sales Manager',
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {},
        onSaved: (String? newValue) {},
        prefixIcon: null,
      ),
    );
  }

  Widget occupationDropdown() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Occupation*"),
            Container(
              // color: Colors.red,
              height: MediaQuery.of(context).size.width * .1,
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<OccupationModel>(
                  // Initial Value
                  value: occupationDropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: _occupation.map<DropdownMenuItem<OccupationModel>>(
                      (OccupationModel value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value.occupation_name,
                        style: subheader(context),
                      ),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (OccupationModel? value) {
                    setState(() {
                      occupationDropdownvalue = value!;
                      getOccupation_Type_Data(
                          occupationDropdownvalue!.occupation_id);
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

  Widget employmentDropdown() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Occupation Type*"),
            Container(
              // color: Colors.red,
              height: MediaQuery.of(context).size.width * .1,
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<OccupationTypeModel>(
                  // Initial Value
                  value: occupationTypeDropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: _occupationType
                      .map<DropdownMenuItem<OccupationTypeModel>>(
                          (OccupationTypeModel value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value.type_name,
                        style: subheader(context),
                      ),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (OccupationTypeModel? newValue) {
                    setState(() {
                      occupationTypeDropdownvalue = newValue!;
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
                    child: const Icon(Icons.calendar_month),
                  )
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
            const Text("End date*"),
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
    if (occupationCon.text.toString().isEmpty) {
      return showToastMessage("Enter OccupationTitle", context);
    } else if (occupationDropdownvalue!.occupation_id.toString().isEmpty) {
      return showToastMessage("Select Occupation.", context);
    } else if (occupationTypeDropdownvalue!.occupation_type_id
        .toString()
        .isEmpty) {
      return showToastMessage("Select OccupationType", context);
    } else if (startDate.toString().isEmpty) {
      return showToastMessage("Select Start Date", context);
    } else if (endDate.toString().isEmpty) {
      return showToastMessage("Select end Date", context);
    } else {
      _occupationApi();
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

  //------------District---------------
  getoccupationData() async {
    bool isExists = false;

    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getOccupation');
    var response = await http.post(url, body: {});
    OccupationData = json.decode(response.body.toString());
    OccupationData = OccupationData['occupation'];
    print("countryData....${response.body}");
    //s print("dtaa111...." + data.toString());
    _occupation.clear();

    OccupationModel occupationModel =
        new OccupationModel("", "Select Occupation");
    _occupation.add(occupationModel);

    for (int i = 0; i < OccupationData.length; i++) {
      var occupationDataList = OccupationData[i];

      OccupationModel occupationModel = new OccupationModel(
          occupationDataList['occupation_id'],
          occupationDataList['occupation_name']);
      try {
        if (select_occupation_name ==
            occupationDataList['occupation_name'].toString()) {
          isExists = true;
          setState(() {
            occupationDropdownvalue = occupationModel;
          });
        }
      } catch (e) {}
      _occupation.add(occupationModel);
    }
    print(_occupation.length);
    print("country....$OccupationData");
    print("country....${OccupationData[1]['occupation_name']}");
    print("${OccupationData[1]['occupation_id']}");

    // var countryId= countryData[index]['country_name'];

    setState(() {
      setState(() {
        _isLoading = false;
      });
      if (!isExists) occupationDropdownvalue = _occupation[0];
      // getStateData(countryDropdownvalue!.country_id);
      print(occupationDropdownvalue!.occupation_id);
    });
    return json.decode(response.body.toString());
  }

  getOccupation_Type_Data(String occupationType_id) async {
    bool isExists = false;

    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${APIConstants.senpaiBaseUrl}user/getOccupationType');
    var response =
        await http.post(url, body: {"occupation_id": occupationType_id});
    OccupationTypeData = json.decode(response.body.toString());
    OccupationTypeData = OccupationTypeData['occupation'];
    print("countryData....${response.body}");
    //s print("dtaa111...." + data.toString());
    _occupationType.clear();

    OccupationTypeModel occupationTypeModel =
        new OccupationTypeModel("", "", "Select Occupation");
    _occupationType.add(occupationTypeModel);

    for (int i = 0; i < OccupationTypeData.length; i++) {
      var occupationTypeDataList = OccupationTypeData[i];
      OccupationTypeModel occupationTypeModel = new OccupationTypeModel(
          occupationTypeDataList['occupation_type_id'],
          occupationTypeDataList['occupation_id'],
          occupationTypeDataList['type_name']);
      try {
        if (select_occupation_type_name ==
            occupationTypeDataList['type_name'].toString()) {
          isExists = true;
          setState(() {
            occupationTypeDropdownvalue = occupationTypeModel;
          });
        }
      } catch (e) {}
      _occupationType.add(occupationTypeModel);
    }
    print(_occupationType.length);
    print("occuptionType....$OccupationTypeData");
    print("country....${OccupationTypeData[1]['type_name']}");
    print("${OccupationTypeData[1]['occupation_id']}");

    // var countryId= countryData[index]['country_name'];

    setState(() {
      setState(() {
        _isLoading = false;
      });
      if (!isExists) occupationTypeDropdownvalue = _occupationType[0];
      // getStateData(countryDropdownvalue!.country_id);
      // print(occupationTypeDropdownvalue!);
    });
    return json.decode(response.body.toString());
  }

  _occupationApi() async {
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
      Uri.parse('${APIConstants.senpaiBaseUrl}user/addUserOccupation'),
      body: {
        "user_id": user.user_id,
        "security_code": user.security_code,
        "is_delete":(widget.occupationEditkey==true)?"1":"0",
        "del_user_occup": (widget.occupationEditkey==true)?widget.occupationkey['user_occupation_id']:"",
        "occupation_title": occupationCon.text,
        "occupation_id": occupationDropdownvalue!.occupation_id,
        "occupation_type_id": occupationTypeDropdownvalue!.occupation_type_id,
        "start_date": startDate,
        "end_date": endDate
      },
    ).then(
      (response) {
        // print("body${body.toString()}");
        print("ocupation...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          Preference().setString(Preference.OCCUPATION_PRETANCE, "10");
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
}
