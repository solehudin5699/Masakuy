import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:masak_apa/blocs/bloc_export.dart';
import 'package:masak_apa/elements/card_recipe.dart';
import 'package:masak_apa/models/favorite_recipe.dart';
import 'package:masak_apa/screens/detail_recipe.dart';
import 'package:masak_apa/utils/screen_transition.dart';

class FavoriteRecipes extends StatefulWidget{
  const FavoriteRecipes({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState()=>_FavoriteRecipes();
  
}
class _FavoriteRecipes extends State<FavoriteRecipes> {
  bool isShowSearchbar=false;
  final TextEditingController _controllerKeyword = TextEditingController();
  List<FavoriteRecipeModel> listRecipes = [];
  String _keyword='';

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
  void initState() {
    super.initState();
    setState(() {
      listRecipes = context.read<FavoriteRecipeBloc>().state.favoriteRecipes;
    });
  }

  @override
  void dispose() {
    _controllerKeyword.dispose();
    super.dispose();
  }

  void _handleSearch(String value){
    List<FavoriteRecipeModel> res = List.from(context.read<FavoriteRecipeBloc>().state.favoriteRecipes);
    res.retainWhere((element) => element.title.toLowerCase().contains(value.toLowerCase()));
    setState(() {
      listRecipes=res;
    });
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
        leading:!isShowSearchbar?Container(
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
        ):null,
        automaticallyImplyLeading: false,
        title:isShowSearchbar? Container(
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)
          ),
          width: double.infinity,
          height: 40,
          child:TextField(
            controller: _controllerKeyword,
            autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none,
                hintText:'Cari resep di sini',
                prefixIcon:IconButton(
                  onPressed: (){
                    setState(() {
                      isShowSearchbar=false;
                    });
                    _handleSearch('');
                  }, 
                  icon: const Icon(Icons.arrow_back)
                ),
                suffixIcon: _keyword.isNotEmpty?IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _keyword='';
                    });
                    _controllerKeyword.clear();
                  },
                ):const SizedBox(width: 0,height: 0,)
              ),
              onSubmitted: (String value){
                if(value!=''){
                  _handleSearch(value);
                }
              },
            onChanged: (String value){
              setState(() {
                _keyword=value;
              });
            },
          )
        ):const Text('Resep Favorit',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
        ),
        actions:!isShowSearchbar? [
          IconButton(
            onPressed: (){
              setState(() {
                isShowSearchbar=true;
              });
            },
            icon: const Icon(Icons.search, color: Colors.white)
          )
        ]:[],

      ),
      body: BlocBuilder<FavoriteRecipeBloc,FavoriteRecipeState>(
        builder: (context,state){
          
          final favoriteRecipes = state.favoriteRecipes;
          if(favoriteRecipes.isEmpty){
            return Center(
              child:Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  'Belum ada resep masakan yang ditambahkan ke favorit', 
                  style:TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 119, 18, 214),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            );
          }else if(listRecipes.isEmpty){
            return Center(
              child:Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  'Resep tidak ditemukan', 
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
                itemCount: listRecipes.length,
                crossAxisCount: _generateCrossAxisCount(constraints.maxWidth),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  return CardRecipe(
                    data: {
                      "key":listRecipes[index].keyRecipe,
                      "title":listRecipes[index].title,
                      "thumb":listRecipes[index].thumb,
                    },
                    navigator: ()async{
                      await screenTransition(context, screen: DetailRecipe(thumb:listRecipes[index].thumb,keyMenu: listRecipes[index].keyRecipe,title:listRecipes[index].title));
                    },
                    isShowRemoveButton: true,
                    onRemoveRecipe: ()async{
                      Future.delayed(const Duration(milliseconds: 300)).then((val){
                        _handleSearch(_keyword);
                      });
                    },
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

