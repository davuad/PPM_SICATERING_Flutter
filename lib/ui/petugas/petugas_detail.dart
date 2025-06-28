import 'package:flutter/material.dart';
import 'package:catering_flutter/model/petugas.dart';
import 'package:catering_flutter/ui/petugas/petugas_form.dart';
import 'package:catering_flutter/ui/petugas/petugas_page.dart';
import 'package:catering_flutter/bloc/petugas_blok.dart';
import 'package:catering_flutter/widget/warning_dialog.dart';

class PetugasDetail extends StatefulWidget {
  final Petugas petugas;

  const PetugasDetail({Key? key, required this.petugas}) : super(key: key);

  @override
  _PetugasDetailState createState() => _PetugasDetailState();
}

class _PetugasDetailState extends State<PetugasDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Petugas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nama: ${widget.petugas.namaPetugas ?? '-'}",
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 8),
            Text(
              "Jabatan: ${widget.petugas.jabatan ?? '-'}",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8),
            Text(
              "No HP: ${widget.petugas.noHp}",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PetugasForm(petugas: widget.petugas),
              ),
            );
          },
        ),
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => _confirmHapus(),
        ),
      ],
    );
  }

  void _confirmHapus() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Konfirmasi"),
            content: const Text("Yakin ingin menghapus data ini?"),
            actions: [
              TextButton(
                child: const Text("Ya"),
                onPressed: () async {
                  Navigator.pop(context); // Tutup dialog
                  await _hapus();
                },
              ),
              TextButton(
                child: const Text("Batal"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  Future<void> _hapus() async {
    bool success = await PetugasBlok.deletePetugas(widget.petugas.id!);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PetugasPage()),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (_) => const WarningDialog(description: "Gagal menghapus data"),
      );
    }
  }
}
