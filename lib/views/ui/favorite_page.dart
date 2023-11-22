// ignore_for_file: use_build_context_synchronously

// import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:step_tech/controllers/favorite_provider.dart';
import 'package:step_tech/controllers/auth_provider.dart';
import 'package:step_tech/views/shared/alert.dart';
import 'package:step_tech/views/shared/appstyle.dart';
import 'package:step_tech/views/shared/reusable_text.dart';
import 'package:step_tech/views/ui/nonuser_page.dart';

import 'main_screen.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<AuthNotifier>(context);

    var favoriteNotifier = Provider.of<FavoriteNotifier>(context, listen: true);
    favoriteNotifier.favorite;

    return authNotifier.loggeIn == false
        ? const NonUser()
        : Scaffold(
            backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
            body: FutureBuilder(
              future: favoriteNotifier.favorite,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  String errorMessage = "Error retrieving the data";

                  // Handle specific errors
                  if (snapshot.error is SocketException) {
                    errorMessage = "No internet connection";
                  } else if (snapshot.error is TimeoutException) {
                    errorMessage = "Connection timeout";
                  } else {
                    errorMessage =
                        "An unexpected error occurred ${snapshot.error}";
                  }

                  return Center(
                    child: ReusableText(
                      text: errorMessage,
                      style: appstyle(18, Colors.black87, FontWeight.bold),
                    ),
                  );
                } else {
                  final favoriteData = snapshot.data;

                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 47,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(),
                                  ),
                                );
                              },
                              child: const Icon(
                                AntDesign.arrowleft,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "My Favorites",
                              style:
                                  appstyle(36, Colors.black, FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.65,
                              child: favoriteData!.isEmpty
                                  ? Image.asset('assets/images/wishlist.png',
                                      fit: BoxFit.contain)
                                  : ListView.builder(
                                      itemCount: favoriteData.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final data = favoriteData[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.13,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.shade500,
                                                    spreadRadius: 5,
                                                    blurRadius: 0.3,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        child: Image.network(
                                                          data.favoriteItem
                                                              .imageUrl[0],
                                                          width: 70,
                                                          height: 70,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 12,
                                                          left: 20,
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              data.favoriteItem.name
                                                                          .length <=
                                                                      17
                                                                  ? data
                                                                      .favoriteItem
                                                                      .name
                                                                  : '${data.favoriteItem.name.substring(0, 17)}...',
                                                              style: appstyle(
                                                                12,
                                                                Colors.black,
                                                                FontWeight.bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              data.favoriteItem
                                                                  .category,
                                                              style: appstyle(
                                                                12,
                                                                Colors.grey,
                                                                FontWeight.w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  (data.favoriteItem.price
                                                                              .length <=
                                                                          12
                                                                      ? data
                                                                          .favoriteItem
                                                                          .price
                                                                      : '${data.favoriteItem.price.substring(0, 12)}...'),
                                                                  style:
                                                                      appstyle(
                                                                    12,
                                                                    Colors
                                                                        .black,
                                                                    FontWeight
                                                                        .w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        bool? confirmDelete =
                                                            await Alert
                                                                .showDeleteConfirmationDialog(
                                                          context,
                                                          data.favoriteItem
                                                              .name,
                                                        );

                                                        if (confirmDelete ==
                                                            true) {
                                                          // Hapus item
                                                          await favoriteNotifier
                                                              .deleteItem(
                                                                  data.id);
                                                          Alert.showSuccessSnackbar(
                                                              context,
                                                              "Item deleted successfully");
                                                          Navigator
                                                              .pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MainScreen(),
                                                            ),
                                                          );
                                                          setState(() {});
                                                        } else {
                                                          // Pembatalan penghapusan
                                                          Alert.showSnackbarCancel(
                                                              context,
                                                              "Item deletion canceled");
                                                        }
                                                      },
                                                      child: const Icon(
                                                        Ionicons
                                                            .md_heart_dislike,
                                                        color: Color.fromRGBO(
                                                            255, 30, 0, 1),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
  }
}
