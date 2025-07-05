import 'dart:convert';

import 'package:catering_flutter/helpers/api.dart';
import 'package:catering_flutter/helpers/api_url.dart';
import 'package:catering_flutter/model/makanan.dart';

class MakananBlok {
  // Ambil semua data makanan
  static Future<List<Makanan>> getMakanan() async {
    String apiUrl = ApiUrl.listMakanan;
    var response = await Api().get(apiUrl);

    var jsonObj = json.decode(response.body);
    List<dynamic> listMakanan = (jsonObj as Map<String, dynamic>)['data'];

    List<Makanan> makanans = [];
    for (int i = 0; i < listMakanan.length; i++) {
      makanans.add(Makanan.fromJSON(listMakanan[i]));
    }
    return makanans;
  }

  // Tambah data makanan
  static Future<bool> addMakanan({required Makanan makanan}) async {
    String apiUrl = ApiUrl.createMakanan;

    var body = {
      "kode_makanan": makanan.kodeMakanan,
      "nama_makanan": makanan.namaMakanan,
      "harga": makanan.hargaMakanan.toString(),
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);

    return jsonObj['status'] == true;
  }

  // Ubah data makanan
  static Future<bool> updateMakanan({required Makanan makanan}) async {
    String apiUrl = ApiUrl.updateMakanan(makanan.id!);

    var body = {
      "kode_makanan": makanan.kodeMakanan,
      "nama_makanan": makanan.namaMakanan,
      "harga": makanan.hargaMakanan.toString(),
    };

    var response = await Api().put(apiUrl, body); // PUT method
    var jsonObj = json.decode(response.body);

    print('Respon Update: $jsonObj');

    return jsonObj['status'] == true;
  }

  // Hapus data makanan
  static Future<bool> deleteMakanan({required int id}) async {
    String apiUrl = ApiUrl.deleteMakanan(id);

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);

    return jsonObj['status'] == true;
  }

  // Ambil detail makanan berdasarkan ID (opsional tambahan)
  static Future<Makanan> showMakanan(int id) async {
    String apiUrl = ApiUrl.showMakanan(id);
    var response = await Api().get(apiUrl);

    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      return Makanan.fromJSON(jsonObj['data']);
    } else {
      throw Exception('Gagal mengambil data makanan dengan ID $id');
    }
  }
}
