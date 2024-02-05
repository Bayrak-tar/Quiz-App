import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobil_final_odevi/core/services/senaryo_metni_service.dart';
import '../user-pages/seviye1.dart';

class Phishing extends StatefulWidget {
  const Phishing({Key? key}) : super(key: key);

  @override
  State<Phishing> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<Phishing> {
  bool showSenaryo = true;
  Map<String, dynamic>? senaryoMetni1;

  @override
  void initState() {
    super.initState();
    _senaryoMetniniGetir();
    // 5 saniye sonra senaryo yazısını kapat
    Timer(Duration(seconds: 3), () {
      setState(() {
        showSenaryo = false;
      });
    });
  }

  Future<void> _senaryoMetniniGetir() async {
    try {
      senaryoMetni1 = await SenaryoMetniService().senaryoMetniGetir(1, 1); //senaryoId=1,senaryoNo=1 olanı getir.
      setState(() {});
    } catch (e) {
      print("Hata: $e");
      // Hata durumunda bir işlem yapabilirsiniz.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showSenaryo)
              Text(
                "SENARYO OLUŞTURULUYOR..",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (!showSenaryo) ...[
              Container(
                width: 350,
                child: Text(
                  senaryoMetni1?['scenarioText'] ?? "",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Icerik1Sayfasi()),
                  );
                },
                child: Text("Devam >>"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class Icerik1Sayfasi extends StatefulWidget {
  const Icerik1Sayfasi({Key? key}) : super(key: key);

  @override
  State<Icerik1Sayfasi> createState() => _Icerik1SayfasiState();
}

class _Icerik1SayfasiState extends State<Icerik1Sayfasi> {
  bool showWarning = false;
  late Timer timer;
  Map<String, dynamic>? senaryoMetni2;
  Map<String, dynamic>? senaryoMetni3;

  @override
  void initState() {
    super.initState();
    _senaryoMetinleriniGetir();
    // 12 saniye sonra geç butonunu aktive et
    timer = Timer(Duration(seconds: 12), () {
      setState(() {
        showWarning = true;
      });
    });
  }

  Future<void> _senaryoMetinleriniGetir() async {
    try {
      senaryoMetni2 = await SenaryoMetniService().senaryoMetniGetir(1, 2);
      senaryoMetni3 = await SenaryoMetniService().senaryoMetniGetir(1, 3);
      setState(() {});
    } catch (e) {
      print("Hata: $e");
      // Hata durumunda bir işlem yapabilirsiniz.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "DİJİTAL GÜVENLİK",
          style: TextStyle(fontSize: 23),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.red, Colors.black],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity, // Genişliği tamamen kapla
                  child: Card(
                    color: Colors.blue,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (senaryoMetni2 != null)
                              Text(
                                senaryoMetni2?['scenarioText'] ?? "",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),

                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Bilgilendirme"),
                                    content: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (senaryoMetni3 != null)
                                          Text(
                                            senaryoMetni3?['scenarioText'] ?? "",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                _showLevelCompletedAlert();
                                              },
                                              child: Text("Anladım"),
                                            ),
                                            SizedBox(width: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Anlamadım"),
                                            ),
                                            SizedBox(width: 10),
                                            InkWell(
                                              onTap: () {
                                                // Kalp butonuna tıklama işlemleri buraya eklenir
                                                print("Kalp butonuna tıklandı!");
                                              },
                                              child: Icon(
                                                Icons.favorite_border,
                                                size: 29,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text("Linkten Güncelle"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (showWarning)
                  ElevatedButton(
                    onPressed: () {
                      _showLevelCompletedAlert();
                    },
                    child: Text("Geç"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLevelCompletedAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Seviye Tamamlandı"),
          content: Text("Tebrikler! Seviye başarıyla tamamlandı."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Seviye1Sayfasi()), // AnaMenu sayfasını oluşturur
                      (Route<dynamic> route) => false, // Tüm geçmiş sayfaları kapatır
                );
              },
              child: Text("Tamam"),
            ),
          ],
        );
      },
    );
  }
}



