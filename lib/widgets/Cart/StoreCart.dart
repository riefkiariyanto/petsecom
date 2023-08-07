import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petsecom/widgets/Checkout/checkout.dart';

import 'CartItem.dart';

class StoreCart extends StatefulWidget {
  const StoreCart({super.key});

  @override
  State<StoreCart> createState() => _StoreCartState();
}

class _StoreCartState extends State<StoreCart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 1,
                          offset: Offset(0.0, 0.75)),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                "Store Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                indent: 12,
                                endIndent: 12,
                                color: Colors.grey[200],
                                thickness: 1.0,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              child: CartItem(),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10, bottom: 10),
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(
                                      "Sub Total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Rp 6000",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.deepOrange),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => CheckOut(),
                                    ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Checkout',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } // use it
            ),
      ),
    );
  }
}
