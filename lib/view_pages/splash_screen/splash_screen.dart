import 'dart:async';
import 'package:flutter/material.dart';
import 'package:socialmediaclone/view_pages/login_page/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _textAnimation;
  
  double _getResponsiveFontSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width >= 1024) {
      return 48;
    } else if (width >= 600) {
      return 36;
    } else {
      return 20;
    }
  }

  final String title = "SNAP_GRAM";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _textAnimation = StepTween(begin: 0, end: title.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        double fontSize = _getResponsiveFontSize(context);
    return Scaffold(
      backgroundColor: const Color(0xFF106837),
      body: Center(
        child: AnimatedBuilder(
          animation: _textAnimation,
          builder: (context, child) {
            String displayText = title.substring(0, _textAnimation.value);
            return Text(
              displayText,
              style:  TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            );
          },
        ),
      ),
    );
  }
}
