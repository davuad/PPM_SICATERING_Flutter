class Petugas {
  int? id;
  String? namaPetugas;
  String? jabatan;
  int? no_hape;

  Petugas({this.id, this.namaPetugas, this.jabatan, this.no_hape});

  factory Petugas.fromJSON(Map<String, dynamic> json) {
    return Petugas(
      id: json['id'],
      namaPetugas: json['nama_petugas'], 
      jabatan: json['jabatan'],
      no_hape: json['no_hape'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_petugas': namaPetugas,
      'jabatan': jabatan,
      'no_hape': no_hape,
    };
  }
}
