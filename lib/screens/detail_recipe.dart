// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:masak_apa/models/recipes.dart';

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
                color: Colors.white.withOpacity(0.3),
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
                onPressed: (){}, 
                icon: const Icon(Icons.share,color: Colors.white,)
              ),
              IconButton(
                onPressed: (){}, 
                icon: const Icon(Icons.favorite_outline,color: Colors.white,)
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
                    return const SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 119, 18, 214),
                        ),
                      )
                    );
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
                        thumb:widget.thumb
                      );
                    }
                  }

                  // default
                  return const SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 119, 18, 214)
                      ),
                    )
                  );
                }
              ),
              
            ])
          )
        ]
      ),
      );
    
  }
}

class DetailContent extends StatelessWidget{
  final String title;
  final String servings;
  final String times;
  final String dificulty;
  final Map<String,dynamic> author;
  final String desc;
  final List<dynamic> needItem;
  final List<dynamic> ingredient;
  final List<dynamic> step;
  final String thumb;
  const DetailContent({
    Key? key,
    required this.title,
    required this.servings,
    required this.times,
    required this.dificulty,
    required this.author,
    required this.desc,
    required this.needItem,
    required this.ingredient,
    required this.step,required this.thumb,}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
          Row(
            children: [
              const Icon(Icons.person,size: 12,),
              const SizedBox(width: 3,),
              Text(
                'Author : ${author["user"]}',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15,),
          ClipRRect(
            borderRadius: BorderRadius.circular(10), 
            child: Image.network(
              thumb,
              fit: BoxFit.cover,
              errorBuilder: (context,error,strakTrace){
                return Container(
                  color: const Color.fromARGB(255, 157, 157, 204),
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_outlined),
                );
              },
            ),
          ),
          const SizedBox(height: 15,),
          ExpandableText(
            desc,
            expandText: 'Selengkapnya',
            collapseText: 'Sembunyikan',
            maxLines: 5,
            linkColor: const Color.fromARGB(255, 59, 62, 255),
            linkStyle: const TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.justify,
            animation: true,
            animationCurve: Curves.easeIn,
            collapseOnTextTap: true,
            prefixText: 'Deskripsi : ',
            prefixStyle: const TextStyle(fontWeight: FontWeight.w600,),
          ),
          const SizedBox(height: 15,),
          const Text(
          "Bahan-bahan : ",
          style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),textAlign: TextAlign.left,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: ingredient.map((e) => Text('⨀  $e')).toList(),
          ),
          const SizedBox(height: 15,),
          const Text(
          "Bahan khusus : ",
          style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),textAlign: TextAlign.left,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: needItem.map((e) => Text('⨀  ${e["item_name"]}')).toList(),
          ),
          const SizedBox(height: 15,),
          const Text(
          "Langkah-langkah : ",
          style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),textAlign: TextAlign.left,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: step.map((e) => Text(e)).toList(),
          ),
        ],
      ),
    );
  }
  
}