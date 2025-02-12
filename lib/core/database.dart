import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addDocument(
      String collection, Map<String, dynamic> data) async {
    await _db.collection(collection).add(data);
  }

  static Future<List<Map<String, dynamic>>> getDocuments(
      String collection) async {
    QuerySnapshot snapshot = await _db.collection(collection).get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  static Future<void> updateDocument(
      String collection, String id, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(id).update(data);
  }

  static Future<void> deleteDocument(String collection, String id) async {
    await _db.collection(collection).doc(id).delete();
  }
}
