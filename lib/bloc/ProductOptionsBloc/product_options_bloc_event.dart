import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/size.dart';
import 'package:frontend_appflowershop/data/models/color.dart';

abstract class ProductOptionsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadOptionsEvent extends ProductOptionsEvent {
  final List<SizeModel> sizes;
  final List<ColorModel> colors;

  LoadOptionsEvent({required this.sizes, required this.colors});

  @override
  List<Object> get props => [sizes, colors];
}

class SelectSizeEvent extends ProductOptionsEvent {
  final SizeModel size;

  SelectSizeEvent(this.size);

  @override
  List<Object> get props => [size];
}

class ToggleColorEvent extends ProductOptionsEvent {
  final ColorModel color;

  ToggleColorEvent(this.color);

  @override
  List<Object> get props => [color];
}

class ClearOptionsEvent extends ProductOptionsEvent {}
