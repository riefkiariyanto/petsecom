import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class MyImageSlider extends StatefulWidget {
  @override
  _MyImageSliderState createState() => _MyImageSliderState();
}

class _MyImageSliderState extends State<MyImageSlider> {
  int _currentIndex = 0;

  final List<String> imageList = [
    "images/banner3.jpg",
    "images/banner2.jpg",
    "images/banner1.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  enlargeCenterPage: true,
                  aspectRatio: 23 / 9,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.95,
                ),
                items: imageList.map((imagePath) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(
                            imagePath), // Use AssetImage for local images
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
              Positioned(
                bottom: 4,
                left: 0,
                right: 0,
                child: DotsIndicator(
                  dotsCount: imageList.length,
                  position: _currentIndex.toDouble(),
                  decorator: DotsDecorator(
                      color: Colors.grey,
                      activeColor: Colors.red,
                      size: const Size.square(6.0),
                      spacing: EdgeInsets.symmetric(horizontal: 4.0),
                      activeSize: const Size(14, 6),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
