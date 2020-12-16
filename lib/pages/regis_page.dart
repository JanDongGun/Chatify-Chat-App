import 'package:flutter/material.dart';

class RegisPage extends StatefulWidget {
  @override
  _RegisPageState createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisPage> {
  double _deviceHeight;
  double _deviceWidth;

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
    return Container(
      height: _deviceHeight * 0.8,
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headingWidget(),
          _inputForm(),
        ],
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
          ],
        ),
      ),
    );
  }

  Widget _imageSelectorWidget() {
    return Align(
      child: Container(
        height: _deviceHeight * 0.1,
        width: _deviceHeight * 0.1,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(500),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('images/iconAvatar.png'),
          ),
        ),
      ),
    );
  }
}
