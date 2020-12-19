import 'package:cloud_firestore/cloud_firestore.dart';
import 'message.dart';

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

class Conversation {
  final String id;
  final List<String> members;
  final List<Message> messages;
  final String ownerID;

  Conversation({this.id, this.members, this.messages, this.ownerID});

  factory Conversation.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data();

    List _messages = _data["messages"];

    if (_messages != null) {
      _messages.map((_m) {
        var _messageType =
            _m["type"] == "text" ? MessageType.Text : MessageType.Image;
        return Message(
          senderID: _m["senderID"],
          content: _m["message"],
          timestamp: _m["timestamp"],
          type: _messageType,
        );
      }).toList();
    } else {
      _messages = null;
    }

    return Conversation(
      id: _snapshot.id,
      members: _data["members"],
      ownerID: _data["ownerID"],
      messages: _messages,
    );
  }
}
