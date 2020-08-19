import 'dart:convert';

import 'package:beru_admin/DataStructure/Sections.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServerCalls {
  static bool controller = true;
  static String dns =
      controller ? "http://localhost:80" : "https://beru-server.herokuapp.com";
  static BaseOptions _options =
      BaseOptions(baseUrl: "$dns", connectTimeout: 10000);
  static Dio _client = Dio(_options);

  static Future<String> getToken() async {
    try {
      var user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        var token = await user.getIdToken(refresh: true);
        return "Bearer ${token.token}";
      } else {
        throw Exception("Admin Not login");
      }
    } catch (e) {
      print("Error from Get Token $e");
      throw e;
    }
  }

  static Future<List> serverGet(Sections section) async {
    try {
      Response res = await _client.get("/${section.string}/data",
          options: Options(headers: {"authorization": await getToken()}));
      return res.data['data'];
    } catch (e) {
      print("Error from serverTest $e ${e.toString()}");
      throw e;
    }
  }

  static Future<String> serverCreate(
      Map<String, dynamic> data, Sections section) async {
    try {
      Response res = await _client.post('/${section.string}/create',
          data: json.encode(data),
          options: Options(headers: {"authorization": await getToken()}));
      return res.data['data'];
    } catch (e) {
      print("Error from serverCreat $e ${e.toString()}");
      throw e;
    }
  }

  static Future<String> serverUpdate(
      Map<String, dynamic> data, String id, Sections section) async {
    try {
      Response res = await _client.put('/${section.string}/update/$id',
          data: json.encode(data),
          options: Options(headers: {"authorization": await getToken()}));
      return res.data['data'];
    } catch (e) {
      print("Error from serverCreat $e ${e.toString()}");
      throw e;
    }
  }

  static Future<String> serverUploadImg(
      FormData data, String id, Sections section) async {
    try {
      Response res = await _client.post('/${section.string}/uploadImg/$id',
          data: data,
          options: Options(headers: {"authorization": await getToken()}));
      return res.data['data'];
    } catch (e) {
      print("Error from serverUploadImg $e ${e.toString()}");
      throw e;
    }
  }

  static Future<String> serverVerifie(
      Sections section, String id, bool value) async {
    try {
      Response res = await _client.put('/${section.string}/verifie/$id',
          data: json.encode({'value': value}),
          options: Options(headers: {"authorization": await getToken()}));
      return res.data['data'];
    } catch (e) {
      print("Error from serverUploadImg $e ${e.toString()}");
      throw e;
    }
  }

  static Future<String> serverSallesToShow(String id, bool value) async {
    try {
      Response res = await _client.put('/${Sections.salles.string}/toShow/$id',
          data: json.encode({"value": !value}),
          options: Options(headers: {"authorization": await getToken()}));
      return res.data['data'];
    }on DioError catch(e){
      print("Error from serverUploadImg $e ${e.response.data}");
      throw e;
    }catch (e) {
      print("Error from serverUploadImg $e ${e.toString()}");
      throw e;
    }
  }

}
