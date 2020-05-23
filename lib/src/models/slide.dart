import 'package:flutter/material.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

final slideList = [
  Slide(
    imageUrl: 'assets/images/slider_1.jpg',
    title: 'page1',
  ),
  Slide(
    imageUrl: 'assets/images/slider_2.jpg',
    title: 'page2',
  ),
  Slide(
    imageUrl: 'assets/images/slider_3.jpg',
    title: 'page3',
  )
];
