import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:masak_apa/blocs/bloc_export.dart';
import 'package:masak_apa/elements/card_recipe.dart';
import 'package:masak_apa/screens/detail_recipe.dart';
import 'package:masak_apa/utils/screen_transition.dart';

class FavoriteRecipes extends StatelessWidget {
  const FavoriteRecipes({Key? key}) : super(key: key);

  int _generateCrossAxisCount(double maxWidth){
    if(maxWidth<=600){
      return 1;
    }else if(maxWidth<=900){
      return 2;
    }else if(maxWidth<=1200){
      return 3;
    }else{
      return 4;
    }
  }
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
          if(favoriteRecipes.isEmpty){
            return Center(
              child:Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  // overflow: TextOverflow.clip,
                  'Belum ada resep masakan yang ditambahkan ke favorit', 
                  style:TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 119, 18, 214),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            );
          }
          return LayoutBuilder(
            builder: (BuildContext context,BoxConstraints constraints) {

              return MasonryGridView.count(
                itemCount: favoriteRecipes.length,
                crossAxisCount: _generateCrossAxisCount(constraints.maxWidth),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  return CardRecipe(
                    data: {
                      "key":favoriteRecipes[index].keyRecipe,
                      "title":favoriteRecipes[index].title,
                      "thumb":favoriteRecipes[index].thumb,
                    },
                    navigator: ()async{
                      await screenTransition(context, screen: DetailRecipe(thumb:favoriteRecipes[index].thumb,keyMenu: favoriteRecipes[index].keyRecipe,title:favoriteRecipes[index].title));
                    },
                    isShowRemoveButton: true,
                  );
                },
              );
            }
          );
        },
      ),   
    );
  }
}

