import 'package:flutter/material.dart';
import 'package:socialmediaclone/view_pages/home_page/entry.dart';
import 'package:socialmediaclone/view_pages/login_page/login_page.dart';
import 'package:socialmediaclone/view_pages/profile_page/profile_page.dart';

void main() {
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
      home:  LoginScreen(),
            // home:  BottomNavExample(),

    );
  }
}
