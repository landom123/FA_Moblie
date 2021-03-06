// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:new_flutter_test/config.dart';
import 'package:http/http.dart' as http;

import 'menu.dart';

class TestAsset extends StatefulWidget {
  final int branchPermission;
  final String dateTimeNow;
  const TestAsset({
    Key? key,
    required this.branchPermission,
    required this.dateTimeNow,
  }) : super(key: key);

  @override
  _TestAssetState createState() => _TestAssetState();
}

class _TestAssetState extends State<TestAsset> {
  GlobalKey<FormState> codeFormkey = GlobalKey<FormState>();
  bool isAPIcallProcessAssets = false;
  var codeController = TextEditingController();
  var nameController = TextEditingController();
  var branchController = TextEditingController();
  var dateTimeController = TextEditingController();
  int statusController = 1;
  var assetIDController = TextEditingController();
  var referenceController = TextEditingController();
  String referenceSetState1 = "ชำรุดรอซ่อม";
  String referenceSetState2 = "รอตัดชำรุด";
  bool checkBox = false;
  bool checkBox2 = false;
  String? moneyController;
  String? userID;
  int? userBranch;
  String? userCode;
  int userBranchID = 0;
  bool _visible = false;
  bool _visibleRead = false;
  dynamic itemOfName = [];
  var round_id = TextEditingController();
  var now = DateTime.now();

  @override
  dynamic initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userBranch = pref.getInt("BranchID")!;
      userCode = pref.getString("UserCode")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Row(children: <Widget>[
            const SizedBox(
              width: 5.0,
            ),
            IconButton(
              color: Colors.white,
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromRGBO(40, 59, 113, 1),
                size: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Scanner(
                      brachID: widget.branchPermission,
                      dateTimeNow: now.toString(),
                    ),
                  ),
                );
              },
            ),
          ]),
        ),
        backgroundColor: HexColor('#283B71'),
        body: ProgressHUD(
          child: Form(
            key: codeFormkey,
            child: _scanner(context),
          ),
          inAsyncCall: isAPIcallProcessAssets,
          opacity: 0,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _scanner(BuildContext context) {
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
              children: <Widget>[
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
          const SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 35, right: 16),
                child: Text(
                  'กดที่ สแกน QR CODE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 4),
              Padding(
                padding: EdgeInsets.only(left: 35, right: 16),
                child: Text(
                  'เพื่อทำการเปิดกล้อง',
                  style: TextStyle(
                      color: Color(0xffa29aac),
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Visibility(
                  visible: _visible,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: TextField(
                      readOnly: true,
                      textAlign: TextAlign.center,
                      controller: codeController,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "Code",
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.subtitles_rounded,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: _visible,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: TextField(
                      readOnly: true,
                      textAlign: TextAlign.center,
                      controller: nameController,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "ชื่อ",
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.subtitles_rounded,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Visibility(
                  visible: _visible,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 110,
                          child: TextField(
                            readOnly: true,
                            textAlign: TextAlign.center,
                            controller: branchController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                labelText: "สาขา",
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.subtitles_rounded,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 190,
                          child: TextField(
                            readOnly: true,
                            textAlign: TextAlign.center,
                            controller: dateTimeController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 1))),
                                labelText: "วันที่และเวลา",
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.subtitles_rounded,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: _visible,
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(unselectedWidgetColor: Colors.white),
                          child: Row(
                            children: [
                              Checkbox(
                                value: checkBox,
                                splashRadius: 30,
                                activeColor: Colors.orangeAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onChanged: (value) {
                                  setState(() {
                                    checkBox = value!;
                                    if (checkBox == false) {
                                      referenceController.clear();
                                      update();
                                    } else {
                                      checkBox2 = false;
                                      referenceController.text =
                                          referenceSetState1.toString();
                                      update();
                                    }
                                  });
                                },
                              ),
                              const Text('ชำรุดรอซ่อม',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Visibility(
                        visible: _visible,
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(unselectedWidgetColor: Colors.white),
                          child: Row(
                            children: [
                              Checkbox(
                                value: checkBox2,
                                splashRadius: 30,
                                activeColor: Colors.orangeAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onChanged: (value) {
                                  setState(() {
                                    checkBox2 = value!;
                                    if (checkBox2 == false) {
                                      referenceController.clear();
                                      update();
                                    } else {
                                      checkBox = false;
                                      referenceController.text =
                                          referenceSetState2.toString();
                                      update();
                                    }
                                  });
                                },
                              ),
                              const Text('รอตัดชำรุด',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                elevation: 4.0,
                child: InkWell(
                  focusColor: const Color.fromRGBO(40, 59, 113, 1),
                  hoverColor: const Color.fromRGBO(40, 59, 113, 1),
                  onTap: () {
                    startScan();
                  },
                  splashColor: const Color.fromRGBO(45, 69, 135, 1),
                  child: Container(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            color: Color.fromRGBO(40, 59, 113, 1),
                            size: 40.0,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: const [
                                    Text(
                                      'สแกนนับทรัพย์สินและการทำบันทึก',
                                      style: TextStyle(color: Colors.black38),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "สแกน QR CODE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 28.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(40, 59, 113, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  //Scan
  Future<void> startScan() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    SharedPreferences roundid = await SharedPreferences.getInstance();
    try {
      String? cameraScanResult = await scanner.scan();
      setState(() {
        codeController.text = cameraScanResult!;
      });

      if (codeController.text.isNotEmpty) {
        Map<String, String> requestHeaders = {
          'Content-Type': 'application/json; charset=utf-8',
        };
        var client = http.Client();
        var url = Uri.http(Config.apiURL, Config.assetsAPI);

        var response = await client.post(
          url,
          headers: requestHeaders,
          body: jsonEncode({
            "Code": codeController.text,
            "UserBranch": widget.branchPermission,
            "RoundID": roundid.getString("RoundID")!,
          }),
        );
        if (response.statusCode == 200) {
          dynamic itemsResponse = jsonDecode(response.body);
          setState(() {
            nameController.text = itemsResponse['data'][0]['Name'];
            dateTimeController.text = '$now';
            branchController.text =
                itemsResponse['data'][0]['BranchID'].toString();
            assetIDController.text =
                itemsResponse['data'][0]['AssetID'].toString();
            userID = pref.getString("UserID")!;
            userBranchID = pref.getInt("BranchID")!;
            round_id.text = roundid.getString("RoundID")!;
            referenceController.text = "";
          });
          if (codeController.text.isNotEmpty &&
              nameController.text.isNotEmpty &&
              branchController.text.isNotEmpty &&
              dateTimeController.text.isNotEmpty &&
              assetIDController.text.isNotEmpty &&
              userID.toString().isNotEmpty) {
            var client = http.Client();
            var url = Uri.http(Config.apiURL, Config.addAssetsAPI);
            var response = await client.post(
              url,
              headers: requestHeaders,
              body: jsonEncode({
                "Name": nameController.text,
                "Code": codeController.text,
                "BranchID": branchController.text,
                "Date": dateTimeController.text,
                "Status": statusController,
                "UserID": userID,
                "UserBranch": widget.branchPermission,
                "RoundID": round_id.text,
                "Reference": referenceController.text,
              }),
            );
            if (response.statusCode == 200) {
              dynamic itemsResponse = jsonDecode(response.body);
              FormHelper.showSimpleAlertDialog(
                  context, Config.appName, itemsResponse['message'], "OK", () {
                Navigator.pop(context);
              });
              setState(() {
                _visible = true;
                _visibleRead = false;
              });
            } else {
              _visible = false;
              _visibleRead = false;
              dynamic itemsResponse = jsonDecode(response.body);
              FormHelper.showSimpleAlertDialog(
                  context, Config.appName, itemsResponse['message'], "ยอมรับ",
                  () {
                Navigator.pop(context);
                setState(() {
                  assetIDController.clear();
                  codeController.clear();
                  nameController.clear();
                  branchController.clear();
                  dateTimeController.clear();
                });
              });
            }
          }
        } else {
          dynamic itemsResponse = jsonDecode(response.body);
          FormHelper.showSimpleAlertDialog(
              context,
              Config.appName,
              itemsResponse['message'].toString() +
                  itemsResponse['data'].toString(),
              "ยอมรับ", () {
            Navigator.pop(context);
          });
        }
      } else {
        FormHelper.showSimpleAlertDialog(
            context, Config.appName, "กรุณาใส่ข้อมูล", "ยอมรับ", () {
          Navigator.pop(context);
        });
      }
    } on PlatformException {
      codeController.text = "Failed to get platfrom version.";
    }
  }

  Future<void> update() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json;charset=utf-8',
    };
    var client = http.Client();
    var url = Uri.http(Config.apiURL, Config.updateReference);
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "Code": codeController.text,
        "RoundID": round_id.text,
        "Reference": referenceController.text,
        "UserID": userID,
      }),
    );
    // print(response.body);
    if (response.statusCode == 200) {
      _visible = false;
      _visibleRead = false;
      dynamic itemsResponse = jsonDecode(response.body);
      FormHelper.showSimpleAlertDialog(
          context, Config.appName, itemsResponse['message'], "ยอมรับ", () {
        Navigator.pop(context);
        setState(() {
          _visible = true;
          _visibleRead = false;
        });
      });
    }
  }
}
