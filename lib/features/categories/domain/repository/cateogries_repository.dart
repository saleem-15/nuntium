import 'package:dartz/dartz.dart';
import 'package:nuntium/core/errors/failures.dart';

import '../entities/category_entity.dart';

abstract class CategoriesRepository {
  Either<Failure, List<CategoryEntity>> getCategories({bool isForHome = false});
}
