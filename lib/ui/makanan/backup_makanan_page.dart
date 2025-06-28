import 'package:flutter/material.dart';
import 'package:catering_flutter/bloc/logout.dart';
import 'package:catering_flutter/model/makanan.dart';
import 'package:catering_flutter/ui/login_page.dart';
import 'package:catering_flutter/ui/minuman/minuman_page.dart';
import 'package:catering_flutter/ui/petugas/petugas_page.dart';
import 'package:catering_flutter/ui/makanan/makanan_detail.dart';
import 'package:catering_flutter/ui/makanan/makanan_form.dart';

class MakananPage extends StatefulWidget {
  const MakananPage({Key? key}) : super(key: key);

  @override
  _MakananPageState createState() => _MakananPageState();
}

class _MakananPageState extends State<MakananPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MakananForm()),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.fastfood),
              title: Text('Makanan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MakananPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.local_drink),
              title: Text('Minuman'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MinumanPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Petugas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PetugasPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await LogoutBloc.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          ItemMakanan(
            makanan: Makanan(
              id: 1,
              kodeMakanan: 'A001',
              namaMakanan: 'Kamera',
              hargaMakanan: 5000000,
            ),
          ),
          ItemMakanan(
            makanan: Makanan(
              id: 2,
              kodeMakanan: 'A002',
              namaMakanan: 'Kulkas',
              hargaMakanan: 2500000,
            ),
          ),
          ItemMakanan(
            makanan: Makanan(
              id: 3,
              kodeMakanan: 'A003',
              namaMakanan: 'Mesin Cuci',
              hargaMakanan: 2000000,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemMakanan extends StatelessWidget {
  final Makanan makanan;

  const ItemMakanan({Key? key, required this.makanan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MakananDetail(makanan: makanan),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(makanan.namaMakanan ?? ''),
          subtitle: Text(makanan.hargaMakanan.toString()),
        ),
      ),
    );
  }
}
