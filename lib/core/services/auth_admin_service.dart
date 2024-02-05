import 'package:firebase_auth/firebase_auth.dart';
import '../models/admin_model.dart';
import 'admin_service.dart';

class AuthenticationAdminService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AdminService _adminService = AdminService();

  // Admin kaydı oluştur
  Future<void> signUpAdmin(String email, String password, String ad, String soyad) async {
    try {
      // Firebase Authentication kullanarak admin kaydı oluştur
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Oluşturulan adminin bilgilerini AdminService kullanarak Firestore'a kaydet
      await _adminService.createAdmin(Admin(
        id: result.user?.uid,
        ad: ad,
        soyad: soyad,
        email: email,
        sifre: password,
      ));
    } catch (e) {
      print(e.toString());
    }
  }

  // Admin girişi yap
  Future<void> signInAdmin(String email, String password) async {
    try {
      // Firebase Authentication kullanarak admin girişi yap
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  // Admin çıkışı yap
  Future<void> signOutAdmin() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  // Şu anki oturum açmış admini al
  User? getCurrentAdmin() {
    return _auth.currentUser;
  }
}