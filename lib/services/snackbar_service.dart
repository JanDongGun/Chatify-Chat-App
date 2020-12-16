import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SnackBarService {
  BuildContext _buildContext;

  static SnackBarService instance = SnackBarService();

  SnackBarService() {}

  set buildContext(BuildContext _context) {
    _buildContext = _context;
  }

  void showSnackBar(String _message, String _status) {
    Scaffold.of(_buildContext).showSnackBar(SnackBar(
      backgroundColor: _status == 'error' ? Colors.red : Colors.green,
      duration: Duration(seconds: 2),
      content: Text(
        _message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    ));
  }
}
