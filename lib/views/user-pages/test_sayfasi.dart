import 'package:flutter/material.dart';
import 'package:mobil_final_odevi/core/models/soru_model.dart';
import 'package:mobil_final_odevi/core/models/test_model.dart';
import 'package:mobil_final_odevi/views/inter-connections/bottom_navigation_bar.dart';
import 'package:mobil_final_odevi/views/side-bar-menu/sidebar_menu.dart';
import 'package:mobil_final_odevi/views/user-pages/main.dart';

import '../../core/models/kullanici_model.dart';
import '../../core/services/test_service.dart';

class KullaniciTestSayfasi extends StatefulWidget {
  final Kullanici? kullanici;
  KullaniciTestSayfasi({this.kullanici});
  @override
  _KullaniciTestSayfasiState createState() => _KullaniciTestSayfasiState();
}

class _KullaniciTestSayfasiState extends State<KullaniciTestSayfasi> {
  List<Test> tests = [];
  int _selectedIndex = 1; // Başlangıçta seçili olan index

  @override
  void initState() {
    super.initState();
    _getTests();
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "Test Sayfası",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, letterSpacing: 1),
        ),
        centerTitle: true,
      ),

      drawer: DrawerMenu(),

      body: tests.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _buildTestSecimEkrani(),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Sayfa değişim işlemleri buraya gelecek
          switch (index) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AnaMenu()));
              break;
            case 1:
            // Zaten bu sayfadayız, bir şey yapmaya gerek yok.
              break;
            default:
              break;
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTestSecimEkrani() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (Test test in tests) _buildTestButton(test),
        ],
      ),
    );
  }

  Widget _buildTestButton(Test test) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestCozumSayfasi(test: test),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        onPrimary: Colors.white,
      ),
      child: Text(test.testBaslik ,style: TextStyle(fontSize: 17),),
    );
  }
}

class TestCozumSayfasi extends StatefulWidget {
  final Test test;

  TestCozumSayfasi({required this.test});

  @override
  _TestCozumSayfasiState createState() => _TestCozumSayfasiState();
}

class _TestCozumSayfasiState extends State<TestCozumSayfasi> {
  List<Soru> sorular = [];
  Map<String?, String?> kullaniciCevaplar = {};

  @override
  void initState() {
    super.initState();
    _getTestSorulari();
  }

  Future<void> _getTestSorulari() async {
    try {
      List<Soru> fetchedSorular = await FirebaseService().getSorularByTestId(
          widget.test.id);
      setState(() {
        sorular = fetchedSorular;
      });
    } catch (e) {
      print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.test.testBaslik),
        backgroundColor: Colors.red,
      ),
      body: sorular.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _buildTestCozumEkrani(),
    );
  }

  Widget _buildTestCozumEkrani() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < sorular.length; i++) _buildSoruCard(
              sorular[i], i + 1),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _sonucEkraniGoster();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
            ),
            child: Text('Testi Bitir'),
          ),
        ],
      ),
    );
  }

  Widget _buildSoruCard(Soru soru, int soruNo) {
    return Card(
      color: Colors.red,
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Soru $soruNo:',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              soru.soruMetni,
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            for (int i = 0; i < soru.secenekler.length; i++)
              RadioListTile<String?>(
                title: Text(
                  soru.secenekler[i],
                  style: TextStyle(color: Colors.white),
                ),
                value: i.toString(),
                groupValue: kullaniciCevaplar['$soruNo'],
                // her soru için ayrı bir değişken kullan
                onChanged: (value) {
                  setState(() {
                    kullaniciCevaplar['$soruNo'] =
                        value; // value değişkenini int tipine dönüştür
                    // seçilen değeri güncelle
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  void _sonucEkraniGoster() {
    int toplamPuan = 0;
    int dogruSayisi = 0;
    int yanlisSayisi = 0;

    for (Soru soru in sorular) {
      String? kullaniciCevap = kullaniciCevaplar[soru.id];
      String dogruCevapIndex = soru.dogruCevap;

      if (kullaniciCevap == dogruCevapIndex) {
        toplamPuan += soru.puan;
        dogruSayisi++;
      } else {
        yanlisSayisi++;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Test Sonucu'),
          content: Column(
            children: [
              Text('Toplam Puan: $toplamPuan'),
              Text('Doğru Sayısı: $dogruSayisi'),
              Text('Yanlış Sayısı: $yanlisSayisi'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                //Navigator.of(context).pop();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => KullaniciTestSayfasi()));
              },
              child: Text('Kapat'),
            ),
          ],
        );
      },
    );
  }
}

Widget buildFloatingActionButton(IconData icon, String text, Function onTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Center(
        child: Container(
          height: 80,
          width: 330,
          child: FloatingActionButton.extended(
            onPressed: () => onTap(),
            icon: Row(
              children: [
                Icon(icon, size: 30,),
                SizedBox(width: 12),
              ],
            ),
            label: Text(text, style: TextStyle(fontSize: 30)),
            backgroundColor: Colors.black,
          ),
        ),
      ),
    ),
  );
}
