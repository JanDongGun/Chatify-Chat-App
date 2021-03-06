import 'package:chatify/services/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:chatify/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:chatify/services/navigation_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _deviceHeight;
  double _deviceWidth;
  String _email;
  String _password;

  GlobalKey<FormState> _formKey;
  AuthProvider _auth;
  _LoginPageState() {
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
          child: _loginPageUI(),
        ),
      ),
    );
  }

  Widget _loginPageUI() {
    return Builder(builder: (BuildContext _context) {
      SnackBarService.instance.buildContext = _context;
      _auth = Provider.of<AuthProvider>(_context);
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.1, vertical: _deviceHeight * 0.02),
        alignment: Alignment.center,
        height: _deviceHeight * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _headingWidget(),
            _inputForm(),
            _loginButton(),
            _registerButton(),
          ],
        ),
      );
    });
  }

  Widget _headingWidget() {
    return Container(
      height: _deviceHeight * 0.12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Welcome back!',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Please login to your account',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputForm() {
    return Container(
      height: _deviceHeight * 0.25,
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
            _passwordTextField(),
            _forgotPassword(),
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

  Widget _passwordTextField() {
    return TextFormField(
      autocorrect: false,
      obscureText: true,
      style: TextStyle(color: Colors.white),
      validator: (_input) {
        return _input.length != 0 ? null : 'Please enter password';
      },
      onSaved: (_input) {
        setState(() {
          _password = _input;
        });
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: 'Password',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _forgotPassword() {
    return GestureDetector(
      onTap: () {
        NavigationService.instance.navigateTo("forgotPassword");
      },
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return _auth.status == AuthStatus.Authenticating
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
                  _auth.loginUserWithEmailAndPassword(_email, _password);
                }
              },
              color: Colors.blue,
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
  }

  Widget _registerButton() {
    return GestureDetector(
      onTap: () {
        NavigationService.instance.navigateTo('regis');
      },
      child: Container(
        width: _deviceWidth,
        height: _deviceHeight * 0.07,
        child: Text(
          'Register',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white60,
          ),
        ),
      ),
    );
  }
}
