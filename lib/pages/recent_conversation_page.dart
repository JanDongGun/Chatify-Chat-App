import 'package:chatify/models/message.dart';
import 'package:chatify/services/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatify/providers/auth_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:chatify/services/navigation_service.dart';
import 'package:chatify/pages/conversation_page.dart';

class RecentConversationsPage extends StatelessWidget {
  final double _width;
  final double _height;
  AuthProvider _auth;

  RecentConversationsPage(this._height, this._width);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: _height,
      width: _width,
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _conversationsListviewWidget(),
      ),
    );
  }

  Widget _conversationsListviewWidget() {
    return Builder(builder: (BuildContext _context) {
      _auth = Provider.of<AuthProvider>(_context);
      return Container(
          width: _width,
          height: _height,
          child: StreamBuilder(
              stream: DBService.instance.getUserConversation(_auth.user.uid),
              builder: (_context, _snapshot) {
                var _data = _snapshot.data;
                if (_data != null) {
                  _data.removeWhere((_c) {
                    return _c.timestamp == null;
                  });
                  return _data.length != 0
                      ? ListView.builder(
                          itemCount: _data.length,
                          itemBuilder: (_context, _index) {
                            return ListTile(
                              onTap: () {
                                NavigationService.instance.navigateToRoute(
                                    MaterialPageRoute(
                                        builder: (BuildContext _context) {
                                  return ConversationPage(
                                      _data[_index].conversationID,
                                      _data[_index].id,
                                      _data[_index].image,
                                      _data[_index].name);
                                }));
                              },
                              title: Text(_data[_index].name),
                              subtitle: Text(
                                  _data[_index].type == MessageType.Text
                                      ? _data[_index].lastMessage
                                      : 'Attachment Image'),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(_data[_index].image),
                                  ),
                                ),
                              ),
                              trailing: _listTileTrailingWidgets(
                                  _data[_index].timestamp),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'No Conversations Yet!',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white30),
                          ),
                        );
                } else {
                  return SpinKitWanderingCubes(
                    color: Colors.blue,
                    size: 50,
                  );
                }
              }));
    });
  }

  Widget _listTileTrailingWidgets(Timestamp _lastMessageTimestamp) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Last Message',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        Text(
          timeago.format(_lastMessageTimestamp.toDate()),
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
