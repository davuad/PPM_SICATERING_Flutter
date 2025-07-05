import 'package:flutter/material.dart';
import 'package:catering_flutter/bloc/registrasi_blok.dart';
import 'package:catering_flutter/widget/success_dialog.dart';
import 'package:catering_flutter/widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  label: "Nama",
                  controller: _namaController,
                  validator: (value) {
                    if (value == null || value.trim().length < 3) {
                      return "Nama harus diisi minimal 3 karakter";
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: "Email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email harus diisi';
                    }
                    final regex = RegExp(
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                    );
                    if (!regex.hasMatch(value)) {
                      return "Email tidak valid";
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: "Password",
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Password harus diisi minimal 6 karakter";
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: "Konfirmasi Password",
                  controller: _konfirmasiController,
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return "Konfirmasi password tidak sama";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Registrasi"),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    RegistrasiBloc.registrasi(
          nama: _namaController.text,
          email: _emailController.text,
          password: _passwordController.text,
        )
        .then((value) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => SuccessDialog(
                  description: "Registrasi berhasil, silahkan login",
                  okClick: () => Navigator.pop(context, '/login'),
                ),
          );
        })
        .catchError((error) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => WarningDialog(
                  description:
                      error
                          .toString(), // bisa kasih pesan error detail dari API
                  okClick: () => Navigator.pop(context, '/registrasi'),
                ),
          );
        })
        .whenComplete(() {
          setState(() => _isLoading = false);
        });
  }
}
