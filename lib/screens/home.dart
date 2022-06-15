import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:masak_apa/elements/card_recipe.dart';
import 'package:masak_apa/elements/error_message.dart';
import 'package:masak_apa/models/recipes.dart';
import 'package:masak_apa/screens/detail_recipe.dart';
import 'package:masak_apa/elements/loading_indicator.dart';
import 'package:masak_apa/screens/favorite_recipes.dart';
import 'package:masak_apa/utils/screen_transition.dart';

class Home extends StatelessWidget{
  const Home({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: const HomeView()
    );
  }

}

class HomeView extends StatefulWidget{
  const HomeView({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState()=>_HomeView();
}

class _HomeView extends State<HomeView>{
  final TextEditingController _controllerKeyword = TextEditingController();
  late Future<RecipesModel> listRecipes;
  String _keyword='';

  @override
  void initState() {
    super.initState();
    listRecipes = fetchRecipes('api/recipes');
  }

  @override
  void dispose() {
    _controllerKeyword.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Masakuy',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25,fontFamily: "Pacifico" )),
            Text('Keluar buat makan? Mending masak sendiri aja',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12)),
          ]
        ),
        actions: [
          IconButton(
            onPressed: ()async{
              await screenTransition(context, screen: const FavoriteRecipes());
            },
            icon: const Icon(Icons.favorite_outline, color: Colors.white)
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
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
        bottom:AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(20,10),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Container(
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)
            ),
            width: double.infinity,
            height: 40,
            child:TextField(
              controller: _controllerKeyword,
              decoration: InputDecoration(
                border: InputBorder.none,
                  hintText:'Cari resep di sini',
                  prefixIcon:const Icon(Icons.search),
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
                  setState(() {
                    listRecipes=fetchRecipes('api/search/?q=$value');
                  });
                }
              },
              onChanged: (String value){
                setState(() {
                  _keyword=value;
                });
              },
            )
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context,BoxConstraints constraints) {
          return  FutureBuilder<RecipesModel>(
            future: listRecipes,
            builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return const Center(
                  child: LoadingIndicator(),
                );
              }else if (snapshot.hasData) {
                if(snapshot.data!.recipes.isNotEmpty){
                  int itemCount= snapshot.data!.recipes.length;
                  var data = snapshot.data!.recipes;
                  return MasonryGridView.count(
                    itemCount: itemCount,
                    crossAxisCount: _generateCrossAxisCount(constraints.maxWidth),
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    itemBuilder: (context, index) {
                      return CardRecipe(
                        data: {
                          "key":data[index]['key'],
                          "title":data[index]['title'],
                          "thumb":data[index]['thumb']
                        },
                        navigator: ()async{
                          await screenTransition(context, screen: DetailRecipe(thumb:data[index]['thumb'],keyMenu: data[index]['key'],title:data[index]['title']));
                        },
                      );
                    }
                  );
                }else{
                  return Center(
                    child: SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.indeterminate_check_box_outlined,
                              size: 50,
                              color: Color.fromARGB(255, 119, 18, 214),
                            ),
                            Text(
                              'Pencarian tidak ditemukan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 119, 18, 214)
                              ),
                            ),
                          ],
                        )
                      )
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return const Center(
                  child: ErrorMessage(message: 'Terjadi kesalahan',),
                );
              }
              return const Center(
                child: LoadingIndicator(),
              );
            },
          );
        }
      ),
    );
  }
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
}