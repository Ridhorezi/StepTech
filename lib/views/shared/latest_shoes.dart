// ignore_for_file: camel_case_types

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:step_tech/controllers/product_provider.dart';
import 'package:step_tech/models/sneaker_model.dart';
import 'package:step_tech/views/shared/reusable_text.dart';
import 'package:step_tech/views/shared/stagger_tile.dart';
import 'package:step_tech/views/ui/product_page.dart';

import 'appstyle.dart';

class latestShoes extends StatelessWidget {
  const latestShoes({
    super.key,
    required Future<List<Sneakers>> male,
  }) : _male = male;

  final Future<List<Sneakers>> _male;

  @override
  Widget build(BuildContext context) {
    var productNotifier = Provider.of<ProductNotifier>(context);
    return FutureBuilder<List<Sneakers>>(
      future: _male,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError) {
          String errorMessage = "Error retrieving the data";

          // Handle specific errors
          if (snapshot.error is SocketException) {
            errorMessage = "No internet connection";
          } else if (snapshot.error is TimeoutException) {
            errorMessage = "Connection timeout";
          } else {
            errorMessage = "An unexpected error occurred ${snapshot.error}";
          }
          return Center(
            child: ReusableText(
              text: errorMessage,
              style: appstyle(
                18,
                Colors.black,
                FontWeight.w600,
              ),
            ),
          );
        } else {
          final male = snapshot.data;
          return StaggeredGridView.countBuilder(
            padding: EdgeInsets.zero,
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 16,
            itemCount: male!.length,
            scrollDirection: Axis.vertical,
            staggeredTileBuilder: (index) => StaggeredTile.extent(
              (index % 2 == 0) ? 1 : 1,
              (index % 4 == 1 || index % 4 == 3)
                  ? MediaQuery.of(context).size.height * 0.33
                  : MediaQuery.of(context).size.height * 0.33,
            ),
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
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: StaggerTile(
                    imageUrl: shoe.imageUrl[1],
                    name: shoe.name,
                    // ignore: unnecessary_string_escapes
                    price: "\$${shoe.price}",
                  ),
                ),
              );
            }),
          );
        }
      },
    );
  }
}
