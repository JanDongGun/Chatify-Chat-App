import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatify/models/contact.dart';

class DBService {
  FirebaseFirestore _db;

  static DBService instance = DBService();
  DBService() {
    _db = FirebaseFirestore.instance;
  }

  String _userCollection = "Users";

  Future<void> createUserInDB(
      String _uid, String _name, String _email, String _imageURL) {
    try {
      return _db.collection(_userCollection).doc(_uid).set({
        "name": _name,
        "email": _email,
        "image": _imageURL,
        "lastScreen": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<Contact> getUserData(String _userID) {
    var _ref = _db.collection(_userCollection).doc(_userID);
    return _ref.get().asStream().map((_snapshot) {
      return Contact.fromFirestore(_snapshot);
    });
  }
}
