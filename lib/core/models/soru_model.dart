import 'package:cloud_firestore/cloud_firestore.dart';

class Soru {
  String id;
  String testId;
  String soruMetni;
  List<String> secenekler;
  int puan;
  String dogruCevap;

  Soru({
    required this.id,
    required this.testId,
    required this.soruMetni,
    required this.secenekler,
    required this.puan,
    required this.dogruCevap,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'soruMetni': soruMetni,
      'secenekler': secenekler,
      'puan': puan,
      'dogruCevap': dogruCevap,
      'soruId': id,
    };
  }

  factory Soru.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Soru(
      id: doc.id,
      testId: data['testId'] ?? '',
      soruMetni: data['soruMetni'] ?? '',
      secenekler: List<String>.from(data['secenekler'] ?? []),
      puan: data['puan'] ?? 0,
      dogruCevap: data['dogruCevap'] ?? '',
    );
  }

  factory Soru.fromMap(Map<String, dynamic> map) {
    return Soru(
      id: map['id'] ?? '',
      testId: map['testId'] ?? '',
      soruMetni: map['soruMetni'] ?? '',
      secenekler: List<String>.from(map['secenekler'] ?? []),
      puan: map['puan'] ?? 0,
      dogruCevap: map['dogruCevap'] ?? '',
    );
  }
}