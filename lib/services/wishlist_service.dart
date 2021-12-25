import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shamo_frontend/models/product_model.dart';
import 'package:shamo_frontend/models/user_model.dart';
import 'package:shamo_frontend/models/wishlist_model.dart';

class WishlistService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<WishlistModel>> getWishlistsByUserId({required int userId}) {
    try {
      return firestore
          .collection('wishlists')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot list) {
        var result = list.docs.map<WishlistModel>((DocumentSnapshot wishlist) {
          // print(wishlist.data());
          print('Ada data');

          return WishlistModel.fromJson(
              wishlist.data() as Map<String, dynamic>);
        }).toList();

        result.sort((WishlistModel a, WishlistModel b) =>
            a.createdAt.compareTo(b.createdAt));

        return result;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addWishlist(
      {required UserModel user, required ProductModel product}) async {
    try {
      firestore.collection('wishlists').add({
        'userId': user.id,
        'userName': user.name,
        'product': product.toJson(),
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      });
    } catch (e) {
      throw Exception('Failed Adding Product to Wishlist.');
    }
  }

  Future<void> deleteWishlist(
      {required UserModel user, required ProductModel product}) async {
    try {
      firestore
          .collection('wishlists')
          .where('userId', isEqualTo: user.id)
          .where('product.id', isEqualTo: product.id)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          firestore.collection('wishlists').doc(element.id).delete();
        });
      });
    } catch (e) {
      throw Exception('Failed Delete Product from Wishlist.');
    }
  }

  Future<bool> checkWishlist(
      {required UserModel user, required ProductModel product}) async {
    late bool isExist;
    try {
      await firestore
          .collection('wishlists')
          .where('userId', isEqualTo: user.id)
          .where('product.id', isEqualTo: product.id)
          .get()
          .then((value) {
        value.docs.isEmpty ? isExist = false : isExist = true;
      });
    } catch (e) {
      throw Exception('Something went wrong.');
    }
    return isExist;
  }
}
