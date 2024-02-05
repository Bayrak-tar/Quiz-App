class Admin {
  String? id;
  String ad;
  String soyad;
  String email;
  String sifre;

  Admin({this.id, required this.ad, required this.soyad, required this.email, required this.sifre});

  // Admin sınıfını Map'e dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': ad,
      'surname': soyad,
      'email': email,
      'password': sifre,
    };
  }

  // Map'i Admin sınıfına dönüştürme
  Admin.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        ad = map['name'],
        soyad = map['surname'],
        email = map['email'],
        sifre = map['password'];
}