import 'package:beru_admin/UI/Home/AdminHome.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

pageTransitionAdminBeru(RouteSettings settings) {
  switch (settings.name) {
    case AdminHome.route:
      return defalutTransition(AdminHome(), settings);
      break;

  }
}

defalutTransition(Widget page, RouteSettings settings) {
  return PageTransition(
      child: page,
      type: PageTransitionType.leftToRightWithFade,
      settings: settings);
}
