import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/bloc/ProductOptionsBloc/product_options_bloc_event.dart';
import 'package:frontend_appflowershop/bloc/ProductOptionsBloc/product_options_bloc_state.dart';
import 'package:frontend_appflowershop/data/models/color.dart';


class ProductOptionsBloc
    extends Bloc<ProductOptionsEvent, ProductOptionsState> {
  ProductOptionsBloc() : super(ProductOptionsInitial()) {
    on<LoadOptionsEvent>(_onLoadOptions);
    on<SelectSizeEvent>(_onSelectSize);
    on<ToggleColorEvent>(_onToggleColor);
    on<ClearOptionsEvent>(_onClearOptions);
  }

  Future<void> _onLoadOptions(
      LoadOptionsEvent event, Emitter<ProductOptionsState> emit) async {
    emit(ProductOptionsLoaded(
      sizes: event.sizes,
      colors: event.colors,
    ));
  }

  Future<void> _onSelectSize(
      SelectSizeEvent event, Emitter<ProductOptionsState> emit) async {
    if (state is ProductOptionsLoaded) {
      final currentState = state as ProductOptionsLoaded;
      emit(currentState.copyWith(selectedSize: event.size));
    }
  }

  Future<void> _onToggleColor(
      ToggleColorEvent event, Emitter<ProductOptionsState> emit) async {
    if (state is ProductOptionsLoaded) {
      final currentState = state as ProductOptionsLoaded;
      final newSelectedColors = List<ColorModel>.from(currentState.selectedColors);
      if (newSelectedColors.contains(event.color)) {
        newSelectedColors.remove(event.color);
      } else {
        newSelectedColors.add(event.color);
      }
      emit(currentState.copyWith(selectedColors: newSelectedColors));
    }
  }

  Future<void> _onClearOptions(
      ClearOptionsEvent event, Emitter<ProductOptionsState> emit) async {
    if (state is ProductOptionsLoaded) {
      final currentState = state as ProductOptionsLoaded;
      emit(currentState.copyWith(selectedSize: null, selectedColors: []));
    }
  }
}