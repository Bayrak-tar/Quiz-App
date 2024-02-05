class Seviye {
  String? id;
  String seviyeAdi;

  Seviye({this.id, required this.seviyeAdi});

  // Seviye sınıfını Map'e dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'levelName': seviyeAdi,
    };
  }

  // Map'i Seviye sınıfına dönüştürme
  Seviye.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        seviyeAdi = map['levelName'];
}