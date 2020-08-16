import 'package:beru_admin/Schema/user.dart';

class Salles {
  String _id;
  User seller;
  User farmer;
  int count;
  bool toShow;

  String get id {
    return this._id;
  }

  Salles();

  Salles.fromMap(Map<String, dynamic> temp) {
    this._id = temp['_id'];
    if (temp['farmer_id'] is Map) {
      this.farmer = User.fromMap(temp['farmer_id']);
    } else if (temp['farmer_id'] is String) {
      this.farmer = User.fromMap({'_id': temp['farmer_id']});
    }
    if (temp['seller_id'] is Map) {
      this.seller = User.fromMap(temp['seller_id']);
    } else if (temp['seller_id'] is String) {
      this.seller = User.fromMap({'_id': temp['seller_id']});
    }
    this.count = temp['count'];
    this.toShow = temp['toShow'] ?? false;
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
