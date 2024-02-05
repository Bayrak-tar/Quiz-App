import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/kullanici_model.dart';

class KullaniciService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  Future createKullanici(Kullanici kullanici) async {
    try {
      String uid =Uuid().v4();
      DocumentReference userRef = _firestore
          .collection('users')
          .doc(uid); // Belge referansını kullanıcı kimliği ile oluştur

      await userRef.set(kullanici.toMap()); // Belgeyi veritabanına kaydet
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateKullanici(Kullanici kullanici) async {
    try {
      //SİZİN KOD ÇALIŞMAZSA BU İKİ KOD SATIRINI DENEYİN
      String uid = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(uid).update(kullanici.toMap());

      //await _firestore.collection('users').doc(kullanici.id).update(kullanici.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateKullanici1(Kullanici kullanici) async {
    try {
      // Kullanıcı ID'sini al
      String? userId = kullanici.id;

      // Kullanıcıyı güncelle
      await _firestore
          .collection('users')
          .where('id', isEqualTo: userId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Belgeyi bulduk, güncelleme işlemini yapabiliriz
          _firestore.collection('users').doc(userId).update(kullanici.toMap());
          print("Kullanıcı güncellendi");
        } else {
          print("Kullanıcı bulunamadı");
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }


  Future<void> deleteKullanici(String kullaniciID) async {
    try {
      await _firestore.collection('users').doc(kullaniciID).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Kullanici?> getKullanici(String kullaniciID) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(kullaniciID).get();

      if (doc.exists) {
        Kullanici kullanici = Kullanici.fromMap(doc.data() as Map<String, dynamic>);
        return kullanici;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future<Kullanici?> getKullaniciById(String kullaniciID) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('users')
          .where('id', isEqualTo: kullaniciID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        Kullanici kullanici = Kullanici.fromMap(doc.data() as Map<String, dynamic>);
        return kullanici;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }





}