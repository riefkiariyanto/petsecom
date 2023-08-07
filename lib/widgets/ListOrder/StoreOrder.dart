import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'OrderItem.dart';

class StoreOrder extends StatefulWidget {
  const StoreOrder({super.key});

  @override
  State<StoreOrder> createState() => _StoreOrderState();
}

class _StoreOrderState extends State<StoreOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
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
                            Spacer(),
                            Container(
                              margin: EdgeInsets.only(right: 35, top: 10),
                              child: Container(
                                child: Text(
                                  'Order Id',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
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
                              child: OrderItem(),
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
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Status Order',
                                        style: TextStyle(
                                            fontSize: 12,
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
