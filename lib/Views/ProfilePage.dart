import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:petsecom/Constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petsecom/Views/HomePage.dart';
import 'package:petsecom/Views/LoginPage.dart';
import 'package:http/http.dart' as http;

import '../widgets/Cart/CartPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Text(
          "Profile",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const CartPage();
              }));
            },
            icon: Icon(Icons.shopping_bag_outlined, color: Colors.grey[700]),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return const HomePage();
            }));
          },
          icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
        ),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                profileImage(context),
                SizedBox(
                  height: 10,
                ),
                ProfileBio(context),
                SizedBox(
                  height: 30,
                ),
                logoutbtn(context),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

ProfileBio(BuildContext context) {
  Future getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String _data;
    _data = prefs.getString('_data') ?? '';

    return json.decode(_data);
  }

  return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator() // Show a loading indicator
              );
        }
        return Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                snapshot.data['user']['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      visualDensity: VisualDensity(vertical: -3), // to compact
                      leading: Icon(Icons.email),
                      title: Text(
                        snapshot.data['user']['email'],
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      visualDensity: VisualDensity(vertical: -4), // to compact
                      leading: Icon(Icons.phone_iphone),
                      title: Text(
                        snapshot.data['user']['phone'],
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      visualDensity: VisualDensity(vertical: -3), // to compact
                      leading: Icon(Icons.location_on),
                      title: Text(snapshot.data['user']['address'],
                          style: TextStyle(
                            fontSize: 14,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      });
}

logoutbtn(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 50.0,
    ),
    child: GestureDetector(
      onTap: () async {
        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.remove('slogin');
        sharedPreferences.remove('sregister');
        Get.to(LoginPage());
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'LogOut',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}

profileImage(BuildContext context) {
  Future getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String _data;
    _data = prefs.getString('_data') ?? '';
    return json.decode(_data);
  }

  return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        return Column(
          children: [
            CircleAvatar(
              radius: 60,
              child: ClipOval(
                child: Image.network(
                  'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg',
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                ),
              ),
            )
          ],
        );
      });
}
