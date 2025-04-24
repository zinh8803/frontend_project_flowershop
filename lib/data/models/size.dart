// size.dart
class SizeModel {
  final int id;
  final String name;
  final double priceModifier;

  SizeModel({
    required this.id,
    required this.name,
    required this.priceModifier,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id: json['id'],
      name: json['name'],
      priceModifier: (json['price_modifier'] as num).toDouble(),
    );
  }
}
