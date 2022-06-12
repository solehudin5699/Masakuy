part of 'bloc.dart';

class FavoriteRecipeState extends Equatable {
  final List<FavoriteRecipeModel> favoriteRecipes;
  const FavoriteRecipeState({
    this.favoriteRecipes=const <FavoriteRecipeModel>[]
  });
  
  @override
  List<Object> get props => [favoriteRecipes];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'favoriteRecipes': favoriteRecipes.map((x) => x.toMap()).toList(),
    };
  }

  factory FavoriteRecipeState.fromMap(Map<String, dynamic> map) {
    return FavoriteRecipeState(
      favoriteRecipes: List<FavoriteRecipeModel>.from(map['favoriteRecipes']?.map<FavoriteRecipeModel>((x) => FavoriteRecipeModel.fromMap(x as Map<String,dynamic>),),),
    );
  }
}

