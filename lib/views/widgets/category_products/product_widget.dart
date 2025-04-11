import 'package:flutter/material.dart';
import '../../../data/models/product.dart';
import '../../screens/product_detail_screen.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel product;

  const ProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: product.id),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                height: 150, // Chiều cao cố định cho hình ảnh
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
            ),
            // Thông tin sản phẩm
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.finalPrice}đ',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Nút "+"
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // TODO: Thêm logic để thêm sản phẩm vào giỏ hàng
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
