import 'dart:io';

import 'package:chatify/providers/auth_provider.dart';
import 'package:chatify/services/media_service.dart';
import 'package:chatify/services/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:chatify/services/cloud_storage_service.dart';
import 'package:chatify/services/db_service.dart';

class RegisPage extends StatefulWidget {
  @override
  _RegisPageState createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisPage> {
  double _deviceHeight;
  double _deviceWidth;
  File _image;
  String _name;
  String _email;
  String _password;
  AuthProvider _auth;

  GlobalKey<FormState> _globalKey;

  _RegisPageState() {
    _globalKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        alignment: Alignment.center,
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: signupPageUI(),
        ),
      ),
    );
  }

  Widget signupPageUI() {
    return Flexible(child: Builder(
      builder: (BuildContext _context) {
        SnackBarService.instance.buildContext = _context;
        _auth = Provider.of<AuthProvider>(_context);
        return Container(
          height: _deviceHeight * 0.9,
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headingWidget(),
              _inputForm(),
              _registerButton(),
              _backToLoginPageButton(),
            ],
          ),
        );
      },
    ));
  }

  Widget _headingWidget() {
    return Container(
      height: _deviceHeight * 0.12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get going!",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Please enter your details',
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
    return Flexible(
      child: Container(
        height: _deviceHeight * 0.4,
        child: Form(
          key: _globalKey,
          onChanged: () {
            _globalKey.currentState.save();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imageSelectorWidget(),
              _nameTextField(),
              _emailTextField(),
              _passwordTextField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageSelectorWidget() {
    return GestureDetector(
      onTap: () async {
        PickedFile _imageFile =
            await MediaService.instance.getImageFromLibrary();
        setState(() {
          if (_imageFile != null) {
            _image = File(_imageFile.path);
          }
        });
      },
      child: Align(
        child: Container(
          height: _deviceHeight * 0.12,
          width: _deviceHeight * 0.12,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(500),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: _image != null
                  ? FileImage(_image)
                  : AssetImage('images/iconAvatar.png'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return Flexible(
      child: TextFormField(
        autocorrect: false,
        style: TextStyle(color: Colors.white),
        validator: (_input) {
          return _input.length != 0 ? null : 'Please enter name';
        },
        onSaved: (_input) {
          setState(() {
            _name = _input;
          });
        },
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Name',
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return Flexible(
      child: TextFormField(
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
      ),
    );
  }

  Widget _passwordTextField() {
    return Flexible(
      child: TextFormField(
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
      ),
    );
  }

  Widget _registerButton() {
    return _auth.status != AuthStatus.Authenticating
        ? Container(
            height: _deviceHeight * 0.07,
            width: _deviceWidth,
            child: MaterialButton(
              onPressed: () {
                if (_globalKey.currentState.validate() && _image != null) {
                  _auth.regisUserWithEmailAndPassword(_email, _password,
                      (String _uid) async {
                    var _result = await CloudStorageService.instance
                        .uploadUserImage(_uid, _image);
                    var _imageURL = await _result.ref.getDownloadURL();
                    await DBService.instance
                        .createUserInDB(_uid, _name, _email, _imageURL);
                  });
                } else if (_image == null) {
                  SnackBarService.instance
                      .showSnackBar('Please insert avatar', 'error');
                }
              },
              color: Colors.blue,
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        : Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
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
