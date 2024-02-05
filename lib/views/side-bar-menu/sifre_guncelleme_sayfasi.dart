import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/models/kullanici_model.dart';
import '../../core/services/auth_user_service.dart';


class SifreGuncellemeSayfasi extends StatefulWidget {
  final Kullanici? kullanici;
  SifreGuncellemeSayfasi({this.kullanici});
  @override
  _SifreGuncellemeSayfasiState createState() => _SifreGuncellemeSayfasiState();
}

class _SifreGuncellemeSayfasiState extends State<SifreGuncellemeSayfasi> {
  final TextEditingController _eskiSifreController = TextEditingController();
  final TextEditingController _yeniSifreController = TextEditingController();
  final TextEditingController _yeniSifreTekrarController = TextEditingController();
  final AuthenticationUserService _authService = AuthenticationUserService(); // AuthenticationService sınıfını oluşturun


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Şifre Güncelleme', style: TextStyle(fontSize: 24),),
        backgroundColor: Colors.black45,
      ),
      body: Container(
        color: Colors.black26,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _eskiSifreController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Eski şifre'),
            ),
            TextFormField(
              controller: _yeniSifreController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Yeni Şifre'),
            ),
            TextFormField(
              controller: _yeniSifreTekrarController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Yeni Şifre (Tekrar)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Check if new passwords match
                if (_yeniSifreController.text != _yeniSifreTekrarController.text) {
                  Fluttertoast.showToast(
                    msg: "Yeni şifreler eşleşmiyor",
                    toastLength: Toast.LENGTH_LONG,
                  );
                  return;
                }

                String? result = await _authService.updatePassword1(
                  oldPassword: _eskiSifreController.text,
                  newPassword: _yeniSifreController.text,
                  userId: widget.kullanici?.id ?? '',
                );

                if (result == null) {
                  Fluttertoast.showToast(
                    msg: "Şifre güncelleme başarılı",
                    toastLength: Toast.LENGTH_SHORT,
                  );
                  //Navigator.pop(context); // Sayfayı kapat
                } else {
                  Fluttertoast.showToast(
                    msg: result,
                    toastLength: Toast.LENGTH_LONG,
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Text('Güncelle', style: TextStyle(fontSize: 22),),
            ),
          ],
        ),
      ),
    );
  }
}