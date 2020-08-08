import 'package:flutter/material.dart';

void alertWithCallBack(
    {String content,
    String callBackName,
    Function cakllback,
    BuildContext context}) {
  showDialog(
      context: context,
      child: AlertDialog(
        title: Text(
          "$content",
        ),
        actions: [
          RaisedButton(
            onPressed: cakllback,
            child: Text(
              "$callBackName",
            ),
          )
        ],
      ));
}
