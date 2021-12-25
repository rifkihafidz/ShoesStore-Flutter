import 'package:shamo_frontend/models/product_model.dart';

class WishlistModel {
  late int userId;
  late String userName;
  late ProductModel product;
  late DateTime createdAt;
  late DateTime updatedAt;

  WishlistModel({
    required this.userId,
    required this.userName,
    required this.product,
    required this.createdAt,
    required this.updatedAt,
  });

  WishlistModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    product = ProductModel.fromJson(json['product']);
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'product': product.toJson(),
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }
}
