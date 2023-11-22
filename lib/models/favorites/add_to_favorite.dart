import 'dart:convert';

String addToFavoriteToJson(AddToFavorite data) => json.encode(data.toJson());

class AddToFavorite {
  String favoriteItem;

  AddToFavorite({
    required this.favoriteItem,
  });

  Map<String, dynamic> toJson() => {
        "favoriteItem": favoriteItem,
      };
}
