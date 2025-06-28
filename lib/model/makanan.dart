import 'package:flutter/material.dart';

class Makanan {
  int? id;
  String? kodeMakanan;
  String? namaMakanan;
  int? hargaMakanan;

  Makanan({this.id, this.kodeMakanan, this.namaMakanan, this.hargaMakanan});

   factory Makanan.fromJSON(Map<String, dynamic> json) {
    return Makanan(
      id: json['id'],
      kodeMakanan: json['kode_makanan'],
      namaMakanan: json['nama_makanan'],
      hargaMakanan: (json['harga'] as num?)?.toInt(),
    );
  }

   // Konversi dari objek Makanan ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_makanan': kodeMakanan,
      'nama_makanan': namaMakanan,
      'harga': hargaMakanan,
    };
  }
}