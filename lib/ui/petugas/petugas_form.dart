import 'package:flutter/material.dart';
import 'package:catering_flutter/bloc/petugas_blok.dart';
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
  bool _isLoading = false;
  String judul = "TAMBAH PETUGAS";
  String tombolSubmit = "SIMPAN";

  final _namaController = TextEditingController();
  final _jabatanController = TextEditingController();
  final _no_hapeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.petugas != null) {
      setState(() {
        judul = "UBAH PETUGAS";
        tombolSubmit = "UBAH";
        _namaController.text = widget.petugas!.namaPetugas ?? '';
        _jabatanController.text = widget.petugas!.jabatan ?? '';
        _no_hapeController.text = widget.petugas!.no_hape.toString();
      });
    } else {
      judul = "TAMBAH PETUGAS";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildNamaField(),
                _buildJabatanField(),
                _buildno_hapeField(),
                _buttonSubmit(),
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
      validator: (value) => value!.isEmpty ? "Jabatan tidak boleh kosong" : null,
    );
  }

  Widget _buildno_hapeField() {
    return TextFormField(
      controller: _no_hapeController,
      decoration: const InputDecoration(labelText: "No HP"),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value!.isEmpty) return "No HP tidak boleh kosong";
        if (int.tryParse(value) == null) return "No HP harus berupa angka";
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
            widget.petugas != null ? _ubah() : _simpan();
          }
        }
      },
    );
  }

  void _simpan() {
    setState(() => _isLoading = true);

    Petugas createPetugas = Petugas(id: null);
    createPetugas.namaPetugas = _namaController.text;
    createPetugas.jabatan = _jabatanController.text;
    createPetugas.no_hape = int.parse(_no_hapeController.text);

    PetugasBlok.addPetugas(petugas: createPetugas).then(
      (value) {
        if (value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const PetugasPage()),
          );
        } else {
          showDialog(
            context: context,
            builder: (_) => const WarningDialog(
              description: "Simpan gagal, silakan coba lagi.",
            ),
          );
        }
      },
      onError: (error) {
        showDialog(
          context: context,
          builder: (_) => const WarningDialog(
            description: "Simpan gagal, silakan coba lagi.",
          ),
        );
      },
    ).whenComplete(() {
      setState(() => _isLoading = false);
    });
  }

  void _ubah() {
    setState(() => _isLoading = true);

    Petugas updatePetugas = Petugas(id: widget.petugas!.id);
    updatePetugas.namaPetugas = _namaController.text;
    updatePetugas.jabatan = _jabatanController.text;
    updatePetugas.no_hape = int.parse(_no_hapeController.text);

    PetugasBlok.updatePetugas(petugas: updatePetugas).then(
      (value) {
        if (value) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Berhasil"),
              content: const Text("Data berhasil diubah."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const PetugasPage(),
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
            builder: (_) => const WarningDialog(
              description: "Ubah gagal, silakan coba lagi.",
            ),
          );
        }
      },
      onError: (error) {
        showDialog(
          context: context,
          builder: (_) => const WarningDialog(
            description: "Ubah gagal, silakan coba lagi.",
          ),
        );
      },
    ).whenComplete(() {
      setState(() => _isLoading = false);
    });
  }
}
