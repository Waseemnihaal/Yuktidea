import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart' as prefs;
import 'package:yuktidea/util/token.dart';

import 'home.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();

  int _seconds = 60;
  var flag = 0;

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  TextEditingController otpcontroller1 = TextEditingController();
  TextEditingController otpcontroller2 = TextEditingController();
  TextEditingController otpcontroller3 = TextEditingController();
  TextEditingController otpcontroller4 = TextEditingController();

  Future otp() async {
    try {
      print('Bearer ${await getToken()}');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${await getToken()}'
      };
      var url = Uri.parse('https://cinecompass.yuktidea.com/api/v1/otp/verify');
      Map body = {
        "otp": otpcontroller1.text +
            otpcontroller2.text +
            otpcontroller3.text +
            otpcontroller4.text
      };
      print('$body body of otp');
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print('${response.body} response.body from otp');
      print('${response.statusCode} response.statuscode');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        flag = 0;
        print("sucess");
        if (json['status'] == true) {
          Navigator.of(context).push(PageTransition(
              child: home(),
              type: PageTransitionType.fade,
              childCurrent: widget,
              duration: Duration(milliseconds: 600),
              alignment: Alignment.topLeft));
        } else {
          throw jsonDecode(response.body)["message"] ?? 'Unknown Error Occured';
        }
      } else {
        flag = 1;
        print("faild");
        throw jsonDecode(response.body)["message"] ?? 'Unknown Error Occured';
      }
    } catch (e) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text('Error'),
              contentPadding: EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 800,
        color: Color(0xff121110),
        child: Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 35, top: 100),
                child: Text(
                  'Verify Your Number',
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 140, left: 45),
                child: Text(
                  'Enter the OTP received on your number',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 300, left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: TextFormField(
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(color: Colors.white),
                        controller: otpcontroller1,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 134, 124, 124)),
                          fillColor: Colors.black54,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the OTP';
                          }
                          return null;
                        },
                        onSaved: (value) => value!,
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: TextFormField(
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(color: Colors.white),
                        controller: otpcontroller2,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 134, 124, 124)),
                          fillColor: Colors.black54,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the OTP';
                          }
                          return null;
                        },
                        onSaved: (value) => value!,
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: TextFormField(
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(color: Colors.white),
                        controller: otpcontroller3,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 134, 124, 124)),
                          fillColor: Colors.black54,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the OTP';
                          }
                          return null;
                        },
                        onSaved: (value) => value!,
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: TextFormField(
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(color: Colors.white),
                        controller: otpcontroller4,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 134, 124, 124)),
                          fillColor: Colors.black54,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the OTP';
                          }
                          return null;
                        },
                        onSaved: (value) => value!,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(top: 500, left: 100),
                child: Text(
                  'Resend OTP in ',
                  style: TextStyle(
                      color: Color.fromARGB(255, 134, 124, 124),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 500, left: 200),
                child: Text(
                  '  $_seconds seconds',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 680, left: 100),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xffEF403B),
                      borderRadius: BorderRadius.circular(10)),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(height: 50, width: 200),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        elevation: 0,
                      ),
                      onPressed: (() async {
                        final isValid = _formKey.currentState!.validate();

                        if (isValid) {
                          _formKey.currentState!.save();

                          await otp();
                        }
                      }),
                      child: Text(
                        'Verify',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
