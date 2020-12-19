import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/db_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:chatify/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ConversationPage extends StatefulWidget {
  String _conversationID;
  String _receiverID;
  String _receiverImage;
  String _receiverName;

  ConversationPage(this._conversationID, this._receiverID, this._receiverImage,
      this._receiverName);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  double _deviceHeight;
  double _deviceWidth;

  AuthProvider _auth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(31, 31, 31, 1.0),
        title: Text(this.widget._receiverName),
      ),
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _conversationPageUI(),
      ),
    );
  }

  Widget _conversationPageUI() {
    return Builder(builder: (BuildContext _context) {
      _auth = Provider.of<AuthProvider>(_context);
      return Stack(
        overflow: Overflow.visible,
        children: [
          _messageListView(),
        ],
      );
    });
  }

  Widget _messageListView() {
    return Container(
      height: _deviceHeight * 0.75,
      width: _deviceWidth,
      child: StreamBuilder(
          stream:
              DBService.instance.getConversation(this.widget._conversationID),
          builder: (BuildContext _context, _snapshot) {
            var _conversationData = _snapshot.data;

            if (_conversationData != null) {
              return ListView.builder(
                  itemCount: _conversationData.messages.length,
                  itemBuilder: (BuildContext _context, int _index) {
                    var _message = _conversationData.messages[_index];
                    bool _isOwnMessage = _message.senderID == _auth.user.uid;
                    return _textMessageBubble(
                        _isOwnMessage, _message.content, _message.timestamp);
                  });
            } else {
              return SpinKitWanderingCubes(
                color: Colors.blue,
                size: 50,
              );
            }
          }),
    );
  }

  Widget _textMessageBubble(
      bool _isOwnerMessage, String _message, Timestamp _messageTimestamp) {
    List<Color> _colorScheme = _isOwnerMessage
        ? [Colors.blue, Color.fromRGBO(42, 117, 188, 1)]
        : [Color.fromRGBO(69, 69, 69, 1), Color.fromRGBO(43, 43, 43, 1)];
    return Container(
      // height: _deviceHeight * 0.1,
      width: _deviceWidth * 0.75,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            colors: _colorScheme,
            stops: [0.30, 0.70],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_message),
          SizedBox(
            height: 10,
          ),
          Text(
            timeago.format(_messageTimestamp.toDate()),
            style: TextStyle(
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }
}
