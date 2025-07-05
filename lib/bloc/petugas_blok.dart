import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:catering_flutter/helpers/api.dart';
import 'package:catering_flutter/helpers/api_url.dart';
import 'package:catering_flutter/model/petugas.dart';

class PetugasBlok {
  // Ambil semua data petugas
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

  // Tambah data petugas
  static Future<bool> addPetugas({required Petugas petugas}) async {
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

  // Ubah data petugas
  static Future<bool> updatePetugas({required Petugas petugas}) async {
    String apiUrl = ApiUrl.updatePetugas(petugas.id!);

    var body = {
      "nama_petugas": petugas.namaPetugas,
      "jabatan": petugas.jabatan,
      "no_hape": petugas.no_hape.toString(),
    };

    var response = await Api().put(apiUrl, body);
    var jsonObj = json.decode(response.body);

    print('Respon Update Petugas: $jsonObj');

    return jsonObj['status'] == true;
  }

  // Hapus data petugas
  static Future<bool> deletePetugas({required int id}) async {
    final response = await http.delete(Uri.parse(ApiUrl.deletePetugas(id)));

    if (response.statusCode == 200) {
      final jsonObj = json.decode(response.body);
      return jsonObj['status'] == true;
    } else {
      print('Error deletePetugas: ${response.body}');
      return false;
    }
  }

  // Ambil detail petugas berdasarkan ID (opsional)
  static Future<Petugas> showPetugas(int id) async {
    final response = await http.get(Uri.parse(ApiUrl.showPetugas(id)));

    if (response.statusCode == 200) {
      final jsonObj = json.decode(response.body);
      return Petugas.fromJSON(jsonObj['data']);
    } else {
      throw Exception('Gagal mengambil data petugas dengan ID $id');
    }
  }
}
