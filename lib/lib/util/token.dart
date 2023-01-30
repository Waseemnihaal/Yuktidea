import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  int? tokenGeneratedTime = prefs.getInt('tokenGeneratedTime');
  print('$tokenGeneratedTime tokenGeneratedTime');
  print('$token token');
  if ((DateTime.now().millisecondsSinceEpoch - tokenGeneratedTime!) > 60000) {
    var response = await http.post(
      Uri.parse('https://cinecompass.yuktidea.com/api/v1/refresh'),
      headers: {'Content-Type': 'application/json', 'Authorization': token!},
    );

    var responseJson = jsonDecode(response.body);
    token = responseJson['data'][0]['access_token'];
    tokenGeneratedTime = DateTime.now().millisecondsSinceEpoch;
    prefs.setString('token', token!);
    prefs.setInt('tokenGeneratedTime', tokenGeneratedTime);
  }
  print('$token token');
  return token;
}
