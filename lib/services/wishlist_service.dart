import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shamo_frontend/models/product_model.dart';
import 'package:shamo_frontend/models/user_model.dart';

class WishlistService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addWishlist(
      {required UserModel user, required ProductModel product}) async {
    try {
      firestore.collection('wishlists').add({
        'userId': user.id,
        'userName': user.name,
        'product': product.toJson(),
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      }).then((value) => print('Product Added to Wishllist.'));
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

  Future<bool?> checkWishlist(
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

 //   .get()
        //   .then((value) {
        // value.docs.forEach((element) {
        //   firestore.collection('wishlists').doc(element.id).get().then((value) {
        //     if (value.exists) {
        //       return true;
        //     }
        //   });
        // });
        // return true;