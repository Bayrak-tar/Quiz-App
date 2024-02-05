import 'seviye_model.dart';

class Adim {
  String? id;
  String baslik;
  int seviye;

  Adim({this.id, required this.baslik, required this.seviye});

  // Adim sınıfını Map'e dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': baslik,
      'level': seviye
    };
  }

  // Map'i Adim sınıfına dönüştürme
  Adim.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        baslik = map['title'],
        seviye = map['level'] ;
}