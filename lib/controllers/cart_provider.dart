// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:step_tech/models/cart/get_products.dart';
import 'package:step_tech/services/cart_helper.dart';

class CartNotifier extends ChangeNotifier {
  final _cartBox = Hive.box('cart_box');

  late Future<List<Product>> _cartList;

  Future<List<Product>> get cart => _cartList;

  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }

  void decrement() {
    _counter--;
    notifyListeners();
  }

  void getCart() {
    _cartList = CartHelper().getCart();
  }

  Future<bool> addToCart(model) async {
    bool addedToCartSuccessfully = await CartHelper().addToCart(model);
    if (addedToCartSuccessfully) {
      getCart(); // Perbarui daftar cart
    }
    return addedToCartSuccessfully;
  }

  deleteItem(String id) async {
    await CartHelper().deleteItem(id);
  }

  int? _productIndex;
  int get productIndex => _productIndex ?? 0;
  set setProductIndex(int newState) {
    _productIndex = newState;
    notifyListeners();
  }

  List<Product> _checkout = [];
  List<Product> get checkout => _checkout;
  set setCheckout(List<Product> newState) {
    _checkout = newState;
    notifyListeners();
  }
}
