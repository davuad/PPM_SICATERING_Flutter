class ApiUrl {
  // Base URL mock server Postman
  static const String baseUrl =
      'https://bc1c6696-936f-4f45-b6fa-92a5cf7633fb.mock.pstmn.io';

  // AUTH
  static const String registrasi = '$baseUrl/registrasi';
  static const String login = '$baseUrl/login';

  // ========================
  // MAKANAN
  // ========================
  static const String listMakanan = '$baseUrl/makanan';
  static const String createMakanan = '$baseUrl/makanan';
  static String showMakanan(int id) => '$baseUrl/makanan/$id';
  static String updateMakanan(int id) => '$baseUrl/makanan/$id';
  static String deleteMakanan(int id) => '$baseUrl/makanan/$id';

  // ========================
  // MINUMAN
  // ========================
  static const String listMinuman = '$baseUrl/minuman';
  static const String createMinuman = '$baseUrl/minuman';
  static String showMinuman(int id) => '$baseUrl/minuman/$id';
  static String updateMinuman(int id) => '$baseUrl/minuman/$id';
  static String deleteMinuman(int id) => '$baseUrl/minuman/$id';

  // ========================
  // PETUGAS
  // ========================
  static const String listPetugas = '$baseUrl/petugas';
  static const String createPetugas = '$baseUrl/petugas';
  static String showPetugas(int id) => '$baseUrl/petugas/$id';
  static String updatePetugas(int id) => '$baseUrl/petugas/$id';
  static String deletePetugas(int id) => '$baseUrl/petugas/$id';
}
