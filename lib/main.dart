import 'package:beru_admin/Auth/AuthService.dart';
import 'package:beru_admin/Router/BeruAdminRouter.dart';
import 'package:beru_admin/Server/ServerCalls.dart';
import 'package:beru_admin/UI/Login/InitalCheck.dart';
import 'package:beru_admin/UI/Theme/AdminPanelTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ServerCalls.controller = false; //true ? localhost : online
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthService())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: adminPanelTheme,
        home: InitalCheck(),
        onGenerateRoute: (settings) => pageTransitionAdminBeru(settings),
      ),
    );
  }
}
