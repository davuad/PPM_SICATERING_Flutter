import 'dart:convert';

import 'package:flutter/material.dart';

class Minuman {
  int? id;
  String? kodeMinuman;
  String? namaMinuman;
  int? hargaMinuman;

  Minuman({this.id, this.kodeMinuman, this.namaMinuman, this.hargaMinuman});

  factory Minuman.fromJSON(Map<String, dynamic> json) {
    return Minuman(
      id: json['id'],
      kodeMinuman: json['kode_minuman'],
      namaMinuman: json['nama_minuman'],
      hargaMinuman: json['harga'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_minuman': kodeMinuman,
      'nama_minuman': namaMinuman,
      'harga': hargaMinuman,
    };
  }
}
