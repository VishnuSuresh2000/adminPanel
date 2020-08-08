import 'dart:convert';
import 'dart:typed_data';
import 'package:beru_admin/DataStructure/Sections.dart';
import 'package:beru_admin/Server/ServerCalls.dart';
import 'package:beru_admin/UI/CommonFunctions/BeruAlertWithCallBack.dart';
import 'package:beru_admin/UI/CommonFunctions/ErrorAlert.dart';
import 'package:beru_admin/UI/Home/AdminHome.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

uploadImageToServer(String id, Sections sections, BuildContext context) async {
  try {
    if (kIsWeb) {
      // String filename;
      html.InputElement uploadInput = html.FileUploadInputElement();
      uploadInput.multiple = true;
      uploadInput.draggable = true;
      uploadInput.click();
      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        final file = files[0];
        // filename = file.name;
        final reader = new html.FileReader();

        reader.onLoadEnd.listen((e) async {
          Uint8List bytesData =
              Base64Decoder().convert(reader.result.toString().split(",").last);
          // List<int> selectedFile = bytesData;
          FormData data = FormData.fromMap({
            'imgUrl': MultipartFile.fromBytes(bytesData, filename: "$id.png")
          });
          var res = await ServerCalls.serverUploadImg(data, id, sections);
          alertWithCallBack(
              cakllback: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AdminHome.route, (route) => false);
              },
              callBackName: "Back",
              content: res.toString(),
              context: context);
        });
        reader.readAsDataUrl(file);
      });
    }
  } catch (e) {
    print("Error from uploadImageToServe $e");
    errorAlert(context, e.toString());
  }
}
