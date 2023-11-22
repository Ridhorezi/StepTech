import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:step_tech/models/orders/orders_res.dart';
import 'package:step_tech/services/cart_helper.dart';
import 'package:step_tech/views/shared/appstyle.dart';
import 'package:step_tech/views/shared/reusable_text.dart';

class ProcessOrders extends StatefulWidget {
  const ProcessOrders({super.key});

  @override
  State<ProcessOrders> createState() => _ProcessOrdersState();
}

class _ProcessOrdersState extends State<ProcessOrders> {
  late Future<List<PaidOrders>> _orders;

  @override
  void initState() {
    super.initState();
    _orders = CartHelper().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        elevation: 0,
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 825,
          width: 400,
          color: const Color.fromRGBO(238, 238, 238, 1),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ReusableText(
                    text: "My Orders",
                    style: appstyle(
                      36,
                      Colors.black,
                      FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 600,
                  width: 400,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    color: Colors.white,
                  ),
                  child: FutureBuilder<List<PaidOrders>>(
                    future: _orders,
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
                            style:
                                appstyle(18, Colors.black87, FontWeight.bold),
                          ),
                        );
                      } else {
                        final orders = snapshot.data;
                        return ListView.builder(
                          itemCount: orders!.length,
                          itemBuilder: ((context, index) {
                            var order = orders[index];

                            return Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.network(
                                            order.productId.imageUrl[0],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 7),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ReusableText(
                                              text: order.productId.name,
                                              style: appstyle(
                                                12,
                                                Colors.black87,
                                                FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              child: FittedBox(
                                                child: Text(
                                                  order.productId.title
                                                              .length <=
                                                          20
                                                      ? order.productId.title
                                                      : '${order.productId.title.substring(0, 20)}...',
                                                  style: appstyle(
                                                    10,
                                                    Colors.black,
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            ReusableText(
                                              text:
                                                  "\$ ${order.productId.price}",
                                              style: appstyle(
                                                12,
                                                Colors.black87,
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                        child: ReusableText(
                                          text:
                                              order.paymentStatus.toUpperCase(),
                                          style: appstyle(
                                            12,
                                            Colors.white,
                                            FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              MaterialCommunityIcons
                                                  .truck_fast_outline,
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            ReusableText(
                                              text: order.deliveryStatus
                                                  .toUpperCase(),
                                              style: appstyle(
                                                12,
                                                Colors.black,
                                                FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
