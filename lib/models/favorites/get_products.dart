import 'dart:convert';

List<GetFavorite> getFavoriteFromJson(String str) => List<GetFavorite>.from(
    json.decode(str).map((x) => GetFavorite.fromJson(x)));

class GetFavorite {
  List<Product> products;

  GetFavorite({
    required this.products,
  });

  factory GetFavorite.fromJson(Map<String, dynamic> json) => GetFavorite(
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );
}

class Product {
  ProductItem favoriteItem;
  String id;

  Product({
    required this.favoriteItem,
    required this.id,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        favoriteItem: ProductItem.fromJson(json["favoriteItem"]),
        id: json["_id"],
      );
}

class ProductItem {
  String id;
  String name;
  String category;
  List<String> imageUrl;
  String price;

  ProductItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
        id: json["_id"],
        name: json["name"],
        category: json["category"],
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
        price: json["price"],
      );
}
