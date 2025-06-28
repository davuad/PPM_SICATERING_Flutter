import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:catering_flutter/bloc/makanan_blok.dart';
import 'package:catering_flutter/model/makanan.dart';
import 'package:catering_flutter/ui/makanan/makanan_page.dart';
import 'package:catering_flutter/widget/warning_dialog.dart';
import 'package:http/http.dart' as http;

class MakananForm extends StatefulWidget {
  Makanan ? makanan;

  MakananForm({Key? key, this.makanan}) : super(key: key);

  @override
  _MakananFormState createState() => _MakananFormState();
}

class _MakananFormState extends State<MakananForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH MAKANAN";
  String tombolSubmit = "SIMPAN";

   final _kodeMakananTextboxController = TextEditingController();
  final _namaMakananTextboxController = TextEditingController();
  final _hargaMakananTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.makanan != null) {
      setState(() {
        judul = "UBAH Makanan";
        tombolSubmit = "UBAH";
        _kodeMakananTextboxController.text = widget.makanan!.kodeMakanan!;
        _namaMakananTextboxController.text = widget.makanan!.namaMakanan!;
        _hargaMakananTextboxController.text =
            widget.makanan!.hargaMakanan.toString();
      });
    }else {
      judul = "TAMBAH MAKANAN";
      tombolSubmit = "SIMPAN";
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeMakananTextField(),
                _namaMakananTextField(),
                _hargaMakananTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

   Widget _kodeMakananTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Kode Makanan"),
      keyboardType: TextInputType.text,
      controller: _kodeMakananTextboxController,
      validator: (value) {
        if (value!.isEmpty) { 
          return "Kode Makanan harus diisi";
        }
        return null;
      },
    );
  }

  Widget _namaMakananTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Makanan"),
      keyboardType: TextInputType.text,
      controller: _namaMakananTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Makanan harus diisi";
        }
        return null;
      },
    );
  }

  Widget _hargaMakananTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga"),
      keyboardType: TextInputType.number,
      controller: _hargaMakananTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Harga harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.makanan != null) {
              ubah();
            } else {
              simpan();
            }
          }
        }
      },
    );
  }

  simpan() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse(
        'https://bc1c6696-936f-4f45-b6fa-92a5cf7633fb.mock.pstmn.io/makanan',
      ), // GANTI dengan URL mock kamu
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "kodeMakanan": _kodeMakananTextboxController.text,
        "namaMakanan": _namaMakananTextboxController.text,
        "hargaMakanan": int.parse(_hargaMakananTextboxController.text),
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Berhasil menambahkan')),
      );
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MakananPage()));
    } else {
      showDialog(
        context: context,
        builder:
            (_) => const WarningDialog(
              description: "Simpan gagal, silahkan coba lagi",
            ),
      );
    }
  }

  ubah() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.put(
      Uri.parse(
        'https://bc1c6696-936f-4f45-b6fa-92a5cf7633fb.mock.pstmn.io/makanan/${widget.makanan!.id}',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "kode_makanan": _kodeMakananTextboxController.text,
        "nama_makanan": _namaMakananTextboxController.text,
        "harga": int.parse(_hargaMakananTextboxController.text),
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Berhasil mengubah')),
      );
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MakananPage()));
    } else {
      showDialog(
        context: context,
        builder:
            (_) => const WarningDialog(
              description: "Ubah gagal, silahkan coba lagi",
            ),
      );
    }
  }
}
