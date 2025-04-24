import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/size.dart';
import 'package:frontend_appflowershop/data/models/color.dart';

abstract class ProductOptionsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductOptionsInitial extends ProductOptionsState {}

class ProductOptionsLoaded extends ProductOptionsState {
  final List<SizeModel> sizes;
  final List<ColorModel> colors;
  final SizeModel? selectedSize;
  final List<ColorModel> selectedColors;

  ProductOptionsLoaded({
    required this.sizes,
    required this.colors,
    this.selectedSize,
    this.selectedColors = const [],
  });

  ProductOptionsLoaded copyWith({
    List<SizeModel>? sizes,
    List<ColorModel>? colors,
    SizeModel? selectedSize,
    List<ColorModel>? selectedColors,
  }) {
    return ProductOptionsLoaded(
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColors: selectedColors ?? this.selectedColors,
    );
  }

  @override
  List<Object?> get props => [sizes, colors, selectedSize, selectedColors];
}