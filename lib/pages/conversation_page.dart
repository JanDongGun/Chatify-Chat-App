import 'package:flutter/material.dart';

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
      body: _conversationPageUI(),
    );
  }

  Widget _conversationPageUI() {
    return Stack(
      overflow: Overflow.visible,
      children: [
        _messageListView(),
      ],
    );
  }

  Widget _messageListView() {
    return Container(
      height: _deviceHeight * 0.75,
      width: _deviceWidth,
      child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext _context, int _index) {
            return _textMessageBubble(true, 'Hello ');
          }),
    );
  }

  Widget _textMessageBubble(bool _isOwnerMessage, String _message) {
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
            'A moment ago',
            style: TextStyle(
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }
}
