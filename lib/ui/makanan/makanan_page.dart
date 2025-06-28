import 'package:flutter/material.dart';
import 'package:catering_flutter/bloc/logout.dart';
import 'package:catering_flutter/model/makanan.dart';
import 'package:catering_flutter/ui/login_page.dart';
import 'package:catering_flutter/ui/minuman/minuman_page.dart';
import 'package:catering_flutter/ui/petugas/petugas_page.dart';
import 'package:catering_flutter/ui/makanan/makanan_detail.dart';
import 'package:catering_flutter/ui/makanan/makanan_form.dart';
import 'package:catering_flutter/bloc/makanan_blok.dart';

class MakananPage extends StatefulWidget {
  const MakananPage({Key? key}) : super(key: key);

  @override
  _MakananPageState createState() => _MakananPageState();
}

class _MakananPageState extends State<MakananPage> {
  late Future<List<Makanan>> futureMakanan;

  @override
  void initState() {
    super.initState();
    futureMakanan = MakananBlok.getMakanan(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Makanan'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MakananForm()),
                ).then((value) {
                  // Refresh data setelah kembali dari form
                  setState(() {
                    futureMakanan = MakananBlok.getMakanan();
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MinumanPage()),
                );
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
      body: FutureBuilder<List<Makanan>>(
        future: futureMakanan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data makanan.'));
          } else {
            List<Makanan> makanans = snapshot.data!;
            return ListView.builder(
              itemCount: makanans.length,
              itemBuilder: (context, index) {
                return ItemMakanan(makanan: makanans[index]);
              },
            );
          }
        },
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
          subtitle: Text('Harga: Rp${makanan.hargaMakanan}'),
        ),
      ),
    );
  }
}
