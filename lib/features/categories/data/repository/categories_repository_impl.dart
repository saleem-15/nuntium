import 'package:dartz/dartz.dart';
import 'package:nuntium/core/errors/failures.dart';
import 'package:nuntium/core/resources/app_assets.dart';
import 'package:nuntium/core/resources/app_strings.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/repository/cateogries_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  @override
  Either<Failure, List<CategoryEntity>> getCategories({bool isForHome = false})  {
    if (isForHome) {
      return Right([
        CategoryEntity(
          id: 'general',
          name: AppStrings.general,
          iconPath: AppAssets.science,
        ),
        CategoryEntity(
          id: 'sports',
          name: AppStrings.sports,
          iconPath: AppAssets.sports,
        ),
        CategoryEntity(
          id: 'business',
          name: AppStrings.business,
          iconPath: AppAssets.business,
        ),
        CategoryEntity(
          id: 'science',
          name: AppStrings.science,
          iconPath: AppAssets.science,
        ),
        CategoryEntity(
          id: 'entertainment',
          name: AppStrings.entertainment,
          iconPath: AppAssets.entertainment,
        ),
        CategoryEntity(
          id: 'technology',
          name: AppStrings.technology,
          iconPath: AppAssets.technology,
        ),
      ]);
    } else {
      return Right([
        CategoryEntity(
          id: 'sports',
          name: AppStrings.sportsWithEmoji,
          iconPath: AppAssets.sports,
        ),
        CategoryEntity(
          id: 'politics',
          name: AppStrings.politicsWithEmoji,
          iconPath: AppAssets.politics,
        ),
        CategoryEntity(
          id: 'life',
          name: AppStrings.lifeWithEmoji,
          iconPath: '',
        ),
        CategoryEntity(
          id: 'gaming',
          name: AppStrings.gamingWithEmoji,
          iconPath: AppAssets.entertainment,
        ),
        CategoryEntity(
          id: 'animals',
          name: AppStrings.animalsWithEmoji,
          iconPath: '',
        ),
        CategoryEntity(
          id: 'nature',
          name: AppStrings.natureWithEmoji,
          iconPath: '',
        ),
        CategoryEntity(
          id: 'food',
          name: AppStrings.foodWithEmoji,
          iconPath: AppAssets.food,
        ),
        CategoryEntity(
          id: 'art',
          name: AppStrings.artWithEmoji,
          iconPath: AppAssets.art,
        ),
        CategoryEntity(
          id: 'history',
          name: AppStrings.historyWithEmoji,
          iconPath: '',
        ),
        CategoryEntity(
          id: 'fashion',
          name: AppStrings.fashionWithEmoji,
          iconPath: '',
        ),
      ]);
    }
  }
}
