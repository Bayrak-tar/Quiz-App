
import 'package:flutter/material.dart';
import 'package:mobil_final_odevi/views/admin-pages/test_ekle.dart';
import '../../core/services/adim_service.dart';
import '../scenarios/icerik1_phishing.dart';
import '../scenarios/icerik2_bilgisayartarihçesi.dart';
import 'main.dart';

class Seviye2Sayfasi extends StatelessWidget {
  const Seviye2Sayfasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
            "Seviye 2",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, letterSpacing: 1),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,size: 37,),
            onPressed: () {
              // Geri tuşuna basıldığında AnaMenu sayfasına gitmek için
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AnaMenu()), // AnaMenu sayfasını oluşturur
                    (Route<dynamic> route) => false, // Tüm geçmiş sayfaları kapatır
              );
            },
          ),
        ),
        body:
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red, Colors.black],
            ),
          ),

          child: Stack(
            children: [ Seviye2Icerik(),],

          ),
        ),
      ),);
  }
}

class Seviye2Icerik extends StatelessWidget {
  /*final List<String> daireVerileri = [
    'Adım 1',
    'Adım 2',

  ];*/

  // Eklenen sayfaları burada tanımlayın
  final List<Widget> sayfalar = [
    Phishing(),
    ImageCarouselSlider(),// Örnek bir sayfa, gerçek sayfalarınıza uygun olarak değiştirin
    Phishing(),
    ImageCarouselSlider(),
    Phishing(),
    ImageCarouselSlider(),
  ];

  Future<List<Map<String, dynamic>>> _getAdimList() async {
    try {
      return await AdimService().getAdimIDListByLevelId(1);
    } catch (e) {
      print("Adımları alma sırasında bir hata oluştu: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getAdimList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Hata: ${snapshot.error}");
        } else {
          List<Map<String, dynamic>> adimList = snapshot.data ?? [];
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                for (int i = 0; i < adimList.length; i++)
                  i == 0
                      ? Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Column(
                      children: [
                        DaireAdim(adim: adimList[i]['title'].toString(), onPressed: () => _navigateToPage(context, i)),
                        BaglantiCizgisi(),
                      ],
                    ),
                  )
                      : Column(
                    children: [
                      DaireAdim(adim: adimList[i]['title'].toString(), onPressed: () => _navigateToPage(context, i)),
                      BaglantiCizgisi(),
                    ],
                  ),
              ],
            ),
          );
        }
      },
    );
  }

  // Yeni sayfaya yönlendiren fonksiyon
  void _navigateToPage(BuildContext context, int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => sayfalar[index]));
  }
}

class DaireAdim extends StatefulWidget {
  final String adim;
  final VoidCallback onPressed;

  const DaireAdim({required this.adim, required this.onPressed});

  @override
  _DaireAdimState createState() => _DaireAdimState();
}

class _DaireAdimState extends State<DaireAdim> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      child: InkWell(
        onTap: () {
          setState(() {
            isTapped = !isTapped;
          });

          if (isTapped) {
            widget.onPressed(); // Yeni sayfaya yönlendirme fonksiyonunu çağır
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 107,
              height: 107,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: isTapped
                    ? Icon(
                  Icons.lock_open,
                  size: 45,
                  color: Colors.black,
                )
                    : Icon(
                  Icons.lock,
                  size: 45,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class BaglantiCizgisi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 45,
      color: Colors.white,
    );
  }
}
