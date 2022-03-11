import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import 'menu_reported.dart';

class NoCountedSceen extends StatefulWidget {
  final String assetID;
  final oCcy = NumberFormat("#,##0.00", "th");
  final String titleName;
  final String codeAssets;
  final int brachID;
  final String roundID;
  NoCountedSceen({
    Key? key,
    required this.titleName,
    required this.codeAssets,
    required this.brachID,
    required this.assetID,
    required this.roundID,
  }) : super(key: key);
  @override
  _NoCountedSceenState createState() => _NoCountedSceenState();
}

class _NoCountedSceenState extends State<NoCountedSceen> {
  bool checkBox = false;
  bool checkBox2 = false;
  var referenceController = TextEditingController();
  String referenceSetState2 = 'QR Code ไม่สมบูรณ์';
  final now = DateTime.now();
  final int status = 1;
  var titleName = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
    setState(() {
      titleName.text = widget.titleName;
    });
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
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                    height: 20,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 25),
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
                          value: checkBox2,
                          activeColor: Colors.orangeAccent,
                          splashRadius: 30,
                          onChanged: (value) {
                            setState(() {
                              checkBox2 = value!;
                              if (checkBox2 == false) {
                                referenceController.clear();
                                _createupdate();
                              } else {
                                checkBox = false;
                                referenceController.text =
                                    referenceSetState2.toString();
                                _createupdate();
                              }
                            });
                          },
                        ),
                        const Text('QR Code ไม่สมบูรณ์',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
    );
  }

  Future<void> _createupdate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    SharedPreferences roundid = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
    };
    var client = http.Client();
    var url = Uri.http(Config.apiURL, Config.assetsAPI);

    var response1 = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "Code": widget.codeAssets,
        "UserBranch": widget.brachID,
        "RoundID": roundid.getString("RoundID")!,
      }),
    );
    if (response1.statusCode == 200) {
      var client = http.Client();
      var url = Uri.http(Config.apiURL, Config.periodLogin);
      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          "BeginDate": now.toString(),
          "EndDate": now.toString(),
          "BranchID": widget.brachID.toInt(),
        }),
      );
      if (response.statusCode == 200) {
        var items = jsonDecode(response.body)['PeriodRound'];
        if (items != widget.roundID) {
          setState(() {
            FormHelper.showSimpleAlertDialog(
                context,
                Config.appName,
                "ไม่สามารถบันทึกข้อมูลได้เนื่องจากรอบบันทึกไม่ถูกต้อง",
                "ยอมรับ", () {
              Navigator.pop(context);
            });
            checkBox2 = false;
          });
        } else {
          var client = http.Client();
          var url = Uri.http(Config.apiURL, Config.addAssetsAPI);
          var response = await client.post(
            url,
            headers: requestHeaders,
            body: jsonEncode({
              "Name": widget.titleName,
              "Code": widget.codeAssets,
              "BranchID": widget.brachID.toInt(),
              "Date": '$now',
              "Status": status,
              "UserID": pref.getString("UserID")!,
              "UserBranch": widget.brachID,
              "RoundID": roundid.getString("RoundID")!,
              "Reference": referenceController.text,
            }),
          );
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
                      period_round: roundid.getString("RoundID")!,
                      beginDate: now.toString(),
                      endDate: now.toString(),
                      branchPermission: widget.brachID,
                    ),
                  ),
                );
              });
            });
          } else {
            setState(() {
              FormHelper.showSimpleAlertDialog(
                  context,
                  Config.appName,
                  'มีการบันทึกทรัพย์สินนี้ ในรอบที่ ' +
                      roundid.getString("RoundID").toString() +
                      ' ไปแล้ว',
                  "ยอมรับ", () {
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewDetails(
                      period_round: roundid.getString("RoundID")!,
                      beginDate: now.toString(),
                      endDate: now.toString(),
                      branchPermission: widget.brachID,
                    ),
                  ),
                );
              });
            });
          }
        }
      } else {
        setState(() {
          var items = jsonDecode(response.body)['data'];
          FormHelper.showSimpleAlertDialog(context, Config.appName,
              "ไม่สามารถบันทึกข้อมูลได้เนื่องจาก $items", "ยอมรับ", () {
            Navigator.pop(context);
          });
        });
      }
    } else {
      setState(() {
        FormHelper.showSimpleAlertDialog(
            context, Config.appName, "ไม่สามารถบันทึกข้อมูลได้", "ยอมรับ", () {
          Navigator.pop(context);
        });
      });
    }
  }
}
