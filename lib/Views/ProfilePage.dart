import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:petsecom/Views/CartPage.dart';
import 'package:petsecom/Views/HomePage.dart';
import 'package:petsecom/Views/LoginPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              profileImage(),
              SizedBox(
                height: 10,
              ),
              ProfileUser(),
              SizedBox(
                height: 30,
              ),
              detailBio(),
              SizedBox(
                height: 40,
              ),
              logoutbtn(context),
            ],
          ),
        ],
      ),
    );
  }
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

detailBio() {
  return Container(
    width: 350,
    child: Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text(''),
          ),
          Divider(
            height: 2,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            leading: Icon(Icons.phone_iphone),
            title: Text(''),
          ),
          Divider(
            height: 2,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text(''),
          ),
          Divider(
            height: 2,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(''),
          ),
        ],
      ),
    ),
  );
}

profileImage() {
  return CircleAvatar(
    radius: 60,
    child: ClipOval(
      child: Image.network(
        'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      ),
    ),
  );
}

ProfileUser() {
  return Column(
    children: [
      Text(
        "user.name",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      SizedBox(
        height: 4,
      ),
      Text(
        "email@gmail.com",
        style: TextStyle(color: Colors.grey),
      )
    ],
  );
}
