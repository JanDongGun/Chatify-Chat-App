import 'package:flutter/material.dart';

class RecentConversationsPage extends StatelessWidget {
  final double _width;
  final double _height;

  RecentConversationsPage(this._height, this._width);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: _height,
      width: _width,
      child: _conversationsListviewWidget(),
    );
  }

  Widget _conversationsListviewWidget() {
    return Container(
      width: _width,
      height: _height,
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (_context, _index) {
          return ListTile(
            onTap: () {},
            title: Text('Dong Gon'),
            subtitle: Text('Subtitle'),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: NetworkImage("https://i.pravatar.cc/150?img=3"),
                ),
              ),
            ),
            trailing: _listTileTrailingWidgets(),
          );
        },
      ),
    );
  }

  Widget _listTileTrailingWidgets() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Lastseen',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ],
    );
  }
}
