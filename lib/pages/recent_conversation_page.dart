import 'package:chatify/services/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatify/providers/auth_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timeago/timeago.dart' as timeago;

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
                return _snapshot.hasData
                    ? ListView.builder(
                        itemCount: _data.length,
                        itemBuilder: (_context, _index) {
                          return ListTile(
                            onTap: () {},
                            title: Text(_data[_index].name),
                            subtitle: Text(_data[_index].lastMessage),
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
                    : SpinKitWanderingCubes(
                        color: Colors.blue,
                        size: 50,
                      );
              }));
    });
  }

  Widget _listTileTrailingWidgets(Timestamp _lastMessageTimestamp) {
    var _timeDifference =
        _lastMessageTimestamp.toDate().difference(DateTime.now());

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          timeago.format(_lastMessageTimestamp.toDate()),
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            color: _timeDifference.inHours > 1 ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ],
    );
  }
}
