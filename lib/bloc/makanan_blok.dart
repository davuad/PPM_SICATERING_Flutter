import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:catering_flutter/helpers/api_url.dart';
import 'package:catering_flutter/model/makanan.dart';

class MakananBlok {
  static Future<List<Makanan>> getMakanan() async {
    final response = await http.get(Uri.parse(ApiUrl.listMakanan));

    if (response.statusCode == 200) {
      // Decode JSON
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Ambil List dari field "data"
      List<dynamic> dataList = jsonResponse['data'];

      // Map ke List<Makanan>
      return dataList.map((item) => Makanan.fromJSON(item)).toList();
    } else {
      throw Exception('Gagal memuat data makanan: ${response.statusCode}');
    }
  }

  static Future<bool> addMakanan(Makanan makanan) async {
    final response = await http.post(
      Uri.parse(ApiUrl.createMakanan),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(makanan.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print('Error createMakanan: ${response.body}');
      return false;
    }
  }

  static Future<bool> updateMakanan(Makanan makanan) async {
    final response = await http.put(
      Uri.parse(ApiUrl.updateMakanan(makanan.id!)),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(makanan.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error updateMakanan: ${response.body}');
      return false;
    }
  }

  static Future<bool> deleteMakanan(int id) async {
    final response = await http.delete(Uri.parse(ApiUrl.deleteMakanan(id)));

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error deleteMakanan: ${response.body}');
      return false;
    }
  }

  static Future<Makanan> showMakanan(int id) async {
    final response = await http.get(Uri.parse(ApiUrl.showMakanan(id)));

    if (response.statusCode == 200) {
      return Makanan.fromJSON(json.decode(response.body));
    } else {
      throw Exception('Gagal mengambil data makanan dengan ID $id');
    }
  }
}
