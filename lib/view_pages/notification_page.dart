import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: const Text(
            'SNAP_GRAM',
            style: TextStyle(
                color: const Color(0xFF106837),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationPage()));
              },
              icon: Icon(
                Icons.notifications,
                color: const Color(0xFF106837),
              )),
          IconButton(
              onPressed: ()  {
              },
              icon: Icon(
                Icons.logout,
                color: const Color(0xFF106837),
              )),
        ],
      ),
      body: Center(
        child: Text("No notification found !!!!"),
      ),
    );
  }
}