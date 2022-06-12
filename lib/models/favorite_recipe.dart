import 'package:equatable/equatable.dart';

class FavoriteRecipeModel extends Equatable {
  final String keyRecipe;
  final String title;
  final String thumb;

  const FavoriteRecipeModel({required this.keyRecipe,required this.title,required this.thumb});

  @override
  List<Object?> get props => [
    keyRecipe,title,thumb
  ];

  FavoriteRecipeModel copyWith({
    String? keyRecipe,
    String? title,
    String? thumb,
  }) {
    return FavoriteRecipeModel(
      keyRecipe: keyRecipe ?? this.keyRecipe,
      title: title ?? this.title,
      thumb: thumb ?? this.thumb,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'keyRecipe': keyRecipe,
      'title': title,
      'thumb': thumb,
    };
  }

  factory FavoriteRecipeModel.fromMap(Map<String, dynamic> map) {
    return FavoriteRecipeModel(
      keyRecipe: map['keyRecipe'] as String,
      title: map['title'] as String,
      thumb: map['thumb'] as String,
    );
  }
}