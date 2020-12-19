import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ConversationSnippet {
  final String id;
  final String conversationID;
  final String lastMessage;
  final String name;
  final String image;
  final int unseenCount;
  final Timestamp timestamp;

  ConversationSnippet(
      {this.id,
      this.conversationID,
      this.lastMessage,
      this.name,
      this.image,
      this.unseenCount,
      this.timestamp});

  factory ConversationSnippet.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data();

    return ConversationSnippet(
      id: _snapshot.id,
      conversationID: _data["conversationID"],
      lastMessage: _data["lastMessage"] != null ? _data["lastMessage"] : "",
      unseenCount: _data["unseenCount"],
      timestamp: _data["timestamp"],
      name: _data["name"],
      image: _data["image"],
    );
  }
}
