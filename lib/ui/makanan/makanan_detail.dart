import 'package:flutter/material.dart';
import 'package:catering_flutter/model/makanan.dart';
import 'package:catering_flutter/ui/makanan/makanan_form.dart';
import 'package:catering_flutter/ui/makanan/makanan_page.dart';
import 'package:catering_flutter/bloc/makanan_blok.dart';
import 'package:catering_flutter/widget/warning_dialog.dart';

class MakananDetail extends StatefulWidget {
  Makanan? makanan;

  MakananDetail({Key? key, this.makanan}) : super(key: key);

  @override
  _MakananDetailState createState() => _MakananDetailState();
}

class _MakananDetailState extends State<MakananDetail> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
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
            ).then((_) => setState(() {})); // Refresh setelah edit
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
            await hapusMakanan();
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

  Future<void> hapusMakanan() async {
    setState(() {
      _isDeleting = true;
    });

    bool success = await MakananBlok.deleteMakanan(widget.makanan!.id!);

    setState(() {
      _isDeleting = false;
    });

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MakananPage()));
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
