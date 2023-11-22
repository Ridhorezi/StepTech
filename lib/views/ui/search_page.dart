import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:step_tech/controllers/product_provider.dart';
import 'package:step_tech/views/shared/appstyle.dart';
import 'package:step_tech/views/shared/custom_field.dart';
import 'package:step_tech/views/shared/reusable_text.dart';
import 'package:step_tech/views/ui/product_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var productNotifier = Provider.of<ProductNotifier>(context);

    void clearSearch() {
      search.clear();
      productNotifier.searchProduct('');
      setState(() {});
    }

    void onSearchTextChanged(String value) {
      if (value.isNotEmpty) {
        productNotifier.searchProduct(value);
      } else {
        productNotifier.searchProduct('');
        clearSearch(); // Tambahkan ini untuk membersihkan daftar pencarian saat teks kosong
      }
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        elevation: 0,
        title: CustomField(
          hintText: "Search for a product",
          controller: search,
          onChanged: (value) {
            onSearchTextChanged(value);
          },
          prefixIcon: GestureDetector(
            onTap: () {},
            child: const Icon(
              AntDesign.camera,
              color: Colors.black,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: const Icon(
              AntDesign.search1,
              color: Colors.black,
            ),
          ),
          clearIcon: GestureDetector(
            onTap: () {
              clearSearch();
            },
            child: search.text.isNotEmpty
                ? const Icon(
                    AntDesign.close,
                    color: Colors.red,
                  )
                : const SizedBox(),
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      body: search.text.isEmpty
          ? Container(
              height: 600,
              margin: const EdgeInsets.only(right: 40),
              child: Image.asset('assets/images/steptech-search.png'),
            )
          : FutureBuilder(
              future: productNotifier.search,
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
                } else if (snapshot.data!.isEmpty) {
                  String errorMessage = "Ups! product not found";
                  return Center(
                    child: ReusableText(
                      text: errorMessage,
                      style: appstyle(18, Colors.black87, FontWeight.bold),
                    ),
                  );
                } else {
                  final shoe = snapshot.data;
                  return ListView.builder(
                    itemCount: shoe!.length,
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
                          padding: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            child: Container(
                              height: 100,
                              width: 325,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500,
                                    spreadRadius: 5,
                                    blurRadius: 0.3,
                                    offset: const Offset(0, 1),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: CachedNetworkImage(
                                      imageUrl: shoe.imageUrl[0],
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ReusableText(
                                          text: shoe.name,
                                          style: appstyle(
                                            16,
                                            Colors.black,
                                            FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        ReusableText(
                                          text: shoe.category,
                                          style: appstyle(
                                            13,
                                            Colors.black,
                                            FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        ReusableText(
                                          text: "\$ ${shoe.price}",
                                          style: appstyle(
                                            13,
                                            Colors.black,
                                            FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }
              },
            ),
    );
  }
}
