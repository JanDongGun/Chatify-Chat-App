import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class ConversationSnippet {
  final String id;
  final String conversationID;
  final String lastMessage;
  final String name;
  final String image;
  final MessageType type;
  final int unseenCount;
  final Timestamp timestamp;

  ConversationSnippet(
      {this.id,
      this.conversationID,
      this.lastMessage,
      this.name,
      this.image,
      this.type,
      this.unseenCount,
      this.timestamp});

  factory ConversationSnippet.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data();
    var _messageType = MessageType.Text;
    if (_data["type"] == "image") {
      _messageType = MessageType.Image;
    }
    return ConversationSnippet(
      id: _snapshot.id,
      conversationID: _data["conversationID"],
      lastMessage: _data["lastMessage"] != null ? _data["lastMessage"] : "",
      unseenCount: _data["unseenCount"],
      timestamp: _data["timestamp"] != null ? _data["timestamp"] : null,
      type: _messageType,
      name: _data["name"],
      image: _data["image"],
    );
  }
}

class Conversation {
  final String id;
  final List members;
  final List<Message> messages;
  final String ownerID;

  Conversation({this.id, this.members, this.messages, this.ownerID});

  factory Conversation.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data();

    List _messages = _data["messages"];

    if (_messages != null) {
      _messages = _messages.map((_m) {
        return Message(
          senderID: _m["senderID"],
          content: _m["message"],
          timestamp: _m["timestamp"],
          type: _m["type"] == "text" ? MessageType.Text : MessageType.Image,
        );
      }).toList();
    } else {
      _messages = [];
    }

    return Conversation(
      id: _snapshot.id,
      members: _data["members"],
      ownerID: _data["ownerID"],
      messages: _messages,
    );
  }
}
