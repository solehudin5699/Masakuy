part of 'bloc.dart';

abstract class FavoriteRecipeEvent extends Equatable {
  const FavoriteRecipeEvent();

  @override
  List<Object> get props => [];
}

class UpdateFavoriteRecipe extends FavoriteRecipeEvent{
  final FavoriteRecipeModel recipe;
  const UpdateFavoriteRecipe({required this.recipe});

  @override
  List<Object> get props => [recipe];
}

class RemoveFavoriteRecipe extends FavoriteRecipeEvent{
  final FavoriteRecipeModel recipe;
  const RemoveFavoriteRecipe({required this.recipe});

  @override
  List<Object> get props => [recipe];
}