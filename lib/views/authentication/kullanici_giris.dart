import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/models/kullanici_model.dart';
import '../../core/services/auth_user_service.dart';
import '../../firebase_options.dart';
import '../side-bar-menu/kisisel_bilgiler.dart';
import 'admin_giris.dart';
import 'kayit_sayfasi.dart';
import '../user-pages/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';//firestoreda veri kontrolü için

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(KullaniciGiris());
}

class KullaniciGiris extends StatelessWidget {
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

  final AuthenticationUserService _authUserService = AuthenticationUserService();

  Future<void> girisYap(String kullaniciAdi, String sifre) async {
    try {
      String? kullaniciId = await _authUserService.signInUser(
        email: kullaniciAdi,
        password: sifre,
      );
      print("DEBUG - kullaniciId: $kullaniciId"); // Debug amaçlı yazdırma
      if (kullaniciId != null) {
        // Firestore'dan kullanıcı bilgilerini al
        DocumentSnapshot kullaniciSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(kullaniciId).get();
        print("DEBUG - kullaniciSnapshot: ${kullaniciSnapshot.data()}");

        if (kullaniciSnapshot.exists) {
          Kullanici kullanici = Kullanici.fromMap(kullaniciSnapshot.data() as Map<String, dynamic>);

          // Kullanıcı oturumunu başlat
          await AuthenticationUserService.startSession(kullaniciId);

          // currentUserUid'yi güncelle
          setState(() {
            AuthenticationUserService.currentUserUid = kullaniciId;
          });

          print("DEBUG - currentUserUid: ${AuthenticationUserService.currentUserUid}");

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KisiselBilgilerSayfasi(kullanici: kullanici)),
          );
        } else {
          // Kullanıcı Firestore'da bulunamadı
          showAlertDialog(context, "Hata", "Kullanıcı bilgileri alınamadı.");
        }
      }
    } catch (e) {
      showAlertDialog(context, "Hata", "Giriş işlemi sırasında bir hata oluştu: $e");
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
                child: Icon(Icons.person, size: 90, color: Colors.white60,),
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
                      hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
                      hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KayitOlSayfasi()),
                  );
                },
                child: Text(
                  'Kayıt Ol',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
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
            // Giriş Yap sayfası zaten mevcut sayfa olduğu için burada bir şey yapmaya gerek yok.
              break;
            case 1:
            // Şifremi Unuttum sayfasına geçiş
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AdminGiris()));
              break;
          // Ekstra sayfa geçişleri buraya ekleyebilirsiniz
            default:
              break;
          }
        },
        selectedItemColor: Colors.black, // Seçili ikon rengi
        unselectedItemColor: Colors.red, // Seçili ikon rengi
        selectedLabelStyle: TextStyle(color: Colors.red), // Seçili label rengi
        unselectedLabelStyle: TextStyle(color: Colors.black), // Seçili olmayan label rengi
      ),
    );
  }
} 