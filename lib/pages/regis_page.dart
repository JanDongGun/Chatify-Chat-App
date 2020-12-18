import 'dart:io';

import 'package:chatify/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:image_picker/image_picker.dart';

class RegisPage extends StatefulWidget {
  @override
  _RegisPageState createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisPage> {
  double _deviceHeight;
  double _deviceWidth;
  File _image;

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
        child: signupPageUI(),
      ),
    );
  }

  Widget signupPageUI() {
    return Flexible(
      child: Container(
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
      ),
    );
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
    return Container(
      height: _deviceHeight * 0.35,
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
    return TextFormField(
      autocorrect: false,
      style: TextStyle(color: Colors.white),
      validator: (_input) {
        return _input.length != 0 ? null : 'Please enter name';
      },
      onSaved: (_input) {
        setState(() {});
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: 'Name',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
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
        setState(() {});
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
        setState(() {});
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

  Widget _registerButton() {
    return Container(
      height: _deviceHeight * 0.07,
      width: _deviceWidth,
      child: MaterialButton(
        onPressed: () {},
        color: Colors.blue,
        child: Text(
          'Register',
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
