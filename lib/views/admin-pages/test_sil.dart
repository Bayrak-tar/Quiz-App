import 'package:flutter/material.dart';
import 'package:mobil_final_odevi/core/models/test_model.dart';
import '../../core/services/test_service.dart';
import 'admin_panel.dart';

class TestSilSayfasi extends StatefulWidget {
  @override
  _TestSilSayfasiState createState() => _TestSilSayfasiState();
}

class _TestSilSayfasiState extends State<TestSilSayfasi> {
  List<Test> tests = []; // Test verilerini içeren liste

  @override
  void initState() {
    super.initState();
    _getTests(); // Test verilerini al
  }

  Future<void> _getTests() async {
    try {
      List<Test> fetchedTests = await FirebaseService().getTests();
      setState(() {
        tests = fetchedTests;
      });
    } catch (e) {
      print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "Test Silme Sayfası",
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
      backgroundColor: Colors.black, // Sayfanın arka plan rengi
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Silmek istediğiniz testi seçin:',
              style: TextStyle(fontSize: 18.0, color: Colors.white), // Metin rengi
            ),
            SizedBox(height: 16.0),
            for (Test test in tests) _buildTestButton(test),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(Test test) {
    return ElevatedButton(
      onPressed: () {
        _showSilAlertDialog(context, test);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        onPrimary: Colors.white,
      ),
      child: Text(test.testBaslik),
    );
  }

  Future<void> _showSilAlertDialog(BuildContext context, Test test) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Testi Sil'),
          content: Text('\'${test.testBaslik}\' testini silmek istediğinizden emin misiniz?', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () async {
                await _silmeIslemi(test);
                Navigator.pop(context); // AlertDialog'ı kapat
              },
              child: Text('Evet, Sil', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // AlertDialog'ı kapat
              },
              child: Text('Hayır, İptal', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _silmeIslemi(Test test) async {
    try {
      await FirebaseService().deleteTest(test.id);
      setState(() {
        tests.remove(test); // Testi listeden kaldır
      });
    } catch (e) {
      print('Hata: $e');
    }
  }
}