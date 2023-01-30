import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yuktidea/login.dart';
import 'package:yuktidea/otp.dart';
import 'package:http/http.dart' as http;

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late String _email;

  late String _password;
  bool _obscure = true;

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();

  TextEditingController numbercontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmPasswordcontroller = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void sign() async {
    try {
      var headers = {"Content-Type": "application/json"};
      var url = Uri.parse('https://cinecompass.yuktidea.com/api/v1/register');
      Map body = {
        "name": namecontroller.text,
        "email": emailcontroller.text,
        "phone": numbercontroller.text,
        "password": passwordcontroller.text,
        "password_confirmation": confirmPasswordcontroller.text
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        print("sucess");
        final json = jsonDecode(response.body);
        print(json);
        if (json['status'] == true) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OTPScreen()));
          var token = json['data'][0]['access_token'];
          print('$token token from signup');

          final SharedPreferences prefs = await _prefs;

          prefs.setString('token', token!);
          prefs.setInt(
              'tokenGeneratedTime', DateTime.now().millisecondsSinceEpoch);
        } else {
          throw jsonDecode(response.body)["error"] ?? 'Unknown Error Occured';
        }
      } else {
        print("faild");
        print(jsonDecode(response.body)["error"]);
        throw jsonDecode(response.body)["error"] ?? 'Unknown Error Occured';
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
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Create New Account',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 55),
                    child: Text(
                      'Fill in the form to continue',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: namecontroller,
                      decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 134, 124, 124)),
                          fillColor: Colors.black54,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name corectly';
                        }
                        return null;
                      },
                      onSaved: (value) => setState(() => value!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 205),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: emailcontroller,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 134, 124, 124)),
                          fillColor: Colors.black54,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter correct email';
                        }
                        return null;
                      },
                      onSaved: (value) => setState(() => value!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 290),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.white),
                      controller: numbercontroller,
                      decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 134, 124, 124)),
                          fillColor: Colors.black54,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value!.length < 9) {
                          return 'Phone Number must be 10 digits';
                        }
                        return null;
                      },
                      onSaved: (value) => setState(() => value!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 375),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: passwordcontroller,
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
                    padding: const EdgeInsets.only(top: 460),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: confirmPasswordcontroller,
                      decoration: InputDecoration(
                          labelText: 'Confirm Password',
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

                              sign();
                            }
                          }),
                          child: Text(
                            'Sign Up',
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
                      ' Login',
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
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => login(),
                                ),
                                (route) => false,
                              );
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
      //  authenticate(_email, _password);
    }
  }
}
