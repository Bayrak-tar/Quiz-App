
import 'package:flutter/material.dart';
import '../../core/services/auth_user_service.dart';
import '../../core/services/kullanici_service.dart';
import 'kullanici_giris.dart';


class KayitOlSayfasi extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController adController = TextEditingController();
  final TextEditingController soyadController = TextEditingController();
  final TextEditingController sifreController = TextEditingController();
  final TextEditingController sifreTekrarController = TextEditingController();

  final AuthenticationUserService _authService = AuthenticationUserService();
  final KullaniciService _kullaniciService=KullaniciService();
  Future<void> kayitOl(
      BuildContext context, String email, String ad, String soyad, String sifre) async {
    try {
      if (sifre != sifreTekrarController.text) {
        showAlertDialog(context, "Hata", "Şifreler uyuşmuyor.");
        return;
      }

      String? uid = await _authService.signUpUser(
        email: email,
        password: sifre,
        ad: ad,
        soyad: soyad,
      );

      if (uid != null) {
        // Kayıt başarılıysa, giriş sayfasına yönlendir
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => KullaniciGiris()),
        );
      }
    } catch (e) {
     // showAlertDialog(context, "Hata", "Kayıt işlemi sırasında bir hata oluştu: $e");
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Kayıt Ol',
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTextField('E-mail:', emailController),
                SizedBox(height: 17.0),
                buildTextField('Ad:', adController),
                SizedBox(height: 17.0),
                buildTextField('Soyad:', soyadController),
                SizedBox(height: 17.0),
                buildTextField('Şifre:', sifreController),
                SizedBox(height: 17.0),
                buildTextField('Şifre Tekrar:', sifreTekrarController),
                SizedBox(height: 17.0),
                ElevatedButton(
                  onPressed: () {
                    String email = emailController.text;
                    String ad = adController.text;
                    String soyad = soyadController.text;
                    String sifre = sifreController.text;

                    kayitOl(context, email, ad, soyad, sifre);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    minimumSize: Size(100.0, 50.0),
                  ),
                  child: Text('Kayıt Ol', style: TextStyle(fontSize: 21)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 300.0,
        height: 50.0,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
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
    );
  }
}