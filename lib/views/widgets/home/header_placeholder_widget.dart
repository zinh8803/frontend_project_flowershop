import 'package:flutter/material.dart';

class HeaderPlaceholderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.image,
          size: 50,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
