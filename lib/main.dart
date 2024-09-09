import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:learn_firebase_2/app/data/app_color.dart';
import 'package:learn_firebase_2/app/modules/splash/splash.dart';
import 'package:learn_firebase_2/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('id_ID');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = prefs.getBool('isLoggedIn');

  runApp(MyApp(isLoggedIn: isLoggedIn ?? false));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Splash(),
          );
        }

        if (snapshot.hasData || isLoggedIn) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
                primaryColor: AppColor.primary,
                colorScheme: const ColorScheme.light(
                  primary: AppColor.primary,
                  secondary: AppColor.secondary,
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: AppColor.primary,
                  foregroundColor: Colors.white,
                )),
            title: "Application",
            initialRoute: Routes.HOME,
            getPages: AppPages.routes,
          );
        } else {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Application",
            initialRoute: Routes.LOGIN,
            getPages: AppPages.routes,
          );
        }
      },
    );
  }
}
