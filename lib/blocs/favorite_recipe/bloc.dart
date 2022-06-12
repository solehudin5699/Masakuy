import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:masak_apa/models/favorite_recipe.dart';

part 'event.dart';
part 'state.dart';

class FavoriteRecipeBloc extends HydratedBloc<FavoriteRecipeEvent, FavoriteRecipeState> {
  FavoriteRecipeBloc() : super(const FavoriteRecipeState()) {
    on<UpdateFavoriteRecipe>(_updateFavoriteRecipe);
  }

  void _updateFavoriteRecipe(UpdateFavoriteRecipe event,Emitter<FavoriteRecipeState> emit){
    final state = this.state;
    final recipe = event.recipe;

    List<FavoriteRecipeModel> allFavorited = List.from(state.favoriteRecipes);
    List<FavoriteRecipeModel> recipeToRemove=List.from([]);
    if(allFavorited.isEmpty){
      emit(FavoriteRecipeState(favoriteRecipes: List.from(state.favoriteRecipes)..add(recipe)));
    }else{
      for(FavoriteRecipeModel element in allFavorited){
        if(element.keyRecipe==recipe.keyRecipe){
          recipeToRemove.add(element);
        }
      }
      if(recipeToRemove.isEmpty){
        emit(FavoriteRecipeState(favoriteRecipes: List.from(state.favoriteRecipes)..add(recipe)));
      }else{
        emit(FavoriteRecipeState(favoriteRecipes: List.from(state.favoriteRecipes)..remove(recipe)));
      }
    }
  }
  
  @override
  FavoriteRecipeState? fromJson(Map<String, dynamic> json) {
    return FavoriteRecipeState.fromMap(json);
  }
  
  @override
  Map<String, dynamic>? toJson(FavoriteRecipeState state) {
    return state.toMap();
  }
}