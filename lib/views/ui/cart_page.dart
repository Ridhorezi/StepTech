// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_tech/controllers/cart_provider.dart';
import 'package:step_tech/controllers/payment_provider.dart';
import 'package:step_tech/models/orders/orders_req.dart';
import 'package:step_tech/services/payment_helper.dart';
import 'package:step_tech/views/shared/alert.dart';
import 'package:step_tech/views/shared/appstyle.dart';
import 'package:step_tech/views/shared/checkout_btn.dart';
import 'package:step_tech/views/shared/reusable_text.dart';
import 'package:step_tech/views/ui/main_screen.dart';
import 'package:step_tech/views/ui/payments/payment_webview.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    var cartNotifier = Provider.of<CartNotifier>(context);
    cartNotifier.getCart();
    var paymentNotifier = Provider.of<PaymentNotifier>(context);
    return paymentNotifier.paymentUrl.contains('https')
        ? const PaymentWebView()
        : Scaffold(
            backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
            body: FutureBuilder(
              future: cartNotifier.cart,
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
                  final cartData = snapshot.data;
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
                              "My Cart",
                              style:
                                  appstyle(36, Colors.black, FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.65,
                              child: cartData!.isEmpty
                                  ? Image.asset('assets/images/cart.png',
                                      fit: BoxFit.contain)
                                  : ListView.builder(
                                      itemCount: cartData.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final data = cartData[index];
                                        return GestureDetector(
                                          onTap: () {
                                            cartNotifier.setProductIndex =
                                                index;
                                            cartNotifier.checkout
                                                .insert(0, data);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12)),
                                              child: Slidable(
                                                key: const ValueKey(0),
                                                endActionPane: ActionPane(
                                                  motion: const ScrollMotion(),
                                                  children: [
                                                    SlidableAction(
                                                      flex: 1,
                                                      onPressed: doNothing,
                                                      backgroundColor:
                                                          const Color.fromRGBO(
                                                              255, 30, 0, 1),
                                                      foregroundColor:
                                                          Colors.white,
                                                      icon: Icons.delete,
                                                      label: 'Delete',
                                                    ),
                                                  ],
                                                ),
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
                                                        color: Colors
                                                            .grey.shade500,
                                                        spreadRadius: 5,
                                                        blurRadius: 0.3,
                                                        offset:
                                                            const Offset(0, 1),
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
                                                          Stack(
                                                            clipBehavior:
                                                                Clip.none,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(12),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: data
                                                                      .cartItem
                                                                      .imageUrl[0],
                                                                  width: 70,
                                                                  height: 70,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),

                                                              // option checkout
                                                              Positioned(
                                                                // bottom: -7,
                                                                top: -4,
                                                                right: 63,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      () async {},
                                                                  child:
                                                                      SizedBox(
                                                                    height: 30,
                                                                    width: 30,
                                                                    child: Icon(
                                                                      cartNotifier.productIndex ==
                                                                              index
                                                                          ? Feather
                                                                              .check_square
                                                                          : Feather
                                                                              .square,
                                                                      size: 13,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),

                                                              // delete
                                                              Positioned(
                                                                bottom: -7,
                                                                right: 63,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    bool?
                                                                        confirmDelete =
                                                                        await Alert
                                                                            .showDeleteConfirmationDialog(
                                                                      context,
                                                                      data.cartItem
                                                                          .name,
                                                                    );

                                                                    if (confirmDelete ==
                                                                        true) {
                                                                      // Hapus item
                                                                      await cartNotifier
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
                                                                      setState(
                                                                          () {});
                                                                    } else {
                                                                      // Pembatalan penghapusan
                                                                      Alert.showSnackbarCancel(
                                                                          context,
                                                                          "Item deletion canceled");
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 30,
                                                                    height: 32,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topRight:
                                                                            Radius.circular(
                                                                          12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        const Icon(
                                                                      AntDesign
                                                                          .delete,
                                                                      size: 13,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 12,
                                                              left: 25,
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
                                                                  data.cartItem.name
                                                                              .length <=
                                                                          17
                                                                      ? data
                                                                          .cartItem
                                                                          .name
                                                                      : '${data.cartItem.name.substring(0, 17)}...',
                                                                  style:
                                                                      appstyle(
                                                                    12,
                                                                    Colors
                                                                        .black,
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  data.cartItem
                                                                      .category,
                                                                  style: appstyle(
                                                                      12,
                                                                      Colors
                                                                          .grey,
                                                                      FontWeight
                                                                          .w600),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      (data.cartItem.price.length <=
                                                                              12
                                                                          ? data
                                                                              .cartItem
                                                                              .price
                                                                          : '${data.cartItem.price.substring(0, 12)}...'),
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
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                // Row(
                                                                //   children: [
                                                                //     Text(
                                                                //       "Quantity",
                                                                //       style: appstyle(
                                                                //           12,
                                                                //           Colors
                                                                //               .grey,
                                                                //           FontWeight
                                                                //               .w600),
                                                                //     ),
                                                                //     const SizedBox(
                                                                //       width: 15,
                                                                //     ),
                                                                //     Text(
                                                                //       "1", // Memeriksa apakah data['sizes'] null
                                                                //       style:
                                                                //           appstyle(
                                                                //         12,
                                                                //         Colors
                                                                //             .black,
                                                                //         FontWeight
                                                                //             .bold
                                                                //       ),
                                                                //     ),
                                                                //   ],
                                                                // ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                    16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                        cartNotifier.checkout.isNotEmpty
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: CheckoutButton(
                                  onTap: () async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String? userId =
                                        prefs.getString('userId') ?? "";
                                    Order model = Order(
                                      userId: userId,
                                      cartItems: [
                                        CartItem(
                                          name: cartNotifier
                                              .checkout[0].cartItem.name,
                                          id: cartNotifier
                                              .checkout[0].cartItem.id,
                                          price: cartNotifier
                                              .checkout[0].cartItem.price,
                                          cartQuantity: 1, // hardcode
                                        )
                                      ],
                                    );
                                    PaymentHelper().payment(model).then(
                                      (value) {
                                        paymentNotifier.setPaymentUrl = value;
                                        debugPrint(paymentNotifier.paymentUrl);
                                      },
                                    );
                                  },
                                  label: "Proceed to Checkout",
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  );
                }
              },
            ),
          );
  }

  void doNothing(BuildContext context) {}
}
