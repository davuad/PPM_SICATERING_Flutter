import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:catering_flutter/helpers/api_url.dart';
import 'package:catering_flutter/model/minuman.dart';

class MinumanBlok {
  // Ambil semua minuman
  static Future<List<Minuman>> getMinuman() async {
    final response = await http.get(Uri.parse(ApiUrl.listMinuman));

    if (response.statusCode == 200) {
      // Decode JSON
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Ambil List dari field "data"
      List<dynamic> dataList = jsonResponse['data'];

      // Map ke List<Minuman>
      return dataList.map((item) => Minuman.fromJSON(item)).toList();
    } else {
      throw Exception('Gagal memuat data minuman: ${response.statusCode}');
    }
  }

  // Tambah minuman
  static Future<bool> addMinuman(Minuman minuman) async {
    final response = await http.post(
      Uri.parse(ApiUrl.createMinuman),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(minuman.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonObj = json.decode(response.body);
      return jsonObj['status'] == true;
    } else {
      print('Error addMinuman: ${response.body}');
      return false;
    }
  }

  // Ubah minuman
  static Future<bool> updateMinuman(Minuman minuman) async {
    final response = await http.put(
      Uri.parse(ApiUrl.updateMinuman(minuman.id!)),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(minuman.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonObj = json.decode(response.body);
      return jsonObj['status'] == true;
    } else {
      print('Error updateMinuman: ${response.body}');
      return false;
    }
  }

  // Hapus minuman
  static Future<bool> deleteMinuman(int id) async {
    final response = await http.delete(Uri.parse(ApiUrl.deleteMinuman(id)));

    if (response.statusCode == 200) {
      final jsonObj = json.decode(response.body);
      return jsonObj['status'] == true;
    } else {
      print('Error deleteMinuman: ${response.body}');
      return false;
    }
  }

  // Detail minuman (opsional)
  static Future<Minuman> showMinuman(int id) async {
    final response = await http.get(Uri.parse(ApiUrl.showMinuman(id)));

    if (response.statusCode == 200) {
      final jsonObj = json.decode(response.body);
      return Minuman.fromJSON(jsonObj['data']);
    } else {
      throw Exception('Gagal memuat detail minuman');
    }
  }
}
