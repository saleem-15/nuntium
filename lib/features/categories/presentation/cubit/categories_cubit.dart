import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_case/get_cateogories_use_case.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoriesCubit({
    required GetCategoriesUseCase getCategoriesUseCase,
  }) : _getCategoriesUseCase = getCategoriesUseCase,
       super(const CategoriesInitial()) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    emit(const CategoriesLoading());
    final result = await _getCategoriesUseCase.call();
    result.fold(
      (failure) => emit(CategoriesError(failure.message)),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }
}
