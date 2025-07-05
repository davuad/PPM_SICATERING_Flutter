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

   simpan() {
    setState(() {
      _isLoading = true;
    });

    Makanan createMakanan = Makanan(id: null);
    createMakanan.kodeMakanan = _kodeMakananTextboxController.text;
    createMakanan.namaMakanan = _namaMakananTextboxController.text;
    createMakanan.hargaMakanan = int.parse(_hargaMakananTextboxController.text);

    MakananBlok.addMakanan(makanan: createMakanan)
        .then(
          (value) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const MakananPage(),
              ),
            );
          },
          onError: (error) {
            showDialog(
              context: context,
              builder:
                  (BuildContext context) => const WarningDialog(
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

    Makanan updateMakanan = Makanan(id: null);
    updateMakanan.id = widget.makanan!.id;
    updateMakanan.kodeMakanan = _kodeMakananTextboxController.text;
    updateMakanan.namaMakanan = _namaMakananTextboxController.text;
    updateMakanan.hargaMakanan = int.parse(_hargaMakananTextboxController.text);

    MakananBlok.updateMakanan(makanan: updateMakanan).then(
      (value) {
        setState(() {
          _isLoading = false;
        });

        if (value) {
          showDialog(
            context: context,
            builder:
                (BuildContext context) => AlertDialog(
                  title: const Text("Berhasil"),
                  content: const Text("Data berhasil diubah."),
                  actions: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop(); // Tutup dialog
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder:
                                (BuildContext context) => const MakananPage(),
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
            builder:
                (BuildContext context) => const WarningDialog(
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
          builder:
              (BuildContext context) => const WarningDialog(
                description: "Permintaan ubah data gagal, silahkan coba lagi",
              ),
        );
      },
    );
  }
}
