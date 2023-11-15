import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:petsecom/Views/ImageSlider.dart';
import 'package:petsecom/widgets/product/ItemsWidget.dart';
import 'package:petsecom/Views/DrawerWidget.dart';
import '../Controllers/MapsController.dart';
import '../widgets/Store/category_card.dart';
import '../widgets/product/SearchList.dart';
import 'cartIcon.dart';

class FirtsPage extends StatefulWidget {
  @override
  State<FirtsPage> createState() => _FirtsPageState();
}

class _FirtsPageState extends State<FirtsPage> {
  var controller = Get.put(MapsController());
  TextEditingController _searchController = TextEditingController();

  void navigateToSearchList(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SearchList(searchQuery: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
            child: Scaffold(
              backgroundColor: Colors.grey[50],
              appBar: AppBar(
                centerTitle: true,
                toolbarHeight: 50,
                backgroundColor: Colors.brown[300],
                bottomOpacity: 0.0,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                title: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.symmetric(vertical: 3),
                  height: 40,
                  child: TextField(
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    onChanged: (query) {
                      navigateToSearchList(query);
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 3,
                      ),
                      filled: true,
                      fillColor: Colors.brown[100],
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            BorderSide(color: Colors.brown.shade400, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            BorderSide(color: Colors.brown.shade100, width: 1),
                      ),
                      hintText: "Search...",
                      prefixIcon: Icon(Icons.search,
                          size: 20, color: Colors.deepOrange[300]),
                    ),
                  ),
                ),
                actions: [
                  CartIcon(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return DrawerWidget();
                        }),
                      );
                    },
                    icon: Icon(Icons.menu_rounded, color: Colors.grey[200]),
                  )
                ],
              ),
              body: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Text(
                          controller.address.value,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800]),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 8),
                        child: MyImageSlider(),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            CategoryCard(
                              categoryName: 'List PetShop',
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        child: Text(
                          'New Items ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: ItemsWidget()),
                    ],
                  ),
                  SizedBox(
                    height: 70,
                  )
                ],
              ),
            ),
            onWillPop: () async {
              final value = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Alert'),
                      content: const Text('Do you want to Exit'),
                      actions: [
                        ElevatedButton(
                          onPressed: () => SystemNavigator.pop(),
                          child: Text('Exit'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('No'),
                        ),
                      ],
                    );
                  });
              if (value != null) {
                return Future.value(value);
              } else {
                return Future.value(false);
              }
            }),
      ],
    );
  }
}
