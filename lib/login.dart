import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yuktidea/home.dart';
import 'package:yuktidea/signup.dart';
import 'package:http/http.dart' as http;

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _obscure = true;

  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var z;
  int flag = 0;
  void log() async {
    try {
      var headers = {"Content-Type": "application/json"};
      var url = Uri.parse('https://cinecompass.yuktidea.com/api/v1/login');
      Map body = {
        "login": numberController.text,
        "password": passwordController.text
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

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
          var token = json['data'][0]['access_token'];
          print('$token token from login');
          final SharedPreferences? prefs = await _prefs;

          prefs!.setString('token', token!);
          prefs.setInt(
              'tokenGeneratedTime', DateTime.now().millisecondsSinceEpoch);
        } else {
          throw jsonDecode(response.body)["message"] ?? 'Unknown Error Occured';
        }
      } else {
        flag = 1;
        print("faild");
        z = jsonDecode(response.body)["message"] ?? 'Unknown Error Occured';
        print(z);
        throw z;
        return z;
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
  Widget build(BuildContext context) {
    return MaterialApp(home: Builder(builder: (context) {
      return Scaffold(
        key: _scaffoldKey,
        body: Container(
          color: Color(0xff121110),
          height: 800,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 100, left: 40, right: 40),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Welcome Back!',
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 45),
                    child: Text(
                      'Plese sign in to your account',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 210),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: numberController,
                      decoration: InputDecoration(
                          labelText: 'Email or Number',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 134, 124, 124)),
                          fillColor: Colors.black54,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value!.length != 10) {
                          return 'Number should be 10 digits';
                        } else if (flag == 1) {
                          return z;
                        }
                        return null;
                      },
                      onSaved: (value) => setState(() => value!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 300),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: passwordController,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 134, 124, 124)),
                          fillColor: Colors.black38,
                          filled: true,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                            child: Icon(
                              _obscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color.fromARGB(255, 134, 124, 124),
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value!.length < 8) {
                          return 'Password must be >=8';
                        }
                        return null;
                      },
                      onSaved: (value) => setState(() => value!),
                      obscureText: _obscure,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 380),
                    child: Text('Forgot password?',
                        style: TextStyle(
                            color: Color.fromARGB(255, 134, 124, 124),
                            fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 580, left: 50),
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
                          onPressed: (() {
                            final isValid = _formKey.currentState!.validate();

                            if (isValid) {
                              _formKey.currentState!.save();

                              log();
                            }
                          }),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 640, left: 50),
                    child: Text(
                      'Don\'t have an account?',
                      style:
                          TextStyle(color: Color.fromARGB(255, 134, 124, 124)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 640, left: 200),
                    child: Text(
                      'Signup',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xffEF403B)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 640, left: 193),
                    child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                          height: 20,
                          width: 60,
                        ),
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.transparent),
                            ),
                            onPressed: (() {
                              Navigator.of(context).push(PageTransition(
                                  child: signup(),
                                  type: PageTransitionType.rightToLeftWithFade,
                                  childCurrent: widget,
                                  duration: Duration(milliseconds: 600),
                                  alignment: Alignment.topLeft));
                            }),
                            child: Text(''))),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }));
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform authentication or navigation here
      // Example:
      //  authenticate(_email, _passwordController);
    }
  }
}
