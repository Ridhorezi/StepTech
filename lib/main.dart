import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_tech/views/ui/auth/login.dart';
// import 'package:step_tech/views/ui/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:step_tech/controllers/cart_provider.dart';
import 'package:step_tech/controllers/favorite_provider.dart';
import 'package:step_tech/controllers/auth_provider.dart';
import 'package:step_tech/controllers/mainscreen_provider.dart';
import 'package:step_tech/controllers/product_provider.dart';
import 'package:step_tech/controllers/profile_provider.dart';
import 'package:step_tech/controllers/payment_provider.dart';
import 'package:step_tech/views/ui/main_screen.dart';

// entrypoint of the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('cart_box');
  await Hive.openBox('fav_box');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = prefs.getBool('isLogged') ?? false;

  //method that initializes the app and run top level wigets
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => MainScreenNotifier()),
    ChangeNotifierProvider(create: (context) => ProductNotifier()),
    ChangeNotifierProvider(create: (context) => FavoriteNotifier()),
    ChangeNotifierProvider(create: (context) => CartNotifier()),
    ChangeNotifierProvider(create: (context) => ProfileNotifier()),
    ChangeNotifierProvider(create: (context) => AuthNotifier()),
    ChangeNotifierProvider(create: (context) => PaymentNotifier()),
  ], child: MyApp(isLogged: isLogged)));
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({Key? key, required this.isLogged}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // overall theme and app layout
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'dbestech',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // sets the homescreen of the app
          home: isLogged ? MainScreen() : const LoginPage(),
        );
      },
    );
  }
}
