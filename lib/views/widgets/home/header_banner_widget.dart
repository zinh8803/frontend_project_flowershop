import 'package:flutter/material.dart';

class HeaderBannerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://hoayeuthuong.com/cms-images/banner/434445_only-rose.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
