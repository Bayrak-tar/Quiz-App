import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../../Common/custom_error_message.dart';
import '../models/kullanici_model.dart';
import 'kullanici_service.dart';


class AuthenticationUserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final KullaniciService _kullaniciService = KullaniciService();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String? currentUserUid; // Kullanıcının UID'si

  // Kullanıcı oturumunu başlatır
  static Future<void> startSession(String uid) async {
    currentUserUid = uid;
  }

  // Kullanıcı oturum açtığında, currentUserUid'yi güncelle
  void CurrentUserUid() {
    currentUserUid = _auth.currentUser?.uid;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Oturum açma işlemi başarılı oldu, kullanıcı bilgileri userCredential içinde bulunabilir
      print("Kullanıcı oturum açtı: ${userCredential.user?.uid}");
    } catch (e) {
      // Oturum açma işlemi sırasında bir hata oluştu
      print("Oturum açma hatası: $e");
    }
  }

  // Kullanıcının uygulamaya kaydolmasını sağlar
  Future<String?> signUpUser({
    required String email,
    required String password,
    required String ad,
    required String soyad,
    File? profilePhoto,
  }) async {
    try {
      // email, ad, soyad ve password değerlerini boş olup olmadıklarını kontrol et
      if (email.isEmpty || ad.isEmpty || soyad.isEmpty || password.isEmpty) {
        Fluttertoast.showToast(
          msg: "Lütfen gerekli bilgileri giriniz!",
          toastLength: Toast.LENGTH_LONG,
        );
        return null;
      }

      // E-posta adresinin geçerli olup olmadığını kontrol et
      if (!EmailValidator.validate(email)) {
        Fluttertoast.showToast(
          msg: "Geçerli bir e-posta adresi giriniz!",
          toastLength: Toast.LENGTH_LONG,
        );
        return null;
      }

      // Firebase Firestore'da e-posta adresine göre sorgu yap
      QuerySnapshot<Map<String, dynamic>> existingUsers = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (existingUsers.docs.isNotEmpty) {
        // E-posta adresi zaten mevcut, kullanıcıya bilgi ver ve kaydetmeyi iptal et
        Fluttertoast.showToast(
          msg: "Bu e-posta adresi zaten kullanımda.",
          toastLength: Toast.LENGTH_LONG,
        );
        return null;
      }

      // Firebase Authentication kullanmadan doğrudan Firestore'a kayıt yap
      DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc();
      String uid = docRef.id;

      Kullanici kullanici = Kullanici(
        id: uid,
        ad: ad,
        soyad: soyad,
        email: email,
        sifre: password,
        skor: 0,
      );

      await _kullaniciService.createKullanici(kullanici);

      // Başarılı mesajı göster
      Fluttertoast.showToast(
        msg: "Kayıt işlemi başarılı",
      );

      return uid;
    } catch (e) {
      // Hata mesajını göster
      Fluttertoast.showToast(
        msg: "Uyarı: Kayıt işlemi sırasında bir hata oluştu.",
        toastLength: Toast.LENGTH_LONG,
      );
      return null;
    }
  }


  String _generateUid() {
    // Burada benzersiz bir kullanıcı kimliği oluşturabilirsiniz
    // Örneğin, rastgele bir UID oluşturabilirsiniz veya başka bir yöntem kullanabilirsiniz.
    // Örneğin: return Uuid().v4();
    // Bu örnekte, şu anlık sadece bir zaman damgası kullanıyoruz.
    return Uuid().v4();
  }

//-----------------------------------------------------------------------------------------

  Future<String?> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        Fluttertoast.showToast(
          msg: "Lütfen email adresinizi ve şifrenizi giriniz!",
          toastLength: Toast.LENGTH_LONG,
        );
        return null;
      }

      // Burada kullanıcıyı kontrol etme işlemlerini gerçekleştirin
      // Örneğin, Firestore'da kullanıcı verilerini kontrol edebilirsiniz.

      // Örnek olarak, Firestore'da "users" koleksiyonundan kullanıcıyı alın
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Kullanıcı bulundu, giriş işlemi başarılı
        Fluttertoast.showToast(
          msg: "Giriş işlemi başarılı",
          toastLength: Toast.LENGTH_SHORT,
        );

        // Firestore'da kullanıcı belgesinden UID'yi alabilirsiniz
        String uid = querySnapshot.docs.first.id;

        // Kullanıcı oturumunu başlat
        await startSession(uid);

        return uid;
      } else {
        // Kullanıcı bulunamadı, giriş işlemi başarısız
        Fluttertoast.showToast(
          msg: "Uyarı: Kullanıcı bulunamadı.",
          toastLength: Toast.LENGTH_LONG,
        );
        return null;
      }
    } catch (e) {
      // Hata mesajını göster
      Fluttertoast.showToast(
        msg: "Uyarı: Giriş işlemi sırasında bir hata oluştu.",
        toastLength: Toast.LENGTH_LONG,
      );
      return null;
    }
  }
//--------------------------------------------------------------------------------

// Kullanıcı oturumunu sonlandırır
  static Future<void> signOutUser() async {
    try {
      // Kullanıcı oturumu sonlandır
      currentUserUid = null;

      // Başarılı mesajı göster
      Fluttertoast.showToast(
        msg: "Çıkış işlemi başarılı",
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      // Hata mesajını göster
      Fluttertoast.showToast(
        msg: "Çıkış işlemi sırasında bir hata oluştu: $e",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
//--------------------------------------------------------------------------------------------
  // Kullanıcının şifresini sıfırlama isteği gönderir
  Future<void> resetPassword(String email) async {
    try {
      if (email.isEmpty) {
        Fluttertoast.showToast(
          msg: "Lütfen e-posta adresinizi giriniz!",
          toastLength: Toast.LENGTH_LONG,
        );
        return;
      }

      // Şifre sıfırlama isteğini işleme alın
      // Burada, kendi sunucunuzdaki kullanıcı veritabanını kontrol edebilirsiniz
      // ve kullanıcının e-posta adresine bir şifre sıfırlama bağlantısı gönderebilirsiniz.

      Fluttertoast.showToast(
        msg: "E-posta adresinize bir şifre sıfırlama isteği gönderildi",
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      // Hata mesajını göster
      Fluttertoast.showToast(
        msg: "Uyarı: Şifre sıfırlama işlemi sırasında bir hata oluştu.",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
//--------------------------------------------------------------------------------------------

  // Kullanıcının hesabını siler
  Future<void> deleteUser(String userId) async {
    try {
      // Kullanıcıyı kendi özel kimlik doğrulama sisteminizde silin
      // Burada, kullanıcıyı veritabanınızdan ve diğer ilgili yerlerden silebilirsiniz

      // Başarılı mesajı göster
      Fluttertoast.showToast(
        msg: "Kullanıcı hesabı başarıyla silindi.",
        toastLength: Toast.LENGTH_LONG,
      );

      // Çıkış yap ve gerekirse başka işlemleri gerçekleştir
      // (örneğin, kullanıcıyı silinen hesapla ilişkilendirilmiş verileri temizleme)
    } catch (e) {
      print("HATA: ${e.toString()}");
      // Hata mesajını göster
      Fluttertoast.showToast(
        msg: "Kullanıcı hesabını silerken bir hata oluştu.",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

//-------------------------------------------------------------------------------------------


  // Kullanıcının bilgilerini günceller
  Future<void> updateUserInformation({
    required String userId,
    required String newEmail,
    required String newPassword,
    required String newAd,
    required String newSoyad,
    File? profilePhoto,
  }) async {
    try {
      // Kullanıcının veritabanındaki mevcut bilgilerini al
      Kullanici? kullanici = await _kullaniciService.getKullanici(userId);

      if (kullanici != null) {
        // Kullanıcının veritabanındaki bilgilerini güncelle
        kullanici.email = newEmail;
        kullanici.sifre = newPassword;
        kullanici.ad = newAd;
        kullanici.soyad = newSoyad;

        // Eğer profıl fotoğrafı güncelleniyorsa, gerekli işlemleri gerçekleştir
        if (profilePhoto != null) {
          // Profil fotoğrafını kaydetme veya güncelleme işlemleri
          // Örnek: await _kullaniciService.updateProfilePhoto(userId, profilePhoto);
        }

        // Kullanıcının veritabanındaki bilgileri güncelle
        await _kullaniciService.updateKullanici(kullanici);

        // Başarılı mesajı göster
        Fluttertoast.showToast(
          msg: "Kullanıcı bilgileri başarıyla güncellendi.",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      // Hata mesajını göster
      Fluttertoast.showToast(
        msg: "Kullanıcı bilgilerini güncelleme işlemi sırasında bir hata oluştu.",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }//-------------------------------------------------------------------------------------

  Future<String?> updatePassword2({required String oldPassword, required String newPassword, required String userId}) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        return "Geçerli kullanıcı null";
      }

      AuthCredential credentials = EmailAuthProvider.credential(email: currentUser.email!, password: oldPassword);
      await currentUser.reauthenticateWithCredential(credentials);

      print("Yeniden doğrulama başarılı");

      await currentUser.updatePassword(newPassword);

      print("Şifre güncelleme başarılı");

      return null;
    } catch (e) {
      print("Error during password update: $e");
      return e.toString();
    }
  }

  Future<String?> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Kullanıcının mevcut kimlik bilgilerini al
        AuthCredential credentials = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: oldPassword,
        );

        // Kullanıcıyı mevcut kimlik bilgileriyle yeniden doğrula
        await currentUser.reauthenticateWithCredential(credentials);

        // Yeni şifreyi güncelle
        await currentUser.updatePassword(newPassword);

        // Başarılı mesajı göster
        Fluttertoast.showToast(
          msg: "Şifre başarıyla güncellendi.",
          toastLength: Toast.LENGTH_LONG,
        );

        return null; // Başarı, null döndür
      } else {
        return "Oturum açmış bir kullanıcı bulunamadı."; // Kullanıcı oturumu açık değilse
      }
    } catch (e) {
      // Hata mesajını göster
      Fluttertoast.showToast(
        msg: "Şifre güncelleme işlemi sırasında bir hata oluştu.",
        toastLength: Toast.LENGTH_LONG,
      );
      return "Şifre güncelleme işlemi sırasında bir hata oluştu.";
    }
  }



  Future<String?> updatePassword1({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      // Kullanıcının veritabanındaki mevcut bilgilerini al
      Kullanici? kullanici = await _kullaniciService.getKullaniciById(userId);

      if (kullanici != null) {
        // Kullanıcının veritabanındaki şifresini kontrol et
        if (kullanici.sifre == oldPassword) {
          // Yeni şifreyi veritabanında güncelle
          kullanici.sifre = newPassword;

          // Kullanıcının veritabanındaki bilgileri güncelle
          await _kullaniciService.updateKullanici1(kullanici);

          // Başarılı mesajı göster
          Fluttertoast.showToast(
            msg: "Şifre başarıyla güncellendi.",
            toastLength: Toast.LENGTH_LONG,
          );

          return null; // Başarı, null döndür
        } else {
          return "Eski şifre hatalı."; // Eski şifre hatalıysa
        }
      } else {
        return "Kullanıcı bulunamadı."; // Kullanıcı bulunamazsa
      }
    } catch (e) {
      // Hata mesajını göster
      Fluttertoast.showToast(
        msg: "Şifre güncelleme işlemi sırasında bir hata oluştu.",
        toastLength: Toast.LENGTH_LONG,
      );
      return "Şifre güncelleme işlemi sırasında bir hata oluştu.";
    }
  }


  Future<String?> updatePasswordByEmail({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      // Kullanıcının Firebase Authentication'da giriş yapmasını sağla
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: oldPassword,
      );

      // Kullanıcının Firebase Authentication UID'sini al
      String userId = userCredential.user?.uid ?? '';

      // Kullanıcının veritabanındaki mevcut bilgilerini al
      Kullanici? kullanici = await _kullaniciService.getKullanici(userId);

      if (kullanici != null) {
        // Yeni şifreyi veritabanında güncelle
        kullanici.sifre = newPassword;

        // Kullanıcının veritabanındaki bilgileri güncelle
        await _kullaniciService.updateKullanici(kullanici);

        // Başarılı mesajı göster
        Fluttertoast.showToast(
          msg: "Şifre başarıyla güncellendi.",
          toastLength: Toast.LENGTH_LONG,
        );

        return null; // Başarı, null döndür
      } else {
        return "Kullanıcı bulunamadı."; // Kullanıcı bulunamazsa
      }
    } catch (e) {
      print("Hata detayı: $e");
      Fluttertoast.showToast(
        msg: "Şifre güncelleme işlemi sırasında bir hata oluştu.",
        toastLength: Toast.LENGTH_LONG,
      );
      return "Şifre güncelleme işlemi sırasında bir hata oluştu.";
    }
  }




}