import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/adim_model.dart';

class AdimService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createAdim(Adim adim) async {
    try {
      // Adim koleksiyonuna ekle
      DocumentReference adimRef = await _firestore.collection('steps').add({
        'title': adim.baslik,
        'levelId': adim.seviye,
      });

    } catch (e) {
      print(e.toString());
    }
  }

  Future<Adim?> getAdim(String adimID) async {
    try {
      // Adim koleksiyonundan adımı al
      DocumentSnapshot adimDoc = await _firestore.collection('steps').doc(adimID).get();

      if (adimDoc.exists) {
        // Adim sınıfını oluştur
        Adim adim = Adim.fromMap({
          'id': adimDoc.id,
          'baslik': adimDoc['title'],
          'seviye': adimDoc['levelId'],
        });

        return adim;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAdimIDListByLevelId(int levelId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection('steps').where('levelId', isEqualTo: levelId).get();

      int documentCount = querySnapshot.docs.length;
      print('Bulunan belge sayısı: $documentCount');

      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Adım ID'lerini alma sırasında bir hata oluştu: $e");
      return [];
    }
  }


  Future<void> updateAdim(Adim adim) async {
    try {
      await _firestore.collection('steps').doc(adim.id).update({
        'title': adim.baslik,
        'levelId': adim.seviye,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteAdim(String adimID) async {
    try {
      await _firestore.collection('steps').doc(adimID).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
