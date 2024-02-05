import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/senaryoMetni_model.dart';


class SenaryoMetniService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _scenarioTextCollection = FirebaseFirestore.instance.collection('scenarioText');
  Future<void> createSenaryoMetni(SenaryoMetni senaryoMetni) async {
    try {
      await _firestore.collection('scenarioText').add(senaryoMetni.toMap());
    } catch (e) {
      print("Senaryo metni oluşturulurken hata oluştu: $e");
    }
  }

  Future<SenaryoMetni?> getSenaryoMetni(String senaryoMetniID) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('scenarioText').doc(senaryoMetniID).get();

      if (doc.exists) {
        SenaryoMetni senaryoMetni = SenaryoMetni.fromMap(doc.data() as Map<String, dynamic>);
        return senaryoMetni;
      } else {
        return null;
      }
    } catch (e) {
      print("Senaryo metni alınırken hata oluştu: $e");
      return null;
    }
  }

  Future<void> updateSenaryoMetni(SenaryoMetni senaryoMetni) async {
    try {
      await _firestore.collection('scenarioText').doc(senaryoMetni.id).update(senaryoMetni.toMap());
    } catch (e) {
      print("Senaryo metni güncellenirken hata oluştu: $e");
    }
  }

  Future<void> deleteSenaryoMetni(String senaryoMetniID) async {
    try {
      await _firestore.collection('scenarioText').doc(senaryoMetniID).delete();
    } catch (e) {
      print("Senaryo metni silinirken hata oluştu: $e");
    }
  }

  Future<Map<String, dynamic>> senaryoMetniGetir(int scenarioId, int queue) async {
    try {
      DocumentSnapshot scenarioDoc = await _scenarioTextCollection
          .where('scenarioId', isEqualTo: scenarioId)
          .where('queue', isEqualTo: queue)
          .get()
          .then((QuerySnapshot querySnapshot) {
        return querySnapshot.docs.first;
      });

      return scenarioDoc.data() as Map<String, dynamic>;
    } catch (e) {
      print("Senaryo metni getirme sırasında bir hata oluştu: $e");
      throw e;
    }
  }
}
