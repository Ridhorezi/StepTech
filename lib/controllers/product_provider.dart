import 'package:flutter/material.dart';
import 'package:step_tech/models/sneaker_model.dart';
import 'package:step_tech/services/sneaker_helper.dart';

class ProductNotifier extends ChangeNotifier {
  List<dynamic> _shoeSizes = [];

  List<String> _sizes = [];

  int _activepage = 0;

  int get activepage => _activepage;

  List<dynamic> get shoeSizes => _shoeSizes;

  List<String> get sizes => _sizes;

  late Future<List<Sneakers>> male;

  late Future<List<Sneakers>> female;

  late Future<List<Sneakers>> kids;

  late Future<List<Sneakers>> search;

  late Future<Sneakers> sneaker;

  set activePage(int newIndex) {
    _activepage = newIndex;
    notifyListeners();
  }

  set shoesSizes(List<dynamic> newSizes) {
    _shoeSizes = newSizes;
    notifyListeners();
  }

  set sizes(List<String> newSizes) {
    _sizes = newSizes;
    notifyListeners();
  }

  void toggleCheck(int index) {
    for (int i = 0; i < _shoeSizes.length; i++) {
      if (i == index) {
        _shoeSizes[i]['isSelected'] = !_shoeSizes[i]['isSelected'];
      }
    }
    notifyListeners();
  }

  void getMale() {
    male = Helper().getMaleSneakers();
  }

  void getFemale() {
    female = Helper().getFemaleSneakers();
  }

  void getKids() {
    kids = Helper().getKidsSneakers();
  }

  void searchProduct(String searchQuery) async {
    search = Helper().search(searchQuery);
    await search; // Menunggu hasil pencarian selesai
    notifyListeners();
  }

  void getShoes(String category, String id) {
    if (category == "Men's Running") {
      sneaker = Helper().getMaleSneakersById(id);
    } else if (category == "Women's Running") {
      sneaker = Helper().getFemaleSneakersById(id);
    } else {
      sneaker = Helper().getKidsSneakersById(id);
    }
  }
}
