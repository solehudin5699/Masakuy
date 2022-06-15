import 'package:flutter/material.dart';
import 'package:masak_apa/blocs/bloc_export.dart';
import 'package:masak_apa/models/favorite_recipe.dart';
// ignore: must_be_immutable
class CardRecipe extends StatelessWidget{
  final Map data;
  final Function navigator;
  final bool isShowRemoveButton;
  Function onRemoveRecipe=(){};
  CardRecipe({Key? key,required this.data,required this.navigator,this.isShowRemoveButton=false,Function? onRemoveRecipe}) : super(key: key){
    this.onRemoveRecipe = onRemoveRecipe??this.onRemoveRecipe;
  }

  void showConfirmModal(BuildContext context,Function callback){
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline,color: Color.fromARGB(255, 119, 18, 214),),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Hapus dari favorit ?',style: TextStyle(color: Color.fromARGB(255, 119, 18, 214)),),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => const Color.fromARGB(255, 119, 18, 214)),
                    ),
                    onPressed: (){
                      callback();
                      Navigator.pop(context);
                      onRemoveRecipe();
                    }, 
                    child: const Text('Hapus')
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteRecipeBloc,FavoriteRecipeState>(
      builder: (context,state){
        
        FavoriteRecipeModel currentRecipe = FavoriteRecipeModel(keyRecipe: data['key'],title: data['title'],thumb: data['thumb']);
        bool isFavorited = state.favoriteRecipes.any((element) => element.keyRecipe==data['key']);

        return Card(
          shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          clipBehavior: Clip.none,
          elevation: 5,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            focusColor: Colors.blue,
            onTap: ()=>navigator(),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        child: Image.network(
                          "${data['thumb']}",
                          fit: BoxFit.cover,
                          errorBuilder: (context,error,strakTrace){
                            return Container(
                              color: const Color.fromARGB(255, 157, 157, 204),
                              child: const Icon(Icons.image_not_supported_outlined),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    Positioned(
                      bottom: 3,
                      right: 3,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 119, 18, 214).withOpacity(0.7),
                            border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              width: 1,
                            )
                          ),
                          child:isShowRemoveButton?
                          IconButton(
                            onPressed: (){
                              showConfirmModal(
                                context,
                                (){context.read<FavoriteRecipeBloc>().add(RemoveFavoriteRecipe(recipe: currentRecipe));}
                              );
                            }, 
                            icon: const Icon(Icons.delete_outline,color:Colors.white)) 
                          :IconButton(
                            focusColor: const Color.fromARGB(255, 119, 18, 214),
                            iconSize: 25,
                            onPressed: (){
                              context.read<FavoriteRecipeBloc>().add(UpdateFavoriteRecipe(recipe: currentRecipe));
                            }, 
                            icon: Icon(isFavorited?Icons.favorite:Icons.favorite_outline,color:Colors.white ,)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("${data['title']}",style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Color.fromARGB(255, 59, 62, 255)),),
                      ],
                    ),
                  ),
                )
              ],              
            ),
          )
        );
      }
    );
  } 
}