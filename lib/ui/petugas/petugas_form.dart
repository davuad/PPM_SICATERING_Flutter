import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:catering_flutter/model/petugas.dart';
import 'package:catering_flutter/ui/petugas/petugas_page.dart';
import 'package:catering_flutter/widget/warning_dialog.dart';

class PetugasForm extends StatefulWidget {
  final Petugas? petugas;

  const PetugasForm({Key? key, this.petugas}) : super(key: key);

  @override
  _PetugasFormState createState() => _PetugasFormState();
}

class _PetugasFormState extends State<PetugasForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();

  String _judul = "TAMBAH PETUGAS";
  String _tombol = "SIMPAN";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.petugas != null) {
      _judul = "UBAH PETUGAS";
      _tombol = "UBAH";
      _namaController.text = widget.petugas!.namaPetugas ?? '';
      _jabatanController.text = widget.petugas!.jabatan ?? '';
      _noHpController.text = widget.petugas!.noHp.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildNamaField(),
                _buildJabatanField(),
                _buildNoHpField(),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNamaField() {
    return TextFormField(
      controller: _namaController,
      decoration: const InputDecoration(labelText: "Nama Petugas"),
      validator: (value) => value!.isEmpty ? "Nama tidak boleh kosong" : null,
    );
  }

  Widget _buildJabatanField() {
    return TextFormField(
      controller: _jabatanController,
      decoration: const InputDecoration(labelText: "Jabatan"),
      validator:
          (value) => value!.isEmpty ? "Jabatan tidak boleh kosong" : null,
    );
  }

  Widget _buildNoHpField() {
    return TextFormField(
      controller: _noHpController,
      decoration: const InputDecoration(labelText: "No HP"),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value!.isEmpty) return "No HP tidak boleh kosong";
        if (int.tryParse(value) == null) return "No HP harus berupa angka";
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return OutlinedButton(
      child: Text(_tombol),
      onPressed: () {
        if (_formKey.currentState!.validate() && !_isLoading) {
          widget.petugas != null ? _ubah() : _simpan();
        }
      },
    );
  }

  Future<void> _simpan() async {
    setState(() => _isLoading = true);

    final response = await http.post(
      Uri.parse(
        'https://bc1c6696-936f-4f45-b6fa-92a5cf7633fb.mock.pstmn.io/petugas',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "namaPetugas": _namaController.text,
        "jabatan": _jabatanController.text,
        "noHp": int.parse(_noHpController.text),
      }),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Berhasil menambahkan')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PetugasPage()),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (_) => const WarningDialog(
              description: "Simpan gagal, silakan coba lagi.",
            ),
      );
    }
  }

  Future<void> _ubah() async {
    setState(() => _isLoading = true);

    final response = await http.put(
      Uri.parse(
        'https://bc1c6696-936f-4f45-b6fa-92a5cf7633fb.mock.pstmn.io/petugas/${widget.petugas!.id}',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "namaPetugas": _namaController.text,
        "jabatan": _jabatanController.text,
        "noHp": int.parse(_noHpController.text),
      }),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Berhasil mengubah')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PetugasPage()),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (_) => const WarningDialog(
              description: "Ubah gagal, silakan coba lagi.",
            ),
      );
    }
  }
}
