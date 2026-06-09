import 'package:dartz/dartz.dart';
import 'package:nuntium/core/errors/failures.dart';
import 'package:nuntium/features/categories/domain/repository/cateogries_repository.dart';

import '../entities/category_entity.dart';

class GetCategoriesUseCase {
  final CategoriesRepository categoriesRepository;

  GetCategoriesUseCase(this.categoriesRepository);

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return categoriesRepository.getCategories();
  }
}
