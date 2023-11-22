// ignore_for_file: unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:step_tech/controllers/mainscreen_provider.dart';
import 'package:step_tech/views/shared/bottom_nav.dart';
import 'package:step_tech/views/shared/bottom_nav_widget.dart';
import 'package:step_tech/views/ui/cart_page.dart';
import 'package:step_tech/views/ui/favorite_page.dart';
import 'package:step_tech/views/ui/home_page.dart';
import 'package:step_tech/views/ui/nonuser_page.dart';
import 'package:step_tech/views/ui/product_by_cat_page.dart';
import 'package:step_tech/views/ui/profile_page.dart';
import 'package:step_tech/views/ui/search_page.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  List<Widget> pageList = [
    const HomePage(),
    const SearchPage(),
    // const FavoritePage(),
    // const CartPage(),
    const ProfilePage()
    // const NonUser()
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
      builder: (context, mainScreenNotifier, child) {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
          body: pageList[mainScreenNotifier.pageIndex],
          bottomNavigationBar: const BottoNavBar(),
        );
      },
    );
  }
}
