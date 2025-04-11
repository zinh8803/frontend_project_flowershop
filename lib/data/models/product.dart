class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final double finalPrice;
  final bool isDiscounted;
  final int categoryId;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.finalPrice,
    required this.isDiscounted,
    required this.categoryId,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      finalPrice: double.parse(json['final_price'].toString()),
      isDiscounted: json['is_discounted'],
      categoryId: json['category_id'],
      imageUrl: json['image_url'],
    );
  }
}
