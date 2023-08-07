import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:petsecom/widgets/ProductDetail.dart';

import '../Constants/constants.dart';

class ItemsWidget extends StatefulWidget {
  const ItemsWidget({super.key});

  @override
  State<ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  Future getProduct() async {
    // http.Response response;
    // response = await http.get(Uri.parse('${url}client/add-product'));
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      children: [
        for (int i = 1; i < 8; i++)
          FutureBuilder(
              future: getProduct(),
              builder: (context, snapshot) {
                child:
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProductDetail(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 1,
                            offset: Offset(0.0, 0.75)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                height: 110,
                                width: 120,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 1,
                                        offset: Offset(0.0, 0.75)),
                                  ],
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: ExactAssetImage("images/dogb.png"),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            // snapshot.data['product']['name'],
                            "name",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "deskripsiiiii",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rp.100000",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.shopping_cart_checkout,
                                color: Colors.deepOrange,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
      ],
    );
  }
}
