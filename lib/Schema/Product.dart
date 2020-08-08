import 'package:beru_admin/Schema/BeruCategory.dart';
import 'package:beru_admin/Schema/Salles.dart';

class Product {
  String name;
  String description;
  String _id;
  bool inKg;
  BeruCategory category;
  int amount;
  bool hasImg;
  List<Salles> salles;
  Map<String, dynamic> toMap() {
    return {
      '_id': _id,
      "name": name,
      "description": description,
      'category': category?.toMap(),
      'inKg': inKg,
      'amount': amount
    };
  }

  Map<String, dynamic> toMapCreate() {
    return {
      "name": name,
      "description": description,
      'category': category.toMap(),
      'inKg': inKg,
      'amount': amount
    };
  }

  Product();

  Product.fromMap(Map<String, dynamic> temp) {
    this.hasImg = temp['hasImg'] ?? false;
    this._id = temp['_id'] ?? null;
    this.name = temp['name'] ?? null;
    this.description = temp['description'] ?? null;
    this.category = temp['category'] is String
        ? BeruCategory.fromMap({"_id": temp['category']})
        : BeruCategory.fromMap(temp['category']);
    this.inKg = temp['inKg'] ?? null;
    this.salles = temp['salles'] == null
        ? null
        : Salles.fromMapToListOfSalles(temp['salles']);
    this.amount = temp['amount'] ?? null;
  }

  String get id {
    return this._id;
  }

  set id(String id) {
    this._id = id;
  }
}
