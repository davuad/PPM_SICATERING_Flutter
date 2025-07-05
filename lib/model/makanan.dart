import 'package:flutter/material.dart';

class Makanan {
  int? id;
  String? kodeMakanan;
  String? namaMakanan;
  int? hargaMakanan;

  Makanan({this.id, this.kodeMakanan, this.namaMakanan, this.hargaMakanan});

   factory Makanan.fromJSON(Map<String, dynamic> json) {
    return Makanan(
      id: int.tryParse(json['id'].toString()),
      kodeMakanan: json['kode_makanan'],
      namaMakanan: json['nama_makanan'],
      hargaMakanan: int.tryParse(json['harga'].toString()),
    );
  }
}