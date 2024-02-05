
import 'package:flutter/material.dart';
import '../../core/models/kullanici_model.dart';
import '../inter-connections/app_bar.dart';
import '../inter-connections/bottom_navigation_bar.dart';
import '../side-bar-menu/sidebar_menu.dart';
import 'test_sayfasi.dart';
import 'seviye1.dart';
import 'seviye2.dart';
import 'seviye3.dart';

class AnaMenu extends StatefulWidget {
  final Kullanici? kullanici;
  AnaMenu({this.kullanici});

  @override
  _AnaMenuState createState() => _AnaMenuState();
}

class _AnaMenuState extends State<AnaMenu> {
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: buildAppBar(context),
      ),

      drawer: DrawerMenu(kullanici: widget.kullanici),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red, Colors.black],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(17),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white60,
                    child: Icon(Icons.person,size:40,color: Colors.white70,),
                  ),
                  SizedBox(width: 10),
                  Text(
                     "Merhaba ${widget.kullanici?.ad ?? 'Melisa'}!",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.fromLTRB(17, 0, 17, 0),
              padding: const EdgeInsets.all(15),
              child: Text(
                "Güvenlik zayıf halka gibidir, en zayıf halkayı güçlendirmeden sisteminiz güvende değildir.",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black),
              ),
            ),
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    buildFloatingActionButton(Icons.star, 'SEVİYE 1', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Seviye1Sayfasi()));
                    }),
                    buildFloatingActionButton(Icons.star, 'SEVİYE 2', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Seviye2Sayfasi()));
                    }),
                    buildFloatingActionButton(Icons.star, 'SEVİYE 3', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Seviye3Sayfasi()));
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Sayfa değişim işlemleri buraya gelecek
          switch (index) {
            case 0:
            // AnaMenu zaten mevcut sayfa olduğu için burada bir şey yapmaya gerek yok.
              break;
            case 1:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => KullaniciTestSayfasi()));
              break;
            default:
              break;
          }
        },
      ),
    );
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
}
