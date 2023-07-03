// import 'package:adoptme/animal_list.dart';
import 'package:flutter/material.dart';
// import 'List_Controller.dart';

class CategoryCard extends StatelessWidget {
  final String categoryName;

  CategoryCard({
    required this.categoryName,
  });
  // final controller = Get.put(ListController());
  // final authController = Get.find<ListController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          _bottomsheet(context);
        },
        child: Container(
          width: 150,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(2, 3), // changes position of shadow
              ),
            ],
            color: Colors.grey[50],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.face,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    categoryName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _bottomsheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 450,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  categoryName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Colors.grey[200],
                thickness: 2,
                indent: 10,
                endIndent: 10,
                height: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
