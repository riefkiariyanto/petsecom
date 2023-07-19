import 'package:flutter/material.dart';
import 'package:petsecom/Views/ProductPage.dart';

class list_toko extends StatefulWidget {
  const list_toko({super.key});

  @override
  State<list_toko> createState() => _list_tokoState();
}

class _list_tokoState extends State<list_toko> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey,
              )),
          child: ListTile(
            leading: Image.asset(
              "images/catAset.jpg",
              width: 70,
              height: 130,
            ),
            title: Text("animalName"),
            subtitle: Text("animalName"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductPage(),
              ));
            },
          ),
        ),
      ],
    );
  }
}
