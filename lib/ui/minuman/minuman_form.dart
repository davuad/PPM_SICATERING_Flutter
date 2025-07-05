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
        _kodeMinumanTextboxController.text = widget.minuman!.kodeMinuman!;
        _namaMinumanTextboxController.text = widget.minuman!.namaMinuman!;
        _hargaMinumanTextboxController.text =
            widget.minuman!.hargaMinuman.toString();
      });
    } else {
      judul = "TAMBAH MINUMAN";
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
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.minuman != null) {
              ubah();
            } else {
              simpan();
            }
          }
        }
      },
    );
  }

  simpan() {
    setState(() {
      _isLoading = true;
    });

    Minuman createMinuman = Minuman(id: null);
    createMinuman.kodeMinuman = _kodeMinumanTextboxController.text;
    createMinuman.namaMinuman = _namaMinumanTextboxController.text;
    createMinuman.hargaMinuman =
        int.parse(_hargaMinumanTextboxController.text);

    MinumanBlok.addMinuman(minuman: createMinuman)
        .then(
          (value) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const MinumanPage(),
              ),
            );
          },
          onError: (error) {
            showDialog(
              context: context,
              builder: (BuildContext context) => const WarningDialog(
                description: "Simpan gagal, silahkan coba lagi",
              ),
            );
          },
        )
        .whenComplete(() {
          setState(() {
            _isLoading = false;
          });
        });
  }

  ubah() {
    setState(() {
      _isLoading = true;
    });

    Minuman updateMinuman = Minuman(id: null);
    updateMinuman.id = widget.minuman!.id;
    updateMinuman.kodeMinuman = _kodeMinumanTextboxController.text;
    updateMinuman.namaMinuman = _namaMinumanTextboxController.text;
    updateMinuman.hargaMinuman =
        int.parse(_hargaMinumanTextboxController.text);

    MinumanBlok.updateMinuman(minuman: updateMinuman).then(
      (value) {
        setState(() {
          _isLoading = false;
        });

        if (value) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Berhasil"),
              content: const Text("Data berhasil diubah."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup dialog
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const MinumanPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => const WarningDialog(
              description: "Permintaan ubah data gagal, silahkan coba lagi",
            ),
          );
        }
      },
      onError: (error) {
        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Permintaan ubah data gagal, silahkan coba lagi",
          ),
        );
      },
    );
  }
}
