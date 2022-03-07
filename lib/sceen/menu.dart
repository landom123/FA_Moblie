// ignore_for_file: file_names, unnecessary_new, unused_field, non_constant_identifier_names, unused_import
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_flutter_test/sceen/check_code.dart';
import 'package:new_flutter_test/service/shared_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:http/http.dart' as http;
import 'package:qrscan/qrscan.dart' as scanner;

import '../config.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  String? res_Detail;
  String? date_login;
  bool _isButtonDisabled = false;
  String? userCode;
  int? userBranch;
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globaAssetsFormkey = GlobalKey<FormState>();
  String? resultScan;

  @override
  dynamic initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
    };
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userBranch = pref.getInt("BranchID")!;
      userCode = pref.getString("UserCode")!;
      date_login = pref.getString("Date_Login")!;
    });
    if (date_login.toString().isNotEmpty) {
      var client = http.Client();
      var url = Uri.http(Config.apiURL, Config.periodLogin);
      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          "BeginDate": date_login.toString(),
          "EndDate": date_login.toString(),
          "BranchID": userBranch,
        }),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        pageRoute(body);
        setState(() {
          _isButtonDisabled = true;
        });
      }
    }
  }

  static pageRoute(dynamic body) async {
    SharedPreferences roundid = await SharedPreferences.getInstance();
    await roundid.setString("RoundID", body['PeriodRound']);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Initial: " +
                userCode.toString() +
                ' (' +
                userBranch.toString() +
                ')',
            style: const TextStyle(
                fontSize: 18, color: Color.fromRGBO(40, 59, 113, 1)),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                FormHelper.showSimpleAlertDialog(
                    context, Config.appName, "คุณออกจากระบบแล้ว", "ยอมรับ", () {
                  SharedService.logout(context);
                });
              },
              icon: const Icon(Icons.logout),
              color: const Color.fromRGBO(40, 59, 113, 1),
              iconSize: 28,
            )
          ],
        ),
        backgroundColor: HexColor('#283B71'),
        body: ProgressHUD(
          child: Form(
            key: globaAssetsFormkey,
            child: _detail(),
          ),
          inAsyncCall: isAPIcallProcess,
          opacity: 0,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _detail() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      "ยินดีต้อนรับสู่ แอปพลิเคชัน",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "กรุณาเลือกเมนู ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xffa29aac)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 5, right: 10.0, left: 20.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    primary: false,
                    children: <Widget>[
                      const SizedBox(
                        height: 30,
                      ),
                      Visibility(
                        visible: _isButtonDisabled,
                        child: Card(
                          elevation: 4.0,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  '/scanner/test_asset', (route) => false);
                            },
                            splashColor: const Color.fromRGBO(40, 59, 113, 1),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0, right: 15.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22.0)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 20.0),
                                    child: Icon(
                                      Icons.qr_code_2_rounded,
                                      color: Color.fromRGBO(45, 69, 135, 1),
                                      size: 40.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          children: const <Widget>[
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "สแกน Qr code",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      40, 59, 113, 1),
                                                ),
                                              ),
                                            ),
                                          ],
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
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 4.0,
                        child: InkWell(
                          onTap: () {
                            checkQR();
                          },
                          splashColor: const Color.fromRGBO(40, 59, 113, 1),
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 15.0, bottom: 15.0, right: 15.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 20.0),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Color.fromRGBO(40, 59, 113, 1),
                                    size: 40.0,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: const <Widget>[
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "ตรวจสอบ Qr Code",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    40, 59, 113, 1),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 4.0,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/scanner/viewDetails/periodRound',
                                (route) => false);
                          },
                          splashColor: const Color.fromRGBO(40, 59, 113, 1),
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 15.0, bottom: 15.0, right: 15.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 20.0),
                                  child: Icon(
                                    Icons.article,
                                    color: Color.fromRGBO(40, 59, 113, 1),
                                    size: 40.0,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: const <Widget>[
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "รายการทรัพย์สิน",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    40, 59, 113, 1),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //
        ],
      ),
    );
  }

  Future<void> checkQR() async {
    String? cameraScanResult = await scanner.scan();
    setState(() {
      resultScan = cameraScanResult!;
    });
    if (resultScan.toString().isNotEmpty) {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=utf-8',
      };
      var client = http.Client();
      var url = Uri.http(Config.apiURL, Config.assetsAPI);

      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({"Code": resultScan}),
      );
      if (response.statusCode == 200) {
        setState(() {
          dynamic itemsResponse = jsonDecode(response.body)['data'][0];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CheckCode(
                titleName: itemsResponse['Name'],
                codeAssets: itemsResponse['Code'],
                brachID: itemsResponse['BranchID'],
              ),
            ),
          );
        });
      } else {
        FormHelper.showSimpleAlertDialog(
            context, Config.appName, "ไม่พบ Code นี้ในระบบ", "OK", () {
          Navigator.pop(context);
        });
      }
    } else {
      FormHelper.showSimpleAlertDialog(
          context, Config.appName, 'กรุณาสแกน Code บ้างอย่าง', "OK", () {
        Navigator.pop(context);
      });
    }
  }
}
