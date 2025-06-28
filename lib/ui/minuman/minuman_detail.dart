import 'package:flutter/material.dart';
import 'package:catering_flutter/model/minuman.dart';
import 'package:catering_flutter/ui/minuman/minuman_form.dart';
import 'package:catering_flutter/ui/minuman/minuman_page.dart';
import 'package:catering_flutter/bloc/minuman_blok.dart';
import 'package:catering_flutter/widget/warning_dialog.dart';

class MinumanDetail extends StatefulWidget {
  final Minuman? minuman;

  const MinumanDetail({Key? key, this.minuman}) : super(key: key);

  @override
  _MinumanDetailState createState() => _MinumanDetailState();
}

class _MinumanDetailState extends State<MinumanDetail> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Minuman')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kode : ${widget.minuman!.kodeMinuman}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              "Nama : ${widget.minuman!.namaMinuman}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Harga : Rp. ${widget.minuman!.hargaMinuman}",
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
                builder: (context) => MinumanForm(minuman: widget.minuman!),
              ),
            ).then((_) => setState(() {})); // Refresh
          },
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () async {
            Navigator.pop(context); // Tutup dialog
            await hapusMinuman();
          },
        ),
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }

  Future<void> hapusMinuman() async {
    setState(() {
      _isDeleting = true;
    });

    bool success = await MinumanBlok.deleteMinuman(widget.minuman!.id!);

    setState(() {
      _isDeleting = false;
    });

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MinumanPage()));
    } else {
      showDialog(
        context: context,
        builder:
            (_) => const WarningDialog(
              description: "Hapus gagal, silakan coba lagi",
            ),
      );
    }
  }
}
