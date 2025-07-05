import 'dart:convert';

import 'package:catering_flutter/helpers/api.dart';
import 'package:catering_flutter/helpers/api_url.dart';
import 'package:catering_flutter/model/minuman.dart';

class MinumanBlok {
  // Ambil semua data minuman
  static Future<List<Minuman>> getMinuman() async {
    String apiUrl = ApiUrl.listMinuman;
    var response = await Api().get(apiUrl);

    var jsonObj = json.decode(response.body);
    List<dynamic> listMinuman = (jsonObj as Map<String, dynamic>)['data'];

    List<Minuman> minumans = [];
    for (int i = 0; i < listMinuman.length; i++) {
      minumans.add(Minuman.fromJSON(listMinuman[i]));
    }
    return minumans;
  }

  // Tambah data minuman
  static Future<bool> addMinuman({required Minuman minuman}) async {
    String apiUrl = ApiUrl.createMinuman;

    var body = {
      "kode_minuman": minuman.kodeMinuman,
      "nama_minuman": minuman.namaMinuman,
      "harga": minuman.hargaMinuman.toString(),
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);

    return jsonObj['status'] == true;
  }

  // Ubah data minuman
  static Future<bool> updateMinuman({required Minuman minuman}) async {
    String apiUrl = ApiUrl.updateMinuman(minuman.id!);

    var body = {
      "kode_minuman": minuman.kodeMinuman,
      "nama_minuman": minuman.namaMinuman,
      "harga": minuman.hargaMinuman.toString(),
    };

    var response = await Api().put(apiUrl, body);
    var jsonObj = json.decode(response.body);

    print('Respon Update: $jsonObj');

    return jsonObj['status'] == true;
  }

  // Hapus data minuman
  static Future<bool> deleteMinuman({required int id}) async {
    String apiUrl = ApiUrl.deleteMinuman(id);

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);

    return jsonObj['status'] == true;
  }

  // Ambil detail minuman berdasarkan ID (opsional tambahan)
  static Future<Minuman> showMinuman(int id) async {
    String apiUrl = ApiUrl.showMinuman(id);
    var response = await Api().get(apiUrl);

    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      return Minuman.fromJSON(jsonObj['data']);
    } else {
      throw Exception('Gagal mengambil data minuman dengan ID $id');
    }
  }
}
