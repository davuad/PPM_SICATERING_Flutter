import 'package:flutter/material.dart';
import 'package:catering_flutter/bloc/logout.dart';
import 'package:catering_flutter/model/petugas.dart';
import 'package:catering_flutter/ui/login_page.dart';
import 'package:catering_flutter/ui/minuman/minuman_page.dart';
import 'package:catering_flutter/ui/makanan/makanan_page.dart';
import 'package:catering_flutter/ui/petugas/petugas_detail.dart';
import 'package:catering_flutter/ui/petugas/petugas_form.dart';
import 'package:catering_flutter/bloc/petugas_blok.dart';

class PetugasPage extends StatefulWidget {
  const PetugasPage({Key? key}) : super(key: key);

  @override
  _PetugasPageState createState() => _PetugasPageState();
}

class _PetugasPageState extends State<PetugasPage> {
  late Future<List<Petugas>> futurePetugas;

  @override
  void initState() {
    super.initState();
    futurePetugas = PetugasBlok.getPetugas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Petugas'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PetugasForm()),
                ).then((value) {
                  setState(() {
                    futurePetugas = PetugasBlok.getPetugas();
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
                  MaterialPageRoute(builder: (_) => const MakananPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_drink),
              title: const Text('Minuman'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MinumanPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Petugas'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PetugasPage()),
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
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Petugas>>(
        future: futurePetugas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data petugas.'));
          } else {
            List<Petugas> petugasList = snapshot.data!;
            return ListView.builder(
              itemCount: petugasList.length,
              itemBuilder: (context, index) {
                return ItemPetugas(petugas: petugasList[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class ItemPetugas extends StatelessWidget {
  final Petugas petugas;

  const ItemPetugas({Key? key, required this.petugas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PetugasDetail(petugas: petugas)),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(petugas.namaPetugas ?? ''),
          subtitle: Text(
            'Jabatan: ${petugas.jabatan ?? ''} - No HP: ${petugas.noHp}',
          ),
        ),
      ),
    );
  }
}
