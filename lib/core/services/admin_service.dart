import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/admin_model.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createAdmin(Admin admin) async {
    try {
      await _firestore.collection('admin').add(admin.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Admin?> getAdmin(String adminID) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('admin').doc(adminID).get();

      if (doc.exists) {
        Admin admin = Admin.fromMap(doc.data() as Map<String, dynamic>);
        return admin;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> updateAdmin(Admin admin) async {
    try {
      await _firestore.collection('admin').doc(admin.id).update(admin.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteAdmin(String adminID) async {
    try {
      await _firestore.collection('admin').doc(adminID).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}