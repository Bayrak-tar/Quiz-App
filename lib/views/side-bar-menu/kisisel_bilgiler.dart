
import 'package:flutter/material.dart';
import 'package:mobil_final_odevi/views/side-bar-menu/sifre_guncelleme_sayfasi.dart';
import '../../core/models/kullanici_model.dart';
import '../user-pages/main.dart';

class KisiselBilgilerSayfasi extends StatelessWidget {
  final Kullanici? kullanici;

  KisiselBilgilerSayfasi({this.kullanici});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kişisel Bilgiler', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.black45,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 30,),
          onPressed: () {
            // Geri tuşuna basıldığında AnaMenu sayfasına gitmek için
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => AnaMenu(kullanici: kullanici)), // AnaMenu sayfasını oluşturur
                  (Route<dynamic> route) => false, // Tüm geçmiş sayfaları kapatır
            );
          },
        ),
      ),
      body: Container(
        color: Colors.black26, // Arka plan rengi
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: CircleAvatar(
                radius: 70.0,
                backgroundColor: Colors.white, // CircleAvatar'ın arka plan rengi
                child: Icon(
                  Icons.person,
                  size: 90,
                  color: Colors.black,
                ),
              ),
            ),
            if (kullanici != null) // Kontrol ekleyin
              ListTile(
                title: Text('Email: ${kullanici!.email }', style: TextStyle(fontSize: 24)),
              ),
            if (kullanici != null)
              ListTile(
                title: Text("Adı: ${kullanici!.ad }", style: TextStyle(fontSize: 24)),
              ),
            if (kullanici != null)
              ListTile(
                title: Text('Soyadı: ${kullanici!.soyad}', style: TextStyle(fontSize: 24)),
              ),
            ListTile(
              title: Text('Şifre: ***', style: TextStyle(fontSize: 24)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Şifre güncelleme sayfasına gitmek için
                Navigator.push(context, MaterialPageRoute(builder: (context) => SifreGuncellemeSayfasi(kullanici: kullanici)));

                },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Düğmenin arka plan rengi
              ),
              child: Text('Şifre Güncelle', style: TextStyle(fontSize: 22),),
            ),
          ],
        ),
      ),
    );
  }
}
