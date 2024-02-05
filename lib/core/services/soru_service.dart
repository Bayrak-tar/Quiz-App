import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobil_final_odevi/core/models/soru_model.dart';


class SoruService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createSoru(Soru soru) async {
    try {
      // Soru koleksiyonuna ekle
      await _firestore.collection('questions').add({
        'questionText': soru.soruMetni,
        'options': soru.secenekler,
        'point': soru.puan,
        'correctAnswer': soru.dogruCevap,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Soru?> getSoru(String soruID) async {
    try {
      // Soru koleksiyonundan soruyu al
      DocumentSnapshot soruDoc = await _firestore.collection('questions').doc(soruID).get();

      if (soruDoc.exists) {
        // Soru sınıfını oluştur
        Soru soru = Soru.fromMap({
          'id': soruDoc.id,
          'questionText': soruDoc['questionText'],
          'options': (soruDoc['options'] as List<dynamic>).cast<String>(),
          'point': soruDoc['point'],
          'correctAnswer': soruDoc['correctAnswer'],
        });

        return soru;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> updateSoru(Soru soru) async {
    try {
      await _firestore.collection('questions').doc(soru.id).update({
        'questionText': soru.soruMetni,
        'options': soru.secenekler,
        'point': soru.puan,
        'correctAnswer': soru.dogruCevap,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteSoru(String soruID) async {
    try {
      await _firestore.collection('questions').doc(soruID).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}