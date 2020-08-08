import 'package:beru_admin/DataStructure/Sections.dart';
import 'package:beru_admin/Server/ServerCalls.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

showImage(bool has, Sections section, String id, BuildContext context) {
  if (has)
    return Image.network(
      "${ServerCalls.dns}/${section.string}/getImage/$id",
      height: context.percentHeight * 30,
      errorBuilder: (context, error, stackTrace) {
        print("Error from Load img $error");
        return "${error.toString()}".text.red200.bold.center.make();
      },
    );
  else
    return Offstage();
}
