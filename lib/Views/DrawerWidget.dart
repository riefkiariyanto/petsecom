import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:petsecom/widgets/CheckoutPayment/PaymentPage.dart';
import 'package:petsecom/widgets/Gmaps/TetsMaps.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginPage.dart';
import '../widgets/product/SearchList.dart';

class DrawerWidget extends StatelessWidget {
  Future getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String _data;
    _data = prefs.getString('_data') ?? '';
    return json.decode(_data);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.brown.shade50,
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder(
              future: getUser(),
              builder: (context, snapshot) {
                return UserAccountsDrawerHeader(
                  accountName: Text(snapshot.data['user']['name']),
                  accountEmail: Text(snapshot.data['user']['email']),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg',
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade400,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage("images/dogb.png"),
                    ),
                  ),
                );
              }),
          ListTile(
              leading: Icon(Icons.description_rounded),
              title: Text('SearchList'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchList(
                    searchQuery: '',
                  ),
                ));
              }),
          ListTile(
              leading: Icon(Icons.map_outlined),
              title: Text('Maps'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TestMaps(),
                ));
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => PaymentPage(),
                // ));
              }),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Logout'),
            onTap: () async {
              final SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.remove('slogin');
              sharedPreferences.remove('sregister');
              Get.to(LoginPage());
            },
          ),
          Divider(),
          ListTile(
            title: Text('Exit'),
            leading: Icon(Icons.exit_to_app),
            onTap: () => SystemNavigator.pop(),
          ),
        ],
      ),
    );
  }
}
