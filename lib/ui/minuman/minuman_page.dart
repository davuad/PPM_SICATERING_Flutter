import 'package:flutter/material.dart';
import 'package:catering_flutter/bloc/logout.dart';
import 'package:catering_flutter/model/minuman.dart';
import 'package:catering_flutter/ui/login_page.dart';
import 'package:catering_flutter/ui/minuman/minuman_form.dart';
import 'package:catering_flutter/ui/minuman/minuman_detail.dart';
import 'package:catering_flutter/ui/petugas/petugas_page.dart';
import 'package:catering_flutter/ui/makanan/makanan_page.dart';
import 'package:catering_flutter/bloc/minuman_blok.dart';

class MinumanPage extends StatefulWidget {
  const MinumanPage({Key? key}) : super(key: key);

  @override
  _MinumanPageState createState() => _MinumanPageState();
}

class _MinumanPageState extends State<MinumanPage> {
  late Future<List<Minuman>> futureMinuman;

  @override
  void initState() {
    super.initState();
    futureMinuman = MinumanBlok.getMinuman();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Minuman'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MinumanForm()),
                ).then((value) {
                  setState(() {
                    futureMinuman = MinumanBlok.getMinuman();
                  });
                });
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.fastfood),
              title: const Text('Makanan'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MakananPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_drink),
              title: const Text('Minuman'),
              onTap: () {
                Navigator.pop(context); // Sudah di halaman minuman
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Petugas'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PetugasPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
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
      body: FutureBuilder<List<Minuman>>(
        future: futureMinuman,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data minuman.'));
          } else {
            List<Minuman> minumans = snapshot.data!;
            return ListView.builder(
              itemCount: minumans.length,
              itemBuilder: (context, index) {
                return ItemMinuman(minuman: minumans[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class ItemMinuman extends StatelessWidget {
  final Minuman minuman;

  const ItemMinuman({Key? key, required this.minuman}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MinumanDetail(minuman: minuman),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(minuman.namaMinuman ?? ''),
          subtitle: Text('Harga: Rp${minuman.hargaMinuman}'),
        ),
      ),
    );
  }
}
