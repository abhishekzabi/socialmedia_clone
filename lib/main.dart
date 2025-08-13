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
// web       1:261565164474:web:945537aef657e9cef8cb83
// android   1:261565164474:android:6df91bc09570d561f8cb83
// ios       1:261565164474:ios:41114fc7e7e31530f8cb83
// macos     1:261565164474:ios:41114fc7e7e31530f8cb83
// windows   1:261565164474:web:892a63360070e74bf8cb83
//DVMyi21mhbu0hRLn3JT2Qi6NBNo             SECRET
//656674856126934                          API
var cloudinary=Cloudinary.fromStringUrl('cloudinary://656674856126934:DVMyi21mhbu0hRLn3JT2Qi6NBNo@dt7qnqy5z');

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
