// ignore_for_file: unrelated_type_equality_checks, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:new_flutter_test/config.dart';
import 'package:new_flutter_test/models/login_request_model.dart';
import 'package:new_flutter_test/service/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class LohinSceen extends StatefulWidget {
  const LohinSceen({Key? key}) : super(key: key);

  @override
  _LohinSceenState createState() => _LohinSceenState();
}

class _LohinSceenState extends State<LohinSceen> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormkey = GlobalKey<FormState>();
  String? userCode;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Row(children: const <Widget>[
            SizedBox(
              width: 5.0,
            ),
          ]),
        ),
        backgroundColor: HexColor('#283B71'),
        body: ProgressHUD(
          child: Form(
            key: globalFormkey,
            child: _loginUI(context),
          ),
          inAsyncCall: isAPIcallProcess,
          opacity: 0,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
          const Padding(
            padding: EdgeInsets.only(left: 35, bottom: 20, top: 30),
            child: Text(
              "?????????????????????????????????????????????????????????????????????",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  //fontStyle: FontStyle.italic,
                  fontSize: 24,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: FormHelper.inputFieldWidget(
              context,
              const Icon(Icons.person),
              "UserCode",
              "UserCode",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "??????????????????????????? UserCode";
                }
                return null;
              },
              (onSavedVal) {
                userCode = onSavedVal;
              },
              borderColor: Colors.white,
              prefixIconColor: Colors.white,
              borderFocusColor: Colors.white,
              textColor: Colors.white,
              hintColor: Colors.white.withOpacity(0.6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
            child: FormHelper.inputFieldWidget(
              context,
              const Icon(Icons.lock_sharp),
              "password",
              "password",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "??????????????????????????? password";
                }
                return null;
              },
              (onSavedVal) {
                password = onSavedVal;
              },
              borderColor: Colors.white,
              prefixIconColor: Colors.white,
              borderFocusColor: Colors.white,
              textColor: Colors.white,
              hintColor: Colors.white.withOpacity(0.6),
              obscureText: hidePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Colors.white.withOpacity(0.8),
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 25, top: 12),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.6),
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Center(
              child: FormHelper.submitButton(
                "?????????????????????????????????",
                () {
                  if (validateAndSave()) {
                    setState(() {
                      isAPIcallProcess = true;
                    });

                    LoginRequstModel model = LoginRequstModel(
                      userCode: userCode!,
                      password: password!,
                    );

                    APIService.login(model).then((response) {
                      setState(() {
                        isAPIcallProcess = false;
                      });
                      if (response) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/permission_branch', (route) => false);
                      } else {
                        FormHelper.showSimpleAlertDialog(
                            context,
                            Config.appName,
                            "(UserCode ???????????? Password ?????????) ????????????????????????????????????????????????????????????????????????",
                            "??????????????????", () {
                          Navigator.pop(context);
                        });
                      }
                    });
                  }
                },
                btnColor: HexColor("#fc2d8a"),
                borderColor: Colors.white.withOpacity(0.5),
                borderRadius: 10,
                txtColor: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '???????????????????????????????????????????????? ? ?????????????????????????????????',
                  style: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.w400),
                ),
                FlatButton(
                  onPressed: () {},
                  child: const Text('IT support',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 46, 140, 1),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
