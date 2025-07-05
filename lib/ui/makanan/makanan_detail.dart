import 'package:flutter/material.dart';
import 'package:catering_flutter/model/makanan.dart';
import 'package:catering_flutter/ui/makanan/makanan_form.dart';
import 'package:catering_flutter/ui/makanan/makanan_page.dart';
import 'package:catering_flutter/bloc/makanan_blok.dart';
import 'package:catering_flutter/widget/warning_dialog.dart';

class MakananDetail extends StatefulWidget {
  final Makanan? makanan;

  const MakananDetail({Key? key, this.makanan}) : super(key: key);

  @override
  _MakananDetailState createState() => _MakananDetailState();
}

class _MakananDetailState extends State<MakananDetail> {
  @override
  Widget build(BuildContext context) {
    if (widget.makanan == null) {
      return const Scaffold(body: Center(child: Text("Data tidak ditemukan.")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Makanan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kode : ${widget.makanan!.kodeMakanan}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              "Nama : ${widget.makanan!.namaMakanan}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Harga : Rp. ${widget.makanan!.hargaMakanan}",
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MakananForm(makanan: widget.makanan!),
              ),
            ).then((_) => setState(() {}));
          },
        ),
        const SizedBox(width: 10),
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
          (context) => AlertDialog(
            content: const Text("Yakin ingin menghapus data ini?"),
            actions: [
              OutlinedButton(
                child: const Text("Ya"),
                onPressed: () async {
                  Navigator.pop(context);
                  await _hapusMakanan();
                },
              ),
              OutlinedButton(
                child: const Text("Batal"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  Future<void> _hapusMakanan() async {
    final success = await MakananBlok.deleteMakanan(id: widget.makanan!.id!);

    if (success) {
      showDialog(
        context: context,
        builder:
            (BuildContext context) => AlertDialog(
              title: const Text("Berhasil"),
              content: const Text("Makanan berhasil dihapus."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const MakananPage(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (context) => const WarningDialog(
              description: "Gagal menghapus makanan, silakan coba lagi.",
            ),
      );
    }
  }
}
