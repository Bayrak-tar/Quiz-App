class Kullanici {
  String? id;
  String ad;
  String soyad;
  String email;
  String sifre;
  int skor;

  Kullanici({this.id, required this.ad, required this.soyad, required this.email, required this.sifre, required this.skor});

  // Kullanici sınıfını Map'e dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': ad,
      'surname': soyad,
      'email': email,
      'password': sifre,
      'score': skor,
    };
  }

  // Map'i Kullanici sınıfına dönüştürme
  Kullanici.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        ad = map['name'],
        soyad = map['surname'],
        email = map['email'],
        sifre = map['password'],
        skor = map['score'];
}