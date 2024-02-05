import 'package:flutter/material.dart';
import 'package:mobil_final_odevi/views/admin-pages/test_ekle.dart';
import 'package:mobil_final_odevi/views/admin-pages/test_sil.dart';

import '../authentication/admin_giris.dart';

class AdminPanelSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "Admin Panel",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, letterSpacing: 1),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 37,),
          onPressed: () {
            // Geri tuşuna basıldığında AnaMenu sayfasına gitmek için
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => AdminGiris()), // AnaMenu sayfasını oluşturur
                  (Route<dynamic> route) => false, // Tüm geçmiş sayfaları kapatır
            );
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestSilSayfasi(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              child: Text('Test Sil'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestEkle(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              child: Text('Test Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AdminPanelSayfasi(),
  ));
}