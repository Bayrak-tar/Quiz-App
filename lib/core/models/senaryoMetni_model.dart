class SenaryoMetni {
  String? id;
  String metin;
  int sira;
  String senaryoId; // Yeni eklenen alan

  SenaryoMetni({this.id, required this.metin, required this.sira, required this.senaryoId});

  // SenaryoMetni sınıfını Map'e dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scenarioText': metin,
      'queue': sira,
      'scenarioId': senaryoId, // Yeni eklenen alanı da ekle
    };
  }

  // Map'i SenaryoMetni sınıfına dönüştürme
  SenaryoMetni.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        metin = map['scenarioText'],
        sira = map['queue'],
        senaryoId = map['scenarioId']; // Yeni eklenen alanı da al
}
