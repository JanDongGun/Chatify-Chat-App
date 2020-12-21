import 'package:flutter/material.dart';
import 'package:chatify/services/navigation_service.dart';

class SuccessSendEmailResetPassword extends StatelessWidget {
  double _deviceHeight;
  double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Align(
        alignment: Alignment.center,
        child: _successSendEmailResetPasswordUI(),
      ),
    );
  }

  Widget _successSendEmailResetPasswordUI() {
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
          _backToLogin(),
          // _registerButton(),
        ],
      ),
    );
  }

  Widget _headingWidget() {
    return Container(
      height: _deviceHeight * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Check your email',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "We have sent a password recovery instruction to your email",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white70,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            'Check your inbox and follow the reset password link.',
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

  Widget _backToLogin() {
    return Container(
      height: _deviceHeight * 0.07,
      width: _deviceWidth,
      child: MaterialButton(
        onPressed: () {
          NavigationService.instance.navigateToReplacement('login');
        },
        color: Colors.blue,
        child: Text(
          'Return to login',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
