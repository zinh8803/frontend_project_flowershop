import 'package:frontend_appflowershop/data/models/color.dart';
import 'package:frontend_appflowershop/data/models/size.dart';

class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final double finalPrice;
  final bool isDiscounted;
  final int categoryId;
  final String imageUrl;
  final List<SizeModel>? sizes; // Thêm sizes
  final List<ColorModel>? colors;
  final List<IngredientModel>? ingredients;
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.finalPrice,
    required this.isDiscounted,
    required this.categoryId,
    required this.imageUrl,
    this.sizes,
    this.colors,
    this.ingredients,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      finalPrice: double.parse(json['final_price'].toString()),
      stock: json['stock'],
      isDiscounted: json['is_discounted'],
      categoryId: json['category_id'],
      imageUrl: json['image_url'],
      sizes: json['sizes'] != null
          ? (json['sizes'] as List)
              .map((size) => SizeModel.fromJson(size))
              .toList()
          : null,
      colors: json['colors'] != null
          ? (json['colors'] as List)
              .map((color) => ColorModel.fromJson(color))
              .toList()
          : null,
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
              .map((ingredient) => IngredientModel.fromJson(ingredient))
              .toList()
          : null,
    );
  }
  ProductModel copyWith({
    int? id,
    String? name,
    int? stock,
    bool? isDiscounted,
    int? categoryId,
    String? description,
    double? price,
    double? finalPrice,
    String? imageUrl,
    List<SizeModel>? sizes,
    List<ColorModel>? colors,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      stock: stock ?? this.stock,
      isDiscounted: this.isDiscounted,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      price: price ?? this.price,
      finalPrice: finalPrice ?? this.finalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
    );
  }
}

class IngredientModel {
  final int id;
  final int productId; // Thêm product_id để phản ánh khóa ngoại
  final String? description;

  IngredientModel({
    required this.id,
    required this.productId,
    this.description,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'],
      productId: json['product_id'],
      description: json['description'],
    );
  }
}
