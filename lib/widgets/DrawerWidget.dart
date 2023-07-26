import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petsecom/Views/ProfilePage.dart';
import 'package:petsecom/widgets/Checkout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Views/MapsView.dart';

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
                    color: Colors.blue,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage("images/dogb.png"),
                    ),
                  ),
                );
              }),
          ListTile(
              leading: Icon(Icons.map_outlined),
              title: Text('Maps'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MapsView(),
                ));
              }),
          ListTile(
              leading: Icon(Icons.person),
              title: Text('StatusOrder'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CheckOut(),
                ));
              }),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Request'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Policies'),
            onTap: () => null,
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
