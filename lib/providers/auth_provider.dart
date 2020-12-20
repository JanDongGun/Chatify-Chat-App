import 'package:chatify/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatify/services/snackbar_service.dart';
import 'package:chatify/services/db_service.dart';

enum AuthStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNotFound,
  Error,
}

class AuthProvider extends ChangeNotifier {
  User user;
  AuthStatus status;
  FirebaseAuth _auth;

  static AuthProvider instance = AuthProvider();
  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _checkCurrentUserIsAuthenticated();
  }

  void _autoLogin() {
    if (user != null) {
      NavigationService.instance.navigateToReplacement('home');
    }
  }

  void _checkCurrentUserIsAuthenticated() async {
    user = await _auth.currentUser;
    if (user != null) {
      notifyListeners();

      _autoLogin();
    }
  }

  void loginUserWithEmailAndPassword(String _email, String _password) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential _result = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      user = _result.user;
      status = AuthStatus.Authenticated;
      SnackBarService.instance.showSnackBar('Welcome ${user.email}', 'success');
      DBService.instance.updateUserLastSeenTime(user.uid);
      NavigationService.instance.navigateToReplacement('home');
    } catch (e) {
      status = AuthStatus.Error;
      if (e.code == 'user-not-found') {
        SnackBarService.instance
            .showSnackBar('No user found for that email', 'error');
      } else if (e.code == 'wrong-password') {
        SnackBarService.instance
            .showSnackBar('Wrong password provided for that user', 'error');
      }
    }

    notifyListeners();
  }

  void regisUserWithEmailAndPassword(String _email, String _password,
      Future<void> onSuccess(String _uid)) async {
    status = AuthStatus.Authenticating;
    notifyListeners();

    try {
      UserCredential _result = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      user = _result.user;
      status = AuthStatus.Authenticated;
      await onSuccess(user.uid);
      SnackBarService.instance.showSnackBar('Register Success', 'success');
      NavigationService.instance.goBack();
    } catch (e) {
      status = AuthStatus.Error;
      if (e.code == 'weak-password') {
        SnackBarService.instance
            .showSnackBar('The password provided is too weak.', 'error');
      } else if (e.code == 'email-already-in-use') {
        SnackBarService.instance
            .showSnackBar('The account already exists for that email', 'error');
      }
      user = null;
    }

    notifyListeners();
  }

  void logoutUser(Future<void> onSuccess()) async {
    try {
      await _auth.signOut();
      user = null;
      status = AuthStatus.NotAuthenticated;
      await onSuccess();
      await NavigationService.instance.navigateToReplacement('login');
      SnackBarService.instance
          .showSnackBar('Logged out successfully', 'success');
    } catch (e) {
      SnackBarService.instance.showSnackBar("Error Logging Out", 'Error');
    }
  }
}
