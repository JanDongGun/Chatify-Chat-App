import 'dart:ui';

import 'package:chatify/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:chatify/services/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timeago/timeago.dart' as timeago;

class SearchPage extends StatefulWidget {
  final double _height;
  final double _width;

  SearchPage(this._height, this._width);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  AuthProvider _auth;
  String _searchText;

  _SearchPageState() {
    _searchText = "";
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _searchPageUI(),
      ),
    );
  }

  Widget _searchPageUI() {
    return Builder(builder: (BuildContext _context) {
      _auth = Provider.of<AuthProvider>(_context);
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _userSearchField(),
          _userListView(),
        ],
      );
    });
  }

  Widget _userSearchField() {
    return Container(
      width: this.widget._width,
      height: this.widget._height * 0.08,
      margin: EdgeInsets.symmetric(vertical: this.widget._height * 0.01),
      child: TextField(
        autocorrect: false,
        style: TextStyle(color: Colors.white),
        onSubmitted: (_input) {
          setState(() {
            _searchText = _input;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
            size: 30,
          ),
          hintText: 'Search',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _userListView() {
    return Flexible(
      child: StreamBuilder(
          stream: DBService.instance.getUserInDB(_searchText),
          builder: (_context, _snapshot) {
            var _userData = _snapshot.data;
            if (_userData != null) {
              _userData
                  .removeWhere((_contact) => _contact.id == _auth.user.uid);
            }
            return _snapshot.hasData
                ? Container(
                    height: this.widget._height * 0.65,
                    child: ListView.builder(
                        itemCount: _userData.length,
                        itemBuilder: (BuildContext _context, int _index) {
                          var _user = _userData[_index];
                          var _currentTime = DateTime.now();
                          var _isUserActive = !_user.lastseen.toDate().isBefore(
                                _currentTime.subtract(
                                  Duration(hours: 1),
                                ),
                              );
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: ListTile(
                              title: Text(_user.name),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(_user.image),
                                  ),
                                ),
                              ),
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _isUserActive
                                      ? Text(
                                          'Active Now',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        )
                                      : Text(
                                          'Last Seen',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                  _isUserActive
                                      ? Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                        )
                                      : Text(
                                          timeago
                                              .format(_user.lastseen.toDate()),
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                : SpinKitWanderingCubes(
                    color: Colors.blue,
                    size: 50.0,
                  );
          }),
    );
  }
}
