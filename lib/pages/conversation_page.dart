import 'package:chatify/models/message.dart';
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
          Align(
            alignment: Alignment.bottomCenter,
            child: _messageField(_context),
          )
        ],
      );
    });
  }

  Widget _messageListView() {
    return Container(
      margin: EdgeInsets.only(top: 20),
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
                    return _messageListViewChild(_isOwnMessage, _message);
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

  Widget _messageListViewChild(bool _isOwnMessage, Message _message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            !_isOwnMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          _userImageWidget(_isOwnMessage),
          SizedBox(
            width: 15,
          ),
          _textMessageBubble(
              _isOwnMessage, _message.content, _message.timestamp),
        ],
      ),
    );
  }

  Widget _userImageWidget(bool _isOwnMessage) {
    double _imageRadius = _deviceHeight * 0.05;

    return !_isOwnMessage
        ? Container(
            width: _imageRadius,
            height: _imageRadius,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(this.widget._receiverImage),
              ),
            ),
          )
        : Container();
  }

  Widget _textMessageBubble(
      bool _isOwnerMessage, String _message, Timestamp _messageTimestamp) {
    List<Color> _colorScheme = _isOwnerMessage
        ? [Colors.blue, Color.fromRGBO(42, 117, 188, 1)]
        : [Color.fromRGBO(69, 69, 69, 1), Color.fromRGBO(43, 43, 43, 1)];
    return Container(
      margin: _isOwnerMessage
          ? EdgeInsets.only(right: 20)
          : EdgeInsets.only(right: 0),
      width: _deviceWidth * 0.6,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
          Text(
            _message,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 8,
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

  Widget _messageField(BuildContext _context) {
    return Container(
      height: _deviceHeight * 0.08,
      decoration: BoxDecoration(
        color: Color.fromRGBO(43, 43, 43, 1),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.04, vertical: _deviceHeight * 0.03),
      child: Form(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(_context),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.55,
      child: TextFormField(
        autocorrect: false,
        validator: (_input) {
          if (_input.length == 0) {
            return "Please enter a message";
          }

          return null;
        },
        onChanged: (_input) {},
        onSaved: (_input) {},
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Type a message",
          hintStyle: TextStyle(
            color: Colors.white54,
          ),
        ),
      ),
    );
  }

  Widget _sendMessageButton(BuildContext _context) {
    return Container(
      height: _deviceHeight * 0.05,
      width: _deviceHeight * 0.05,
      child: IconButton(
          icon: Icon(
            Icons.send,
            color: Colors.white,
          ),
          onPressed: () {}),
    );
  }

  Widget _imageMessageButton() {
    return Container(
      height: _deviceHeight * 0.05,
      width: _deviceHeight * 0.05,
      child: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.camera_enhance),
      ),
    );
  }
}
