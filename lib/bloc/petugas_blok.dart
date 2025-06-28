import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:catering_flutter/helpers/api_url.dart';
import 'package:catering_flutter/model/petugas.dart';

class PetugasBlok {
  // Ambil semua petugas
  static Future<List<Petugas>> getPetugas() async {
    final response = await http.get(Uri.parse(ApiUrl.listPetugas));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('data')) {
        List<dynamic> dataList = jsonResponse['data'];
        return dataList.map((item) => Petugas.fromJSON(item)).toList();
      } else {
        throw Exception('Data petugas tidak ditemukan di response');
      }
    } else {
      throw Exception('Gagal memuat data petugas: ${response.statusCode}');
    }
  }

  // Tambah petugas
  static Future<bool> addPetugas(Petugas petugas) async {
    final response = await http.post(
      Uri.parse(ApiUrl.createPetugas),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(petugas.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonObj = json.decode(response.body);
      return jsonObj['status'] == true;
    } else {
      print('Error addPetugas: ${response.body}');
      return false;
    }
  }

  // Ubah petugas
  static Future<bool> updatePetugas(Petugas petugas) async {
    final response = await http.put(
      Uri.parse(ApiUrl.updatePetugas(petugas.id!)),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(petugas.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonObj = json.decode(response.body);
      return jsonObj['status'] == true;
    } else {
      print('Error updatePetugas: ${response.body}');
      return false;
    }
  }

  // Hapus petugas
  static Future<bool> deletePetugas(int id) async {
    final response = await http.delete(Uri.parse(ApiUrl.deletePetugas(id)));

    if (response.statusCode == 200) {
      final jsonObj = json.decode(response.body);
      return jsonObj['status'] == true;
    } else {
      print('Error deletePetugas: ${response.body}');
      return false;
    }
  }

  // Detail petugas (opsional)
  static Future<Petugas> showPetugas(int id) async {
    final response = await http.get(Uri.parse(ApiUrl.showPetugas(id)));

    if (response.statusCode == 200) {
      final jsonObj = json.decode(response.body);
      return Petugas.fromJSON(jsonObj['data']);
    } else {
      throw Exception('Gagal memuat detail petugas');
    }
  }
}
