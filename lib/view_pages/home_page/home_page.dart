import 'package:flutter/material.dart';
import 'package:socialmediaclone/view_pages/profile_page/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Socio_Gram",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none,
                size: 28,
              ),
              color: Colors.red,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              icon: Icon(
                Icons.person,
                size: 28,
              ),
              color: const Color.fromARGB(255, 32, 109, 186),
            ),
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        "Abhishek kp",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        "12/08/2025",
                        style: TextStyle(
                            fontSize: 12,
                            color: const Color.fromARGB(255, 96, 96, 96)),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: const Color.fromARGB(103, 120, 120, 120),
              ),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/signuppage.jpg"),
                        fit: BoxFit.cover)),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: const Color.fromARGB(103, 120, 120, 120),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 27,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Icon(
                    Icons.comment,
                    size: 27,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Icon(
                    Icons.share,
                    size: 27,
                  ),
                  const SizedBox(
                    width: 16,
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
