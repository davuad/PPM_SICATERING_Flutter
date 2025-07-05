import 'dart:convert';

import 'package:catering_flutter/helpers/api.dart';
import 'package:catering_flutter/helpers/api_url.dart';
import 'package:catering_flutter/model/login.dart';

class LoginBloc {

  static Future<Login> login({String? email, String? password}) async {
    String apiUrl = ApiUrl.login;
    var body = {"email": email, "password": password};

    var response = await Api().post(apiUrl, body);
    print(response.body); // ← sekarang ini benar

    var jsonObj = json.decode(response.body);
    return Login.fromJSON(jsonObj);
  }

}
