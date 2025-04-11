import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/data/services/Category/api_category.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ApiService apiService;

  CategoryBloc(this.apiService) : super(CategoryInitial()) {
    on<FetchCategoriesEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await apiService.getCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}