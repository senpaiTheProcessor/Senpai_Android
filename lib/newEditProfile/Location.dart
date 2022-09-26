// ignore_for_file: file_names, avoid_print, prefer_const_constructors, sized_box_for_whitespace, non_constant_identifier_names, deprecated_member_use, avoid_unnecessary_containers, unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:senpai/Common/Button.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LocationPage extends StatefulWidget {
  final dynamic locationkey;
  final bool locationEditkey;
  const LocationPage(
      {Key? key, this.locationkey, required this.locationEditkey})
      : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  TextEditingController locationCon = TextEditingController();
  List<String> years = [];
  String selectStartYear = "";
  String selectEndYear = "";
  List<String> idads = ["hjk", "s", "fg"];

  void yerarLoop() {
    for (int year = 1940; year < 2024; year++) {
      years.add((year).toString());
    }
    print("yera....${years.toString()}");
  }

  String endDateDropdownValue = '1990';

  String startDropdownvalue = '1990';

  bool _termsChecked = false;
  @override
  void initState() {
    super.initState();
    yerarLoop();
    selectStartYear = "";
    selectEndYear = "";
    print("locationkey..${widget.locationkey}");
    if (widget.locationEditkey == true) {
      locationCon.text = widget.locationkey['location_name'];
      selectStartYear = widget.locationkey['start_year'];
      selectEndYear = widget.locationkey['end_year'];

      try {
        if (selectStartYear == widget.locationkey['start_year'].toString()) {
          // isExists = true;
          setState(() {
            startDropdownvalue = widget.locationkey['start_year'];
          });
        }
      } catch (e) {}

      try {
        if (selectEndYear == widget.locationkey['end_year'].toString()) {
          // isExists = true;
          setState(() {
            endDateDropdownValue = widget.locationkey['end_year'];
          });
        }
      } catch (e) {}
    }
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
        allField(),
        LoaderIndicator(_isLoading!),
        Align(alignment: Alignment.bottomCenter, child: saveBtn())
      ]),
    );
  }

  Widget allField() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100, left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [addExperience(), _box()],
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
            "Edit credentials",
            style: headerexplore(context),
          ),
          Text(
            "Credentials add credibility to your content",
            style: subheader(context),
          ),
        ],
      ),
    );
  }

  onPresedLogin() {
    if (locationCon.text.toString().trim().isEmpty) {
      return showToastMessage("Enter your Location", context);
    } else if (startDropdownvalue.toString().isEmpty) {
      return showToastMessage("Select Start Date.", context);
    } else if (endDateDropdownValue.toString().isEmpty) {
      return showToastMessage("Select End Date.", context);
    } else {
      _addLocationApi();
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

  Widget Location() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Location*"),
          SizedBox(
            height: 4,
          ),
          TextFormField(
            controller: locationCon,
            decoration: InputDecoration(
              hintText: "Indore,M.P",
              hintStyle: TextStyle(
                  color: black,
                  fontSize: 12,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w400),
              // labelText: "Resevior Name",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                // borderRadius: BorderRadius.circular(0.0),
              ),
              enabledBorder: OutlineInputBorder(
                // borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(color: Colors.black, width: 0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget endDateDropdown() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("End Date*"),
            SizedBox(
              height: 4,
            ),
            Container(
              // color: Colors.red,
              height: MediaQuery.of(context).size.width * .15,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black26)),

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    // Initial Value
                    value: endDateDropdownValue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: years.map((String items) {
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
                        endDateDropdownValue = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ),
            // Container(
            //   color: Colors.black54,
            //   height: 1,
            // )
          ],
        ),
      ),
    );
  }

  Widget startDropdown() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Start Date*"),
            SizedBox(
              height: 4,
            ),

            Container(
              // color: Colors.red,
              height: MediaQuery.of(context).size.width * .15,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black26)),

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    // Initial Value
                    value: startDropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: years.map((String items) {
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
                        startDropdownvalue = newValue!;
                        print("value..$startDropdownvalue");
                      });
                    },
                  ),
                ),
              ),
            ),
            // Container(
            //   color: Colors.black54,
            //   height: 1,
            // )
          ],
        ),
      ),
    );
  }

  Widget cureentCheckbox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CheckboxListTile(
        activeColor: Theme.of(context).accentColor,
        title: Text('I currently live here'),
        value: _termsChecked,
        // onChanged: (bool? value) => setState(() => _termsChecked = value!),
        onChanged: (bool? value) {
          setState(() {
            _termsChecked = value!;
            print("checkBox..$_termsChecked");
          });
        },
      ),
    );
  }

  Widget addLocation() {
    return Container(
      child: Row(
        children: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.location_on_outlined,
                size: 25,
              )),
          Text(
            "Add Location credential",
            style: header(context),
          )
        ],
      ),
    );
  }

  Widget _box() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
        child: Column(children: [
          addLocation(),
          Divider(),
          Location(),
          // LocationInput(),
          startDropdown(),
          endDateDropdown(),
          cureentCheckbox()
        ]),
      ),
    );
  }

  _addLocationApi() async {
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
      Uri.parse('${APIConstants.senpaiBaseUrl}user/addLocationCred'),
      body: {
        "user_id": user.user_id,
        "security_code": user.security_code,
        "is_delete": (widget.locationEditkey == true) ? "1" : "0",
        "del_user_location": (widget.locationEditkey == true)
            ? widget.locationkey['user_location_id']
            : "",
        "location_name": locationCon.text,
        "start_year": startDropdownvalue,
        "end_year": endDateDropdownValue,
        "current_live": _termsChecked ? "1" : "0"
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
           Preference().setString(Preference.LOCATION_PRETANCE, "5");
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
}
