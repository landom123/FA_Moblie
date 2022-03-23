import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_flutter_test/sceen/menu_reported.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

// ignore: must_be_immutable
class DetailsReported extends StatefulWidget {
  final oCcy = NumberFormat("#,##0.00", "th");
  final String titleName;
  final String codeAssets;
  final int brachID;
  final String date;
  final String? reference;
  final String round;
  final String userCode;
  final String userBranch;
  final int backBranch;
  late String imagePath;
  DetailsReported({
    Key? key,
    required this.titleName,
    required this.codeAssets,
    required this.brachID,
    required this.date,
    required this.reference,
    required this.round,
    required this.userCode,
    required this.userBranch,
    required this.backBranch,
    required this.imagePath,
  }) : super(key: key);
  @override
  _DetailsReportedState createState() => _DetailsReportedState();
}

class _DetailsReportedState extends State<DetailsReported> {
  bool checkBox2 = false;
  bool checkBox = false;
  bool checkBox3 = false;
  var referenceController = TextEditingController();
  String referenceSetState1 = 'ชำรุดรอซ่อม';
  String referenceSetState2 = 'รอตัดชำรุด';
  String referenceSetState3 = '';
  bool _visible = false;
  var titleName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.imagePath == 'null') {
      widget.imagePath =
          'http://vpnptec.dyndns.org:10280/OPS_Fileupload/ATT_220300020.png';
    }
    setState(() {
      titleName.text = widget.titleName;
    });
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        leading: Row(children: <Widget>[
          const SizedBox(
            width: 5.0,
          ),
          IconButton(
            color: Colors.black,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: HexColor('#283B71'),
      body: assetsReported(),
    );
  }

  Widget assetsReported() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.8,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/purethai.png",
                    width: 250,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, top: 30, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  readOnly: true,
                  controller: titleName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                  height: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Code :  ' + widget.codeAssets,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      //fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'สาขาที่อยู่ของทรัพย์สิน :  ' + widget.brachID.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      //fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'ชื่อย่อ :',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      //fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'รอบที่ทำการบันทึก :  ' + widget.round,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      //fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                  height: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'บันทึกโดย :  ' + widget.userCode,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      //fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'สาขาที่ทำการบันทึก :  ' + widget.userBranch,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      //fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'วันที่บันทึก :  ' + widget.date,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      //fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'อ้างอิง :  ' + widget.reference.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          //fontStyle: FontStyle.italic,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (widget.reference == "QR Code ไม่สมบูรณ์") {
                            _visible = false;
                          } else {
                            if (_visible == true) {
                              _visible = false;
                            } else {
                              _visible = true;
                            }
                          }
                        });
                      },
                      icon: const Icon(Icons.mode_edit),
                      color: Colors.white,
                      iconSize: 18.0,
                    ),
                  ],
                ),
                Column(
                  children: const <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 1,
                      height: 20,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Center(
                    child: Image.network(widget.imagePath, fit: BoxFit.cover)),
                const SizedBox(height: 10),
                Visibility(
                  visible: _visible,
                  child: Column(
                    children: const <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                        height: 20,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _visible,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(unselectedWidgetColor: Colors.white),
                    child: Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          value: checkBox3,
                          activeColor: Colors.orangeAccent,
                          splashRadius: 30,
                          onChanged: (value) {
                            setState(() {
                              checkBox3 = value!;
                              if (checkBox3 == false) {
                                referenceController.clear();
                                _update();
                              } else {
                                checkBox = false;
                                checkBox2 = false;
                                referenceController.text =
                                    referenceSetState3.toString();
                                _update();
                              }
                            });
                          },
                        ),
                        const Text('ปกติ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(unselectedWidgetColor: Colors.white),
                    child: Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          value: checkBox,
                          activeColor: Colors.orangeAccent,
                          splashRadius: 30,
                          onChanged: (value) {
                            setState(() {
                              checkBox = value!;
                              if (checkBox == false) {
                                referenceController.clear();
                                _update();
                              } else {
                                checkBox2 = false;
                                checkBox3 = false;
                                referenceController.text =
                                    referenceSetState1.toString();
                                _update();
                              }
                            });
                          },
                        ),
                        const Text('ชำรุดรอซ่อม',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(unselectedWidgetColor: Colors.white),
                    child: Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          value: checkBox2,
                          activeColor: Colors.orangeAccent,
                          splashRadius: 30,
                          onChanged: (value) {
                            setState(() {
                              checkBox2 = value!;
                              if (checkBox2 == false) {
                                referenceController.clear();
                                _update();
                              } else {
                                checkBox = false;
                                checkBox3 = false;
                                referenceController.text =
                                    referenceSetState2.toString();
                                _update();
                              }
                            });
                          },
                        ),
                        const Text(
                          'รอตัดชำรุด',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _update() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json;charset=utf-8',
    };
    var client = http.Client();
    var url = Uri.http(Config.apiURL, Config.updateReference);
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "Reference": referenceController.text,
        "Code": widget.codeAssets,
        "RoundID": widget.round,
        "UserID": pref.getString("UserID")!,
      }),
    );
    // print(response.body);
    if (response.statusCode == 200) {
      final items = jsonDecode(response.body);
      setState(() {
        FormHelper.showSimpleAlertDialog(
            context, Config.appName, items['message'], "ยอมรับ", () {
          // Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewDetails(
                period_round: widget.round,
                beginDate: widget.date,
                endDate: widget.date,
                branchPermission: widget.backBranch,
              ),
            ),
          );
        });
      });
    } else {
      final items = jsonDecode(response.body);
      setState(() {
        FormHelper.showSimpleAlertDialog(
            context, Config.appName, items['message'], "ยอมรับ", () {
          // Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewDetails(
                period_round: widget.round,
                beginDate: widget.date,
                endDate: widget.date,
                branchPermission: widget.backBranch,
              ),
            ),
          );
        });
      });
    }
  }
}
