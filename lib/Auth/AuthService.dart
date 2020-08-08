import 'dart:async';

import 'package:beru_admin/Auth/AuthLogin.dart';
import 'package:beru_admin/Schema/Admin.dart';
import 'package:beru_admin/UI/CommonFunctions/BeruAlertWithCallBack.dart';
import 'package:beru_admin/UI/CommonFunctions/ErrorAlert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthService extends ChangeNotifier {
  bool hasUser;
  Stream firebaseStatusStream = FirebaseAuth.instance.onAuthStateChanged;
  StreamSubscription sub;

  AuthService() {
    checkUserSatus();
  }

  checkUserSatus() {
    sub = firebaseStatusStream.listen(
      (event) {
        if (event != null) {
          hasUser = true;
        } else {
          hasUser = false;
        }
        if (!sub.isPaused) {
          sub.pause();
        }
        notifyListeners();
      },
    );
  }

  adminLogin(Admin user, BuildContext context) async {
    
    try {
      if (await Auth().loginWithEmailAndPassword(user)) {
        context.pop();
        alertWithCallBack(
            cakllback: () {
              this.hasUser = true;
              notifyListeners();
              Navigator.of(context).pop();
            },
            context: context,
            callBackName: "Continue",
            content: "Loged In");
      }
    } catch (e) {
      context.pop();
      print("Error from adminLogin $e");
      errorAlert(context, e.toString());
    }
  }

  adminLogOut() async {
    try {
      await Auth().logOut();
    } catch (e) {
      print("Error from adminLogOut $e");
    }
  }
}
