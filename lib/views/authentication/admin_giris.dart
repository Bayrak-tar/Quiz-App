
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobil_final_odevi/views/admin-pages/admin_panel.dart';

import '../../core/services/auth_admin_service.dart';
import '../admin-pages/test_ekle.dart';
import 'kullanici_giris.dart';


class AdminGiris extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GirisSayfasi(),
    );
  }
}

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({Key? key}) : super(key: key);

  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  int _selectedIndex=1;
  TextEditingController kullaniciAdiController = TextEditingController();
  TextEditingController sifreController = TextEditingController();

  final AuthenticationAdminService _authAdminService = AuthenticationAdminService();

  Future<void> girisYap(String kullaniciAdi, String sifre) async {
    try {
      await _authAdminService.signInAdmin(kullaniciAdi, sifre);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminPanelSayfasi()),
      );
    } catch (e) {
      showAlertDialog(context, "Hata", "Kullanıcı adı veya şifre hatalı.");
    }
  }

  void showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              CircleAvatar(
                radius: 70.0,
                backgroundColor: Colors.white24,
                child:Icon(Icons.person, size: 90, color: Colors.white60,),
              ),
              SizedBox(height: 40.0),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 300.0,
                  height: 50.0,
                  child: TextField(
                    controller: kullaniciAdiController,
                    decoration: InputDecoration(
                      hintText: 'E-mail:',
                      hintStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 300.0,
                  height: 50.0,
                  child: TextField(
                    controller: sifreController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Şifre',
                      hintStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  String kullaniciAdi = kullaniciAdiController.text;
                  String sifre = sifreController.text;

                  girisYap(kullaniciAdi, sifre);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  minimumSize: Size(100.0, 50.0),
                ),
                child: Text(
                  'Giriş Yap',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person,),
              label: 'Kullanıcı Giriş',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lock),
              label: 'Admin Giriş',
            ),
            // Ekstra düğmeleri buraya ekleyebilirsiniz
          ],
          onTap: (index) {
            // Sayfa değişim işlemleri buraya gelecek
            switch (index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => KullaniciGiris()));
                break;
              case 1:
              // Şifremi Unuttum sayfasına geçiş

                break;
            // Ekstra sayfa geçişleri buraya ekleyebilirsiniz
              default:
                break;
            }
          },
        selectedItemColor: Colors.red, // Seçili ikon rengi
        unselectedItemColor: Colors.black, // Seçili ikon rengi
        selectedLabelStyle: TextStyle(color: Colors.red), // Seçili label rengi
        unselectedLabelStyle: TextStyle(color: Colors.black), // Seçili olmayan label rengi
      ),
    );
  }
}
