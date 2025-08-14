import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaclone/firebase_options.dart';
import 'package:socialmediaclone/view_pages/auth_gate/auth_gate.dart';
import 'package:socialmediaclone/view_pages/home_page/entry.dart';
import 'package:socialmediaclone/view_pages/login_page/login_page.dart';
import 'package:socialmediaclone/view_pages/profile_page/profile_page.dart';
import 'package:socialmediaclone/view_pages/splash_screen/splash_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Socialmedia_clone',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  SplashScreen(),
            // home:  BottomNavExample(),

    );
  }
}
