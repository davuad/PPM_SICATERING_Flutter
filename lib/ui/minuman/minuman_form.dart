import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:catering_flutter/bloc/minuman_blok.dart';
import 'package:catering_flutter/model/minuman.dart';
import 'package:catering_flutter/ui/minuman/minuman_page.dart';
import 'package:catering_flutter/widget/warning_dialog.dart';
import 'package:http/http.dart' as http;

class MinumanForm extends StatefulWidget {
  Minuman? minuman;

  MinumanForm({Key? key, this.minuman}) : super(key: key);

  @override
  _MinumanFormState createState() => _MinumanFormState();
}

class _MinumanFormState extends State<MinumanForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH MINUMAN";
  String tombolSubmit = "SIMPAN";

  final _kodeMinumanTextboxController = TextEditingController();
  final _namaMinumanTextboxController = TextEditingController();
  final _hargaMinumanTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.minuman != null) {
      setState(() {
        judul = "UBAH MINUMAN";
        tombolSubmit = "UBAH";
        _kodeMinumanTextboxController.text = widget.minuman!.kodeMinuman ?? '';
        _namaMinumanTextboxController.text = widget.minuman!.namaMinuman ?? '';
        _hargaMinumanTextboxController.text =
            widget.minuman!.hargaMinuman.toString();
      });
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
                _kodeMinumanTextField(),
                _namaMinumanTextField(),
                _hargaMinumanTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kodeMinumanTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Kode Minuman"),
      keyboardType: TextInputType.text,
      controller: _kodeMinumanTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Kode Minuman harus diisi";
        }
        return null;
      },
    );
  }

  Widget _namaMinumanTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Minuman"),
      keyboardType: TextInputType.text,
      controller: _namaMinumanTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Minuman harus diisi";
        }
        return null;
      },
    );
  }

  Widget _hargaMinumanTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga"),
      keyboardType: TextInputType.number,
      controller: _hargaMinumanTextboxController,
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
        if (_formKey.currentState!.validate() && !_isLoading) {
          if (widget.minuman != null) {
            ubah();
          } else {
            simpan();
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
        'https://bc1c6696-936f-4f45-b6fa-92a5cf7633fb.mock.pstmn.io/minuman',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "kodeMinuman": _kodeMinumanTextboxController.text,
        "namaMinuman": _namaMinumanTextboxController.text,
        "hargaMinuman": int.parse(_hargaMinumanTextboxController.text),
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
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MinumanPage()));
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
        'https://bc1c6696-936f-4f45-b6fa-92a5cf7633fb.mock.pstmn.io/minuman/${widget.minuman!.id}',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "kode_minuman": _kodeMinumanTextboxController.text,
        "nama_minuman": _namaMinumanTextboxController.text,
        "harga": int.parse(_hargaMinumanTextboxController.text),
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
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MinumanPage()));
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
