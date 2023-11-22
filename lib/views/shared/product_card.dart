// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import 'package:step_tech/controllers/favorite_provider.dart';
import 'package:step_tech/controllers/auth_provider.dart';
import 'package:step_tech/models/favorites/add_to_favorite.dart';
import 'package:step_tech/views/shared/appstyle.dart';
import 'package:step_tech/views/shared/reusable_text.dart';
import 'package:step_tech/views/ui/auth/login.dart';
import 'package:step_tech/views/ui/favorite_page.dart';
import 'package:step_tech/views/shared/alert.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.price,
    required this.category,
    required this.id,
    required this.name,
    required this.image,
  });

  final String price;
  final String category;
  final String id;
  final String name;
  final String image;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<AuthNotifier>(context);
    var favoriteNotifier = Provider.of<FavoriteNotifier>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 20),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        child: Container(
          height: 325,
          width: 230,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: 1,
                blurRadius: 0.6,
                offset: Offset(1, 1),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.image),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: GestureDetector(
                      onTap: () async {
                        if (authNotifier.loggeIn == true) {
                          if (favoriteNotifier.ids.contains(widget.id)) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FavoritePage(),
                              ),
                            );
                          } else {
                            AddToFavorite model =
                                AddToFavorite(favoriteItem: widget.id);

                            bool addedSuccessfully =
                                await favoriteNotifier.addToFavorite(model);

                            if (addedSuccessfully) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FavoritePage(),
                                ),
                              );
                              Alert.showSuccessSnackbar(
                                  context, "Product added to favorite");
                            } else {
                              Alert.showErrorSnackbar(
                                  context, "Failed add product to favorite");
                            }
                          }
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      },
                      child: favoriteNotifier.ids.contains(widget.id)
                          ? const Icon(
                              AntDesign.heart,
                              color: Color.fromRGBO(255, 30, 0, 1),
                            )
                          : const Icon(AntDesign.hearto),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: widget.name,
                      style: appstyleWithHt(
                        28,
                        Colors.black,
                        FontWeight.bold,
                        1.1,
                      ),
                    ),
                    ReusableText(
                      text: widget.category,
                      style: appstyleWithHt(
                        18,
                        Colors.grey,
                        FontWeight.bold,
                        1.5,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ReusableText(
                        text: widget.price,
                        style: appstyle(25, Colors.black, FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 11,
                          ),
                          ReusableText(
                              text: "Show Details",
                              style:
                                  appstyle(12, Colors.blue, FontWeight.w700)),
                          const Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: SizedBox(
                              width: 10,
                              height: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
