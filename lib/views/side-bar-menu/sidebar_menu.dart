
import 'package:flutter/material.dart';
import '../../core/models/kullanici_model.dart';
import '../authentication/kullanici_giris.dart';
import 'kisisel_bilgiler.dart';

class DrawerMenu extends StatelessWidget {
  final Kullanici? kullanici;

  DrawerMenu({this.kullanici});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: Text(
                'DİJİTAL GÜVENLİK',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 26,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white70, // Alt kısım rengi (beyaz)
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person, size: 35,),
                  title: Text('Kişisel Bilgiler', style: TextStyle(fontSize: 23)),
                  onTap: () {
                    // Burada bir Kullanici nesnesi oluşturmalısınız. Örneğin:
                    /*Kullanici kullanici = Kullanici(
                      id: "1",
                      ad: "Örnek Ad",
                      soyad: "Örnek Soyad",
                      email: "ornek@mail.com",
                      sifre: "*****",
                      skor: 0,
                    );
*/


                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => KisiselBilgilerSayfasi(kullanici: kullanici)),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.exit_to_app, size: 35,),
                  title: Text('Çıkış', style: TextStyle(fontSize: 23)),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => KullaniciGiris()));
                  },
                ),
                // Diğer menü elemanları buraya eklenebilir
              ],
            ),
          ),
        ],
      ),
    );
  }
}
