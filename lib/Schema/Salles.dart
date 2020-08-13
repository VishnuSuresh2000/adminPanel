import 'package:beru_admin/Schema/user.dart';

class Salles {
  String _id;
  User seller;
  User farmer;
  int count;

  String get id {
    return this._id;
  }

  Salles();

  Salles.fromMap(Map<String, dynamic> temp) {
    this._id = temp['_id'] ?? null;
    if (temp['farmer_id'] != null) {
      
      if (temp['farmer_id'] is String) {
         print("For test of farmer ${temp['farmer_id']}");
        this.farmer = User.hasId(temp['farmer_id']);
      } else {
        this.farmer = User.fromMap(temp['farmer_id']);
      }
    }
    if (temp['seller_id'] != null) {
      
      if (temp['seller_id'] is String) {
        print("For test of seller ${temp['seller_id']}");
        this.seller = User.hasId(temp['seller_id']);
      } else {
        this.seller = User.fromMap(temp['seller_id']);
      }
    }
    this.count = temp['count'];
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': _id,
      'farmer_id': farmer.toMap(),
      'seller_id': seller.toMap(),
      'count': count,
    };
  }

  static List<Salles> fromMapToListOfSalles(List<dynamic> data) {
    return data.map((e) => Salles.fromMap(e)).toList();
  }
}
