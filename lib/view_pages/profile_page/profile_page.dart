import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socialmediaclone/view_pages/notification_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<DocumentSnapshot<Map<String, dynamic>>> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = _firestore.collection('users').doc(user!.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.logout,
                color: const Color(0xFF106837),
              )),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading profile data'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No profile data found'));
          }

          final data = snapshot.data!.data()!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage("assets/images/ccbgpng2.png"),
                        fit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(
                          Colors.black
                              .withOpacity(0.5),
                          BlendMode.dstATop,
                        ),
                      ),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: //
                            Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 124, 
                                  height: 124,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue, 
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      decoration:
                                          BoxDecoration(color: Colors.blue),
                                      child: Center(
                                        child: Text(
                                          (data['fullname'] != null &&
                                                  data['fullname'].isNotEmpty)
                                              ? data['fullname'][0]
                                                  .toUpperCase()
                                              : '-',
                                          style: TextStyle(
                                            color: Colors.white, 
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              (data['fullname'] ?? '-'),
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          height: 50,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                          ),
                          child: Center(
                            child: Text(
                              "other details",
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ///////////////////////////////
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/images/id-card.svg",
                            width: 24.0,
                            height: 24.0,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'fullname : ',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              data['fullname'] ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/images/contacts.svg",
                            width: 24.0,
                            height: 24.0,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Phone no : ',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              data['phone'] ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/images/email.svg",
                            width: 24.0,
                            height: 24.0,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Email id : ',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              data['email'] ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/images/home-address.svg",
                            width: 24.0,
                            height: 24.0,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Address : ',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              data['address'] ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/images/birthday.svg",
                            width: 24.0,
                            height: 24.0,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Age : ',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              data['age']?.toString() ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Spacer(), 

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF106837),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        )),
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 6,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
