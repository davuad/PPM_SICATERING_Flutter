import 'package:catering_flutter/model/login.dart';
import 'package:catering_flutter/model/makanan.dart';
import 'package:catering_flutter/ui/makanan/makanan_page.dart';
import 'package:catering_flutter/ui/minuman/minuman_form.dart';
import 'package:catering_flutter/ui/minuman/minuman_page.dart';
import 'package:catering_flutter/ui/petugas/petugas_form.dart';
import 'package:catering_flutter/ui/petugas/petugas_page.dart';
import 'package:flutter/material.dart';
import 'package:catering_flutter/helpers/user_info.dart';
import 'package:catering_flutter/ui/login_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );

   @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    var token = await UserInfo().getToken();
    if (token != null) {
      setState(() {
        page = MakananPage();
      });
    } else {
      setState(() {
        page = PetugasPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SI Catering',
      debugShowCheckedModeBanner: false,
      home: page,
    );
  }
}
