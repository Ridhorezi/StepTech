// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:step_tech/controllers/cart_provider.dart';
import 'package:step_tech/controllers/favorite_provider.dart';
import 'package:step_tech/controllers/auth_provider.dart';
import 'package:step_tech/controllers/product_provider.dart';
import 'package:step_tech/models/cart/add_to_cart.dart';
import 'package:step_tech/models/favorites/add_to_favorite.dart';
import 'package:step_tech/models/sneaker_model.dart';
import 'package:step_tech/views/shared/appstyle.dart';
import 'package:step_tech/views/shared/checkout_btn.dart';
import 'package:step_tech/views/ui/auth/login.dart';
import 'package:step_tech/views/ui/cart_page.dart';
import 'package:step_tech/views/ui/favorite_page.dart';
import 'package:step_tech/views/shared/alert.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.id, required this.category});

  final String id;
  final String category;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<AuthNotifier>(context);

    var productNotifier = Provider.of<ProductNotifier>(context, listen: true);
    productNotifier.getShoes(widget.category, widget.id);

    var favoriteNotifier = Provider.of<FavoriteNotifier>(context, listen: true);
    favoriteNotifier.favorite;

    var cartNotifier = Provider.of<CartNotifier>(context, listen: true);

    return Scaffold(
      body: FutureBuilder<Sneakers>(
        future: productNotifier.sneaker,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            String errorMessage = "Error get your data";
            // Handle specific errors
            if (snapshot.error is SocketException) {
              errorMessage = "No internet connection";
            } else if (snapshot.error is TimeoutException) {
              errorMessage = "Connection timeout";
            } else {
              errorMessage = "An unexpected error occurred ${snapshot.error}";
            }
            return Center(
              child: Text(errorMessage),
            );
          } else {
            final sneaker = snapshot.data;
            return Consumer<ProductNotifier>(
              builder: (context, productNotifier, child) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      leadingWidth: 0,
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                // productNotifier.shoeSizes.clear();
                              },
                              child: const Icon(
                                AntDesign.arrowleft,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (authNotifier.loggeIn == true) {
                                  if (favoriteNotifier.ids
                                      .contains(sneaker.id)) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const FavoritePage(),
                                      ),
                                    );
                                  } else {
                                    AddToFavorite model =
                                        AddToFavorite(favoriteItem: sneaker.id);

                                    bool addedSuccessfully =
                                        await favoriteNotifier
                                            .addToFavorite(model);

                                    if (addedSuccessfully) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const FavoritePage(),
                                        ),
                                      );
                                      Alert.showSuccessSnackbar(
                                          context, "Product added to favorite");
                                    } else {
                                      Alert.showErrorSnackbar(context,
                                          "Failed add product to favorite");
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
                              child: favoriteNotifier.ids.contains(sneaker!.id)
                                  ? const Icon(
                                      AntDesign.heart,
                                      color: Color.fromRGBO(255, 30, 0, 1),
                                    )
                                  : const Icon(AntDesign.hearto,
                                      color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      pinned: true,
                      snap: false,
                      floating: true,
                      backgroundColor: Colors.transparent,
                      expandedHeight: MediaQuery.of(context).size.height,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width,
                              child: PageView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: sneaker.imageUrl.length,
                                controller: pageController,
                                onPageChanged: (page) {
                                  productNotifier.activePage = page;
                                },
                                itemBuilder: (context, int index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.38,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.grey.shade300,
                                        child: CachedNetworkImage(
                                          imageUrl: sneaker.imageUrl[index],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        left: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List<Widget>.generate(
                                            sneaker.imageUrl.length,
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 4,
                                              ),
                                              child: CircleAvatar(
                                                radius: 5,
                                                backgroundColor: productNotifier
                                                            .activepage !=
                                                        index
                                                    ? Colors.grey
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.70,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Visibility(
                                                      visible: sneaker
                                                              .name.length >
                                                          17, // Tampilkan teks hanya jika lebih dari 17 karakter
                                                      child: const Text(
                                                        "Scroll name to left, if too long !",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height:
                                                            5), // Tambahkan margin ke bawah di sini
                                                    SizedBox(
                                                      height:
                                                          50, // Tentukan ketinggian yang sesuai
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                          sneaker.name,
                                                          style: appstyle(
                                                            35,
                                                            Colors.black,
                                                            FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Category :",
                                                      style: appstyle(
                                                        15,
                                                        Colors.grey,
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 40,
                                                    ),
                                                    Text(
                                                      sneaker.category,
                                                      style: appstyle(
                                                        15,
                                                        Colors.black,
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Price :",
                                                      style: appstyle(
                                                        15,
                                                        Colors.grey,
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 40,
                                                    ),
                                                    Text(
                                                      // ignore: unnecessary_string_escapes
                                                      "\$${sneaker.price}",
                                                      style: appstyle(
                                                        25,
                                                        Colors.black,
                                                        FontWeight.w600,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Select sizes :",
                                                          style: appstyle(
                                                              15,
                                                              Colors.grey,
                                                              FontWeight.w600),
                                                        ),
                                                        const SizedBox(
                                                          width: 75,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    SizedBox(
                                                      height: 40,
                                                      child: ListView.builder(
                                                        itemCount:
                                                            productNotifier
                                                                .shoeSizes
                                                                .length,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final sizes =
                                                              productNotifier
                                                                      .shoeSizes[
                                                                  index];

                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 8.0,
                                                            ),
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .contain,
                                                              child: ChoiceChip(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              60),
                                                                  side:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1,
                                                                    style: BorderStyle
                                                                        .solid,
                                                                  ),
                                                                ),
                                                                disabledColor:
                                                                    Colors
                                                                        .white,
                                                                label: Text(
                                                                  sizes['size'],
                                                                  style:
                                                                      appstyle(
                                                                    18,
                                                                    sizes['isSelected']
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    FontWeight
                                                                        .w500,
                                                                  ),
                                                                ),
                                                                selectedColor:
                                                                    Colors
                                                                        .black,
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                                selected: sizes[
                                                                    'isSelected'],
                                                                onSelected:
                                                                    (newState) {
                                                                  if (productNotifier
                                                                      .sizes
                                                                      .contains(
                                                                          sizes[
                                                                              'size'])) {
                                                                    productNotifier
                                                                        .sizes
                                                                        .remove(
                                                                            sizes['size']);
                                                                  } else {
                                                                    productNotifier
                                                                        .sizes
                                                                        .add(sizes[
                                                                            'size']);
                                                                  }
                                                                  // ignore: avoid_print
                                                                  print(productNotifier
                                                                      .sizes);
                                                                  productNotifier
                                                                      .toggleCheck(
                                                                          index);
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Divider(
                                                  indent: 10,
                                                  endIndent: 10,
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Text(
                                                    sneaker.title,
                                                    maxLines: 2,
                                                    style: appstyle(
                                                      26,
                                                      Colors.black,
                                                      FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  sneaker.description,
                                                  textAlign: TextAlign.justify,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 4,
                                                  style: appstyle(
                                                    12,
                                                    Colors.black,
                                                    FontWeight.normal,
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 12),
                                                    child: CheckoutButton(
                                                      onTap: () async {
                                                        if (authNotifier
                                                                .loggeIn ==
                                                            true) {
                                                          AddToCart model =
                                                              AddToCart(
                                                            cartItem:
                                                                sneaker.id,
                                                            quantity: 1,
                                                          );

                                                          bool
                                                              addedToCartSuccessfully =
                                                              await cartNotifier
                                                                  .addToCart(
                                                                      model);

                                                          if (addedToCartSuccessfully) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const CartPage(),
                                                              ),
                                                            );

                                                            Alert.showSuccessSnackbar(
                                                                context,
                                                                "Product added to cart");
                                                          } else {
                                                            Alert.showErrorSnackbar(
                                                                context,
                                                                "Failed add product to cart");
                                                          }

                                                          productNotifier.sizes
                                                              .clear();
                                                        } else {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const LoginPage(),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      label: "Add to Cart",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
