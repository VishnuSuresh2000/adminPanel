import 'package:beru_admin/DataStructure/Sections.dart';
import 'package:flutter/cupertino.dart';
import 'package:universal_html/prefer_universal/js.dart';

class BlocForHome extends ChangeNotifier {
  Sections _section = Sections.category;

  Sections get section => _section;

  set section(Sections section) {
    _section = section;
    notifyListeners();
  }
}
