// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:step_tech/models/favorites/get_products.dart';
import 'package:step_tech/services/Favorite_helper.dart';

class FavoriteNotifier extends ChangeNotifier {
  final _favoriteBox = Hive.box('fav_box');

  late Future<List<Product>> _favoriteList;

  Future<List<Product>> get favorite => _favoriteList;

  late List<String> _ids = [];

  List<String> get ids => _ids;

  // Constructor untuk menginisialisasi _ids saat objek dibuat
  FavoriteNotifier() {
    getFavorite();
  }

  void getFavorite() async {
    _favoriteList = FavoriteHelper().getFavorite();
    // Pastikan untuk menggunakan await untuk menunggu pemanggilan selesai
    List<Product> list = await FavoriteHelper().getFavorite();

    _ids = list.map((product) => product.favoriteItem.id).toList();
    // Notifikasi perubahan setelah mendapatkan data
    notifyListeners();
  }

  Future<bool> addToFavorite(model) async {
    bool addedSuccessfully = await FavoriteHelper().addToFavorite(model);

    if (addedSuccessfully) {
      getFavorite(); // Perbarui daftar favorit
    }
    return addedSuccessfully; // Kembalikan hasil async
  }

  deleteItem(String id) async {
    await FavoriteHelper().deleteItem(id);
    getFavorite(); // Perbarui daftar favorit
  }
}
