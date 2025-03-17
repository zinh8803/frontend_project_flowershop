import 'package:flutter/material.dart';
import 'package:frontend_appflowershop/model/category.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Thêm dependency này

class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Bạn có thể thêm hành động khi nhấn vào card, ví dụ:
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductScreen(category: category)));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: category.imageUrl,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
