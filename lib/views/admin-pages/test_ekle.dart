import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobil_final_odevi/core/models/soru_model.dart';
import 'package:mobil_final_odevi/core/models/test_model.dart';
import '../../core/services/test_service.dart';
import '../inter-connections/app_bar.dart';
import 'admin_panel.dart';

class TestEkle extends StatefulWidget {
  @override
  _TestEkleState createState() => _TestEkleState();
}

class _TestEkleState extends State<TestEkle> {
  TextEditingController testBaslikController = TextEditingController();
  List<Soru> sorular = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "Test Ekleme Sayfasi",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, letterSpacing: 1),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 37,),
          onPressed: () {
            // Geri tuşuna basıldığında AnaMenu sayfasına gitmek için
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => AdminPanelSayfasi()), // AnaMenu sayfasını oluşturur
                  (Route<dynamic> route) => false, // Tüm geçmiş sayfaları kapatır
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: testBaslikController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Test Başlığı',
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _soruEkleDialog(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              child: Text('Soru Ekle'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _testiKaydet();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              child: Text('Testi Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  void _soruEkleDialog(BuildContext context) {
    String soruMetni = "";
    List<String> secenekler = List.generate(4, (index) => "");
    int puan = 0;
    String dogruCevap = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Soru Ekle'),
            content: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Soru Metni'),
                  onChanged: (value) {
                    soruMetni = value;
                  },
                ),
                SizedBox(height: 16.0),
                for (int i = 0; i < 4; i++)
                  TextField(
                    decoration: InputDecoration(labelText: 'Şık ${i + 1}'),
                    onChanged: (value) {
                      secenekler[i] = value;
                    },
                  ),
                SizedBox(height: 16.0),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Puan'),
                  onChanged: (value) {
                    puan = int.tryParse(value) ?? 0;
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(labelText: 'Doğru Cevap'),
                  onChanged: (value) {
                    dogruCevap = value;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('İptal'),
              ),
              TextButton(
                onPressed: () {
                  Soru yeniSoru = Soru(
                    soruMetni: soruMetni,
                    secenekler: secenekler,
                    puan: puan,
                    dogruCevap: dogruCevap,
                    id: '', testId: '',
                  );
                  setState(() {
                    sorular.add(yeniSoru);
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Ekle'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _testiKaydet() {
    String testTitle = testBaslikController.text.trim();
    if (testTitle.isNotEmpty && sorular.isNotEmpty) {
      Test test = Test(testBaslik: testTitle, sorular: sorular);
      FirebaseService().createTest(test).then((_) {
        _showMessage('Test başarıyla kaydedildi!');
      }).catchError((error) {
        _showMessage('Hata oluştu: $error');
      });
    } else {
      _showMessage('Test başlığı veya sorular boş olamaz.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}