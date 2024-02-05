import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobil_final_odevi/core/models/soru_model.dart';
import 'package:mobil_final_odevi/core/models/test_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createTest(Test test) async {
    try {
      DocumentReference testRef = await _firestore.collection('tests').add({
        'testTitle': test.testBaslik,
      });

      for (Soru soru in test.sorular) {
        await _firestore.collection('questions').add({
          'testId': testRef.id,
          'soruMetni': soru.soruMetni,
          'secenekler': soru.secenekler,
          'puan': soru.puan,
          'dogruCevap': soru.dogruCevap,
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Test>> getTests() async {
    try {
      QuerySnapshot testDocs = await _firestore.collection('tests').get();
      List<Test> testList = [];

      for (QueryDocumentSnapshot testDoc in testDocs.docs) {
        String testId = testDoc.id;
        String testTitle = testDoc['testTitle'];

        QuerySnapshot questionDocs = await _firestore
            .collection('questions')
            .where('testId', isEqualTo: testId)
            .get();

        List<Map<String, dynamic>> sorular =
        (questionDocs.docs.map((doc) => doc.data() as Map<String, dynamic>)).toList();

        List<Soru> soruListesi =
        sorular.map((soru) => Soru.fromMap(soru)).toList();

        Test test = Test.fromMap({
          'id': testId,
          'testTitle': testTitle,
        });

        test.sorular = soruListesi;
        testList.add(test);
      }

      return testList;
    } catch (e) {
      print('Hata: $e');
      return [];
    }
  }

  Future<List<Soru>> getSorularByTestId(String testId) async {
    try {
      QuerySnapshot soruDocs = await _firestore
          .collection('questions')
          .where('testId', isEqualTo: testId)
          .get();

      if (soruDocs.docs.isNotEmpty) {
        List<Soru> soruListesi = soruDocs.docs
            .map((soruDoc) => Soru.fromMap(soruDoc.data() as Map<String, dynamic>))
            .toList();

        return soruListesi;
      } else {
        print('Hata: Teste ait soru bulunamadı.');
        return [];
      }
    } catch (e) {
      print('Hata: $e');
      return [];
    }
  }

  Future<void> deleteTest(String testID) async {
    try {
      // Test koleksiyonundan sil
      await _firestore.collection('tests').doc(testID).delete();

      // Test altındaki soruları sil
      QuerySnapshot questionDocs = await _firestore.collection('questions').where('testId', isEqualTo: testID).get();
      for (QueryDocumentSnapshot questionDoc in questionDocs.docs) {
        await questionDoc.reference.delete();
      }
    } catch (e) {
      throw ('Hata: $e');
    }
  }
}