// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:step_tech/controllers/auth_provider.dart';
import 'package:step_tech/controllers/profile_provider.dart';
import 'package:step_tech/models/auth/profile_model.dart';
import 'package:step_tech/services/auth_helper.dart';
import 'package:step_tech/views/shared/alert.dart';

import 'package:step_tech/views/shared/appstyle.dart';
import 'package:step_tech/views/shared/reusable_text.dart';
import 'package:step_tech/views/shared/tiles_widget.dart';
import 'package:step_tech/views/ui/auth/login.dart';
import 'package:step_tech/views/ui/cart_page.dart';
import 'package:step_tech/views/ui/favorite_page.dart';
import 'package:step_tech/views/ui/nonuser_page.dart';
import 'package:step_tech/views/ui/orders/order.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController locationController;
  late TextEditingController passwordController;
  late TextEditingController emailController;
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    locationController = TextEditingController();
    passwordController = TextEditingController();
    emailController = TextEditingController();
    usernameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<AuthNotifier>(context);
    var profileNotifier = Provider.of<ProfileNotifier>(context);

    return authNotifier.loggeIn == false
        ? const NonUser()
        : Scaffold(
            backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 125,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(238, 238, 238, 1),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 70, 16, 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      height: 35,
                                      width: 35,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/steptech-profile.jpg'),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    FutureBuilder(
                                      future: AuthHelper().getProfile(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator
                                                .adaptive(),
                                          );
                                        } else if (snapshot.hasError) {
                                          String errorMessage =
                                              "Error get your data";
                                          // Handle specific errors
                                          if (snapshot.error
                                              is SocketException) {
                                            errorMessage =
                                                "No internet connection";
                                          } else if (snapshot.error
                                              is TimeoutException) {
                                            errorMessage = "Connection timeout";
                                          } else {
                                            errorMessage =
                                                "An unexpected error occurred ${snapshot.error}";
                                          }

                                          return Center(
                                            child: ReusableText(
                                              text: errorMessage.length <= 20
                                                  ? errorMessage
                                                  : '${errorMessage.substring(0, 20)}...',
                                              style: appstyle(
                                                18,
                                                Colors.black,
                                                FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        } else {
                                          final userData = snapshot.data;
                                          // Set nilai default pada controller
                                          locationController.text =
                                              userData?.location ?? "";
                                          passwordController.text =
                                              userData?.password ?? "";
                                          emailController.text =
                                              userData?.email ?? "";
                                          usernameController.text =
                                              userData?.username ?? "";

                                          return SizedBox(
                                            height: 38,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ReusableText(
                                                  text:
                                                      userData?.username ?? "",
                                                  style: appstyle(
                                                    12,
                                                    Colors.black,
                                                    FontWeight.normal,
                                                  ),
                                                ),
                                                ReusableText(
                                                  text: userData?.email ?? "",
                                                  style: appstyle(
                                                    12,
                                                    Colors.black,
                                                    FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Edit Profile'),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller:
                                                        locationController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Location',
                                                    ),
                                                  ),
                                                  // Ganti bagian ini dengan TextFormField untuk password
                                                  TextFormField(
                                                    controller:
                                                        passwordController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Password',
                                                    ),
                                                    keyboardType: TextInputType
                                                        .visiblePassword,
                                                    obscureText: true,
                                                  ),
                                                  TextField(
                                                    controller: emailController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Email',
                                                    ),
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                  ),
                                                  TextField(
                                                    controller:
                                                        usernameController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Username',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  // Validasi
                                                  if (locationController.text.isEmpty ||
                                                      emailController
                                                          .text.isEmpty ||
                                                      passwordController
                                                          .text.isEmpty ||
                                                      usernameController
                                                          .text.isEmpty) {
                                                    Alert.showSnackbarWarning(
                                                        context,
                                                        "All field requeired");
                                                  } else {
                                                    // Panggil proses update profile
                                                    ProfileModel updatedModel =
                                                        ProfileModel(
                                                      location:
                                                          locationController
                                                              .text,
                                                      password:
                                                          passwordController
                                                              .text,
                                                      email:
                                                          emailController.text,
                                                      username:
                                                          usernameController
                                                              .text,
                                                    );

                                                    bool updatedSuccessfully =
                                                        await profileNotifier
                                                            .updateProfile(
                                                                updatedModel);

                                                    if (updatedSuccessfully) {
                                                      Alert.showSuccessSnackbar(
                                                          context,
                                                          "Profile successfully updated");
                                                    } else {
                                                      Alert.showErrorSnackbar(
                                                          context,
                                                          "Profile failed updated");
                                                    }
                                                  }
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Update'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(
                                      Feather.edit,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 170,
                          color: Colors.grey.shade200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TilesWidget(
                                OnTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProcessOrders(),
                                    ),
                                  );
                                },
                                title: "My Orders",
                                leading:
                                    MaterialCommunityIcons.truck_fast_outline,
                              ),
                              TilesWidget(
                                OnTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const FavoritePage(),
                                    ),
                                  );
                                },
                                title: "My Favorites",
                                leading: MaterialCommunityIcons.heart_outline,
                              ),
                              TilesWidget(
                                OnTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CartPage(),
                                    ),
                                  );
                                },
                                title: "Cart",
                                leading: Fontisto.shopping_bag_1,
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                          future: AuthHelper().getProfile(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            } else if (snapshot.hasError) {
                              String errorMessage = "Error get your data";
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
                                  style: appstyle(
                                    18,
                                    Colors.black,
                                    FontWeight.w600,
                                  ),
                                ),
                              );
                            } else {
                              final userData = snapshot.data;
                              return Container(
                                height: 170,
                                color: Colors.grey.shade200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 8, bottom: 13),
                                      child: Row(
                                        children: [
                                          Icon(
                                            SimpleLineIcons.location_pin,
                                            color: Colors.grey.shade700,
                                          ),
                                          const SizedBox(
                                            width: 33,
                                          ),
                                          ReusableText(
                                            text: userData!.location,
                                            style: appstyle(
                                              13,
                                              Colors.black,
                                              FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TilesWidget(
                                      OnTap: () {
                                        authNotifier.logout();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage(),
                                          ),
                                        );
                                      },
                                      title: "Logout",
                                      leading: AntDesign.logout,
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
