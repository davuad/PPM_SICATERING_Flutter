import 'dart:convert';

import 'package:catering_flutter/helpers/api.dart';
import 'package:catering_flutter/helpers/api_url.dart';
import 'package:catering_flutter/model/registasi.dart';

class RegistrasiBloc {
  static Future<Registasi> registrasi({
    String? nama,
    String? email,
    String? password,
  }) async {
    String apiUrl = ApiUrl.registrasi;

    var body = {"nama": nama, "email": email, "password": password};

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    
    return Registasi.fromJSON(jsonObj);
  }
}
