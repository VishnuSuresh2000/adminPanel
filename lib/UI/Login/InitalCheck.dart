import 'package:beru_admin/Auth/AuthService.dart';
import 'package:beru_admin/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru_admin/UI/Home/AdminHome.dart';
import 'package:beru_admin/UI/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitalCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, value, child) {
        if (value == null || value.hasUser == null) {
          return beruLoadingBar();
        } else if (!value.hasUser) {
          return BeruAdminLogin();
        } else if (value.hasUser) {
          return AdminHome();
        } else {
          return Container(
            child: Center(child: Text("Else paret")),
          );
        }
      },
    );
  }
}
