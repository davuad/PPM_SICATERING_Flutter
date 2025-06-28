class Petugas {
  int? id;
  String? namaPetugas;
  String? jabatan;
  int? noHp;

  Petugas({this.id, this.namaPetugas, this.jabatan, this.noHp});

  factory Petugas.fromJSON(Map<String, dynamic> json) {
    return Petugas(
      id: json['id'],
      namaPetugas: json['nama_petugas'], 
      jabatan: json['jabatan'],
      noHp: json['noHp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_petugas': namaPetugas,
      'jabatan': jabatan,
      'no_hp': noHp,
    };
  }
}
