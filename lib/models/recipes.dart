import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const String baseUrl = 'https://masak-apa-tomorisakura.vercel.app';

class RecipesModel {
  final List<dynamic> recipes;

  const RecipesModel({
    required this.recipes
  });

  factory RecipesModel.fromJson(Map<String, dynamic> json) {
    return RecipesModel(
      recipes: json['results'],
    );
  }
}

class DetailRecipeModel {
  final String title;
  final String servings;
  final String times;
  final String dificulty;
  final Map<String,dynamic> author;
  final String desc;
  final List<dynamic> needItem;
  final List<dynamic> ingredient;
  final List<dynamic> step;

  const DetailRecipeModel({
    required this.title,
    required this.servings,
    required this.times,
    required this.dificulty,
    required this.author,
    required this.desc,
    required this.needItem,
    required this.ingredient,
    required this.step,
  });

  factory DetailRecipeModel.fromJson(Map<String, dynamic> json) {
    return DetailRecipeModel(
      title: json['results']['title'],
      servings: json['results']['servings'],
      times: json['results']['times'],
      dificulty: json['results']['dificulty'],
      author: json['results']['author'],
      desc :json['results']['desc'],
      needItem: json['results']['needItem'],
      ingredient: json['results']['ingredient'],
      step: json['results']['step'],
    );
  }
}

Future<RecipesModel> fetchRecipes(String endpoint) async {
  final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
  if (response.statusCode == 200) {
    return RecipesModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load recipes');
  }
}

Future<DetailRecipeModel> fetchDetailRecipe(String key) async {
  const url = '$baseUrl/api/recipe';
  final response = await http.get(Uri.parse('$url/$key'));

  if (response.statusCode == 200) {
    return DetailRecipeModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load recipes');
  }
}