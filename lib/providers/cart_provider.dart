import 'package:flutter/cupertino.dart';
import 'package:shamo_frontend/models/cart_model.dart';
import 'package:shamo_frontend/models/product_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _carts = [];

  List<CartModel> get carts => _carts;

  set carts(List<CartModel> carts) {
    _carts = carts;
    notifyListeners();
  }

  // Cek apakah product ada di dalam cart
  productExist(ProductModel product) {
    if (_carts.indexWhere((element) => element.product.id == product.id) ==
        -1) {
      // Product tidak ada di cart
      return false;
    } else {
      // Product ada di cart
      return true;
    }
  }

  addCart(ProductModel product) {
    if (productExist(product)) {
      // Jika product ada di cart, tambahkan quantity
      int index =
          _carts.indexWhere((element) => element.product.id == product.id);
      _carts[index].quantity += 1;
    } else {
      // Jika product tidak ada di cart, tambahkan product ke cart
      _carts.add(
        CartModel(
          id: _carts.length,
          product: product,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  removeCart(int id) {
    _carts.removeAt(id);
    notifyListeners();
  }

  addQuantity(int id) {
    _carts[id].quantity = _carts[id].quantity + 1;
    notifyListeners();
  }

  removeQuantity(int id) {
    _carts[id].quantity = _carts[id].quantity - 1;

    if (_carts[id].quantity == 0) {
      // Jika quantity product di cart sudah 0, remove product dari cart
      _carts.removeAt(id);
    }
    notifyListeners();
  }

  totalItems() {
    int total = 0;
    for (var item in _carts) {
      total += item.quantity;
    }
    return total;
  }

  totalPrice() {
    double total = 0;
    for (var item in _carts) {
      total += (item.quantity * item.product.price!);
    }
    return total;
  }
}
