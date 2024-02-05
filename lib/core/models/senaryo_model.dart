
import 'package:mobil_final_odevi/core/models/senaryoMetni_model.dart';


class Senaryo {
  int? id;
  SenaryoMetni? senaryoMetniId; // SenaryoMetni sınıfının referansı

  Senaryo({this.id, required this.senaryoMetniId});

  // Senaryo sınıfını Map'e dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scenarioTextId': senaryoMetniId?.toMap(), // SenaryoMetni sınıfını Map'e dönüştürme
    };
  }

  // Map'i Senaryo sınıfına dönüştürme
  Senaryo.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        senaryoMetniId = SenaryoMetni.fromMap(map['scenarioId']);
}