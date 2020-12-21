import 'package:chatify/pages/successSendEmail.dart';
import 'package:chatify/providers/auth_provider.dart';
import 'package:chatify/services/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  double _deviceHeight;
  double _deviceWidth;
  String _email;
  AuthProvider _auth;

  GlobalKey<FormState> _formKey;
  _ForgotPasswordPageState() {
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Align(
        alignment: Alignment.center,
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: _forgotPageUI(),
        ),
      ),
    );
  }

  Widget _forgotPageUI() {
    return Builder(builder: (BuildContext _context) {
      SnackBarService.instance.buildContext = _context;
      _auth = Provider.of<AuthProvider>(_context);
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.1, vertical: _deviceHeight * 0.02),
        alignment: Alignment.center,
        height: _deviceHeight * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _headingWidget(),
            _inputForm(),
            _sendButton(),
            _backToLoginPageButton(),
            // _registerButton(),
          ],
        ),
      );
    });
  }

  Widget _headingWidget() {
    return Container(
      height: _deviceHeight * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Forgot password?',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Enter your registered email below to receive password reset instruction',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white70,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputForm() {
    return Container(
      height: _deviceHeight * 0.12,
      child: Form(
        key: _formKey,
        onChanged: () {
          _formKey.currentState.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _emailTextField(),
          ],
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      autocorrect: false,
      style: TextStyle(color: Colors.white),
      validator: (_input) {
        return _input.length != 0 && _input.contains('@')
            ? null
            : 'Please enter a valid email';
      },
      onSaved: (_input) {
        setState(() {
          _email = _input;
        });
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: 'Email address',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _sendButton() {
    return _auth.emailStatus == EmailStatus.Sending
        ? Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : Container(
            height: _deviceHeight * 0.07,
            width: _deviceWidth,
            child: MaterialButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _auth.sendpasswordResetEmail(_email);
                }
              },
              color: Colors.blue,
              child: Text(
                'Send',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
  }

  Widget _backToLoginPageButton() {
    return GestureDetector(
      onTap: () {
        NavigationService.instance.goBack();
      },
      child: Container(
        height: _deviceHeight * 0.07,
        width: _deviceWidth,
        child: Icon(
          Icons.arrow_back,
          size: 40,
        ),
      ),
    );
  }
}
