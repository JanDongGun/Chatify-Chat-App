import 'dart:ui';

import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final double _height;
  final double _width;

  SearchPage(this._height, this._width);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _searchPageUI(),
    );
  }

  Widget _searchPageUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _userSearchField(),
        _userListView(),
      ],
    );
  }

  Widget _userSearchField() {
    return Container(
      width: this.widget._width,
      height: this.widget._height * 0.08,
      margin: EdgeInsets.symmetric(vertical: this.widget._height * 0.01),
      child: TextField(
        autocorrect: false,
        style: TextStyle(color: Colors.white),
        onSubmitted: (_input) {},
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
    return Container(
      height: this.widget._height * 0.65,
      child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext _context, int _index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: ListTile(
                title: Text('Huyen tran'),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage('https://i.pravatar.cc/150?img=1'),
                    ),
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Last seen',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'About an hour ago',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
