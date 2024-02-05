import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../user-pages/seviye1.dart';

class ImageCarouselSlider extends StatefulWidget {
  @override
  _ImageCarouselSliderState createState() => _ImageCarouselSliderState();
}

class _ImageCarouselSliderState extends State<ImageCarouselSlider> {
  List<String> resimler = [
    "abakus.jpg",
    "pascal.jpeg",
    "farkmotoru.jpg",
    "deliklikart.jpg",
    "mark1.jpg",
    "z3.jpeg",
    "eniac.jpg",
    "altair.jpg"
  ];

  int currentIndex = 0;
  bool sliderDevamEdiyor = true;

  Future<String> _getImageUrl(String imageName) async {
    try {
      final Reference storageReference =
      FirebaseStorage.instance.ref().child("$imageName");
      final String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error: $e");
      return ""; // Hata durumunda boş bir string döner
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300.0,
            enlargeCenterPage: true,
            autoPlay: sliderDevamEdiyor,
            autoPlayInterval: Duration(seconds: 5),
            aspectRatio: 16 / 9,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          items: resimler.map((resim) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: FutureBuilder<String>(
                    future: _getImageUrl(resim),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text('Hata: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Image.network(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Text('Bilinmeyen bir hata oluştu.');
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: resimler.map((resim) {
            int index = resimler.indexOf(resim);
            return Container(
              width: 10.0,
              height: 10.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                currentIndex == index ? Colors.redAccent : Colors.grey,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Navigate to Seviye1Sayfasi when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Seviye1Sayfasi()),
            );
          },
          child: Text("Anladım"),
        ),
      ],
    );
  }
}

class Icerik2_BilgisayarTarihcesi extends StatelessWidget {
  const Icerik2_BilgisayarTarihcesi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
            "Bilgisayar Tarihçesi",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red, Colors.black],
            ),
          ),
          child: ImageCarouselSlider(),
        ),
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: Icerik2_BilgisayarTarihcesi(),
  ));
}