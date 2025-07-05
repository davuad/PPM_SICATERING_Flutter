import 'package:flutter/material.dart';
import 'package:catering_flutter/bloc/login_blok.dart';
import 'package:catering_flutter/helpers/user_info.dart';
import 'package:catering_flutter/ui/makanan/makanan_page.dart';
import 'package:catering_flutter/ui/registrasi_page.dart';
import 'package:catering_flutter/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  label: "Email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email harus diisi';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: "Password",
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password harus diisi";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Login"),
                    ),
                const SizedBox(height: 30),
                _buildRegisterMenu(),
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
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        validator: validator,
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    LoginBloc.login(
          email: _emailController.text,
          password: _passwordController.text,
        )
        .then((value) async {
          await UserInfo().setToken(value.token.toString());
          await UserInfo().setUserID(int.parse(value.userID.toString()));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MakananPage()),
          );
        })
        .catchError((error) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => WarningDialog(
                  description: error.toString(),
                  okClick: () => Navigator.pop(context, '/login'),
                ),
          );
        })
        .whenComplete(() {
          setState(() => _isLoading = false);
        });
  }

  Widget _buildRegisterMenu() {
    return Center(
      child: InkWell(
        child: const Text(
          "Belum punya akun? Registrasi",
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }
}
