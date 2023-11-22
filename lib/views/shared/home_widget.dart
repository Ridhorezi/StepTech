import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:step_tech/controllers/product_provider.dart';
import 'package:step_tech/models/sneaker_model.dart';
import 'package:step_tech/views/shared/appstyle.dart';
import 'package:step_tech/views/shared/new_shoes.dart';
import 'package:step_tech/views/shared/product_card.dart';
import 'package:step_tech/views/shared/reusable_text.dart';
import 'package:step_tech/views/ui/product_by_cat_page.dart';
import 'package:step_tech/views/ui/product_page.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
    required Future<List<Sneakers>> male,
    required this.tabIndex,
  }) : _male = male;
  final Future<List<Sneakers>> _male;
  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    var productNotifier = Provider.of<ProductNotifier>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 320,
          child: FutureBuilder<List<Sneakers>>(
            future: _male,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (snapshot.hasError) {
                String errorMessage = "Error retrieving the data";

                // Handle specific errors
                if (snapshot.error is SocketException) {
                  errorMessage = "No internet connection";
                } else if (snapshot.error is TimeoutException) {
                  errorMessage = "Connection timeout";
                } else {
                  errorMessage = "An unexpected error occurred";
                }

                return Center(
                  child: ReusableText(
                    text: errorMessage,
                    style: appstyle(18, Colors.black87, FontWeight.bold),
                  ),
                );
              } else {
                final male = snapshot.data;
                return ListView.builder(
                  itemCount: male!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                    final shoe = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        productNotifier.shoesSizes = shoe.sizes;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPage(
                              id: shoe.id,
                              category: shoe.category,
                            ),
                          ),
                        );
                      },
                      child: ProductCard(
                        // ignore: unnecessary_string_escapes
                        price: "\$${shoe.price}",
                        category: shoe.category,
                        id: shoe.id,
                        name: shoe.name,
                        image: shoe.imageUrl[0],
                      ),
                    );
                  }),
                );
              }
            },
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 25, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Latest Shoes",
                    style: appstyle(24, Colors.black, FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductByCat(
                            tabIndex: tabIndex,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          "Show All",
                          style: appstyle(20, Colors.grey.withOpacity(0.3),
                              FontWeight.w500),
                        ),
                        Icon(
                          AntDesign.caretright,
                          size: 19,
                          color: Colors.grey.withOpacity(0.3),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 98,
          child: FutureBuilder<List<Sneakers>>(
            future: _male,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (snapshot.hasError) {
                return Text("Error ${snapshot.error}");
              } else {
                final male = snapshot.data;
                return ListView.builder(
                  itemCount: male!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                    final shoe = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NewShoes(
                        imageUrl: shoe.imageUrl[1],
                      ),
                    );
                  }),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
