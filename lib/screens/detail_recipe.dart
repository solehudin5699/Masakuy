import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masak_apa/blocs/bloc_export.dart';
import 'package:masak_apa/elements/detail_content_recipe.dart';
import 'package:masak_apa/elements/error_message.dart';
import 'package:masak_apa/elements/loading_indicator.dart';
import 'package:masak_apa/models/favorite_recipe.dart';
import 'package:masak_apa/models/recipes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class DetailRecipe extends StatefulWidget{
  final String thumb;
  final String keyMenu;
  final String title;
  
  const DetailRecipe({Key? key,required this.thumb,required this.keyMenu,required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState()=>_DetailRecipe();

}
class _DetailRecipe extends State<DetailRecipe>{
  late Future<DetailRecipeModel> detailRecipe;
  ScreenshotController screenshotController = ScreenshotController();

  void share()async{
    final imageFile = await screenshotController.capture(delay: const Duration(milliseconds: 10));
    if(imageFile!=null){
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/image_recipe.png').create();
      await imagePath.writeAsBytes(imageFile);
      await Share.shareFiles([imagePath.path]);
    }
  }

  @override
  void initState(){
    super.initState();
    detailRecipe = fetchDetailRecipe(widget.keyMenu);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: CustomScrollView(
        slivers:[
          SliverAppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            pinned: true,
            floating: true,
            snap: false,
            centerTitle: false,
            leading: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 119, 18, 214).withOpacity(0.7),
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: 0.5,
                )
              ),
              child: IconButton(
                iconSize: 20,
                onPressed: (){Navigator.pop(context);},
                icon: const Icon(Icons.arrow_back_ios_rounded,color:Color.fromARGB(255, 255, 255, 255) ,)
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Bagikan resep',
                onPressed: (){share();}, 
                icon: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 119, 18, 214).withOpacity(0.7),
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: 0.5,
                    )
                  ),
                  child: const Center(
                    child: Icon(Icons.share,color: Colors.white,),
                  )
                )
              ),
              BlocBuilder<FavoriteRecipeBloc,FavoriteRecipeState>(
                builder: (context,state){

                  FavoriteRecipeModel currentRecipe = FavoriteRecipeModel(keyRecipe: widget.keyMenu,title: widget.title,thumb: widget.thumb);
                  bool isFavorited = state.favoriteRecipes.any((element) => element.keyRecipe==widget.keyMenu);
                  
                  return IconButton(
                    tooltip: isFavorited?"Hapus dari favorit":'Tambahkan ke favorit',
                    onPressed: (){
                      context.read<FavoriteRecipeBloc>().add(UpdateFavoriteRecipe(recipe: currentRecipe));
                    }, 
                    icon: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 119, 18, 214).withOpacity(0.7),
                        border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: 0.5,
                        )
                      ),
                      child: Center(
                        child: Icon(isFavorited?Icons.favorite:Icons.favorite_outline,color: Colors.white,)
                      )
                    )
                  );
                }
              )
            ],
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
                image: DecorationImage(
                    image: NetworkImage(widget.thumb),
                    fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
            ),
            bottom: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20.0),
                ),
              ),
              title: SizedBox(
                width: double.infinity,
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.title,style:const TextStyle(fontWeight: FontWeight.w700,),maxLines: 1),
                  ],
                )
              ),
            )
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              FutureBuilder<DetailRecipeModel>(
                future: detailRecipe,
                builder:(context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const LoadingIndicator();
                  }else if(snapshot.hasData){
                    if(snapshot.data!.title!=''){
                      return DetailContent(
                        title: snapshot.data!.title,
                        servings: snapshot.data!.servings,
                        times: snapshot.data!.times,
                        dificulty: snapshot.data!.dificulty,
                        author: snapshot.data!.author,
                        desc: snapshot.data!.desc,
                        needItem:snapshot.data!.needItem,
                        ingredient:snapshot.data!.ingredient,
                        step: snapshot.data!.step,
                        thumb:widget.thumb,
                        screenshotController: screenshotController,
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const ErrorMessage(message: 'Terjadi kesalahan',);
                  }
                  return const LoadingIndicator();
                }
              ),
              
            ])
          )
        ]
      ),
    );
  }
}