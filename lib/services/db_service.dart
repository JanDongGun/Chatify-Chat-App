import 'package:chatify/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatify/models/contact.dart';
import '../models/conversation.dart';

class DBService {
  FirebaseFirestore _db;

  static DBService instance = DBService();
  DBService() {
    _db = FirebaseFirestore.instance;
  }

  String _userCollection = "Users";
  String _userConversations = "Conversations";

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

  Future<void> updateUserLastSeenTime(String _userID) {
    var _ref = _db.collection(_userCollection).doc(_userID);
    return _ref.update({"lastScreen": Timestamp.now()});
  }

  Future<void> sendMessage(String _conversationID, Message _message) {
    var _ref = _db.collection(_userConversations).doc(_conversationID);
    var _messageType = "";
    switch (_message.type) {
      case MessageType.Text:
        _messageType = "text";
        break;
      case MessageType.Image:
        _messageType = "image";
        break;
      default:
    }
    return _ref.update({
      "messages": FieldValue.arrayUnion([
        {
          "message": _message.content,
          "senderID": _message.senderID,
          "timestamp": _message.timestamp,
          "type": _messageType,
        }
      ])
    });
  }

  Stream<Contact> getUserData(String _userID) {
    var _ref = _db.collection(_userCollection).doc(_userID);
    return _ref.get().asStream().map((_snapshot) {
      return Contact.fromFirestore(_snapshot);
    });
  }

  Stream<List<ConversationSnippet>> getUserConversation(String _uid) {
    var _ref = _db
        .collection(_userCollection)
        .doc(_uid)
        .collection(_userConversations);
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return ConversationSnippet.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream getUserInDB(String _searchName) {
    var _ref = _db
        .collection(_userCollection)
        .where("name", isGreaterThanOrEqualTo: _searchName)
        .where("name", isLessThan: _searchName + 'z');
    return _ref.get().asStream().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return Contact.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream getConversation(String _conversationID) {
    var _ref = _db.collection(_userConversations).doc(_conversationID);

    return _ref.snapshots().map((_snapshot) {
      return Conversation.fromFirestore(_snapshot);
    });
  }
}
