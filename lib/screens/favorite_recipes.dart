import 'package:flutter/material.dart';
import 'package:masak_apa/blocs/bloc_export.dart';
import 'package:masak_apa/elements/card_recipe.dart';
import 'package:masak_apa/screens/detail_recipe.dart';
import 'package:masak_apa/utils/screen_transition.dart';

class FavoriteRecipes extends StatelessWidget {
  const FavoriteRecipes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
                colors: [
                  const Color.fromARGB(255, 119, 18, 214).withOpacity(0.7),
                  const Color.fromARGB(255, 59, 62, 255).withOpacity(0.9),
                ]
            ),
          ),
        ),
        leading: Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.3),
            border: Border.all(
              color: const Color.fromARGB(255, 255, 255, 255),
              width: 0.5,
            )
          ),
          child: IconButton(
            iconSize: 20,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color.fromARGB(255, 255, 255, 255),
            )
          ),
        ),
        title: const Text('Resep Favorit',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
        )
      ),
      body: BlocBuilder<FavoriteRecipeBloc,FavoriteRecipeState>(
        builder: (context,state){
          
          final favoriteRecipes = state.favoriteRecipes;
          return LayoutBuilder(
            builder: (BuildContext context,BoxConstraints constraints) {
              return ListView(
                children: favoriteRecipes.map((e) => CardRecipe(
                  data: {
                    "key":e.keyRecipe,
                    "title":e.title,
                    "thumb":e.thumb
                  },
                  navigator: ()async{
                    await screenTransition(context, screen: DetailRecipe(thumb:e.thumb,keyMenu: e.keyRecipe,title:e.title));
                  }
                )).toList(),
              );
            }
          );
        },
      ),   
    );
  }
}
