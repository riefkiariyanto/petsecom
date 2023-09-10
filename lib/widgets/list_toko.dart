import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Constants/constants.dart';
import '../Views/DetailStore.dart';

class list_toko extends StatefulWidget {
  const list_toko({super.key});

  @override
  State<list_toko> createState() => _list_tokoState();
}

class _list_tokoState extends State<list_toko> {
  Future getStore() async {
    final UrlStore = '${url}get-biodata-client';

    try {
      http.Response response = await http.get(Uri.parse(UrlStore));
      if (response.statusCode == 200) {
        print(json.decode(response.body)['data'][0]['name']);
        return jsonDecode(response.body);
      } else {
        print("Error - Status Code: ${response.statusCode}");
        print("Error - Messaga: ${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: FutureBuilder(
            future: getStore(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child:
                        CircularProgressIndicator() // Show a loading indicator
                    );
              }
              List<dynamic> storeData = snapshot.data['data'];
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  shrinkWrap: true, // use it
                  itemCount: storeData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        int idClient =
                            snapshot.data['data'][index]['id_clients'];
                        print('id_clients: $idClient');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => DetailStore(
                                idClient: snapshot.data['data'][index]
                                    ['id_clients']),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 7),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 1),
                              ],
                            ),
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            "${urlImage}storage/${snapshot.data['data'][index]['logo']}",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: 120,
                                              child: Text(
                                                snapshot.data['data'][index]
                                                    ['store_name'],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Container(
                                              width: 120,
                                              child: Text(
                                                snapshot.data['data'][index]
                                                    ['address'],
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[400]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: Container())
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
