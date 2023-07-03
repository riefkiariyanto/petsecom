import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petsecom/Views/ProfilePage.dart';

class listCategory extends GetView {
  get builder => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => ListTile(
            leading: Image.asset(
              'images/listPic.jpeg',
              width: 70,
              height: 130,
            ),
            title: Text("animalName"),
            subtitle: Text("description"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ));
            },
          ),
        ),
      ),
    );
  }
}
