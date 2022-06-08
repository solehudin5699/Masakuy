import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masak_apa/elements/card_recipe.dart';
import 'package:masak_apa/models/recipes.dart';
import 'package:masak_apa/screens/detail_recipe.dart';


class Home extends StatefulWidget{
  const Home({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState()=>_Home();
}

class _Home extends State<Home>{
  late FocusNode myFocusNode;
  final TextEditingController _controllerKeyword = TextEditingController();
  late Future<RecipesModel> listRecipes;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    listRecipes = fetchRecipes('api/recipes');
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _controllerKeyword.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    FocusScopeNode isSearchBarFocus = FocusScope.of(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            pinned: true,
            floating: true,
            snap: false,
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Masakuy',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
                Text('Cari resep masakan yuk',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14)),
              ]
            ),
            actions: [
              IconButton(
                onPressed: (()=>{}),
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
            bottom: AppBar(
              shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(20,10),
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Container(
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
                width: double.infinity,
                height: 40,
                child:Expanded(
                  child:TextField(
                    focusNode: myFocusNode,
                    controller: _controllerKeyword,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:'Cari masakan',
                      prefixIcon:const Icon(Icons.search),
                      suffixIcon: !isSearchBarFocus.hasPrimaryFocus?IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
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
                  ),
                )
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              FutureBuilder<RecipesModel>(
            future: listRecipes,
            builder: (context, snapshot) {
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
              }else if (snapshot.hasData) {
                if(snapshot.data!.recipes.isNotEmpty){
                  return Column(
                  children: snapshot.data!.recipes.map((e) => CardRecipe(data:e,navigator: ()=>Navigator.of(context).push(createRoute(thumb:e['thumb'],keyMenu: e['key'],title:e['title'])),)).toList(),
                );
                }else{
                  return SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.indeterminate_check_box_outlined,size: 50,
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
                  );
                }
                
              } else if (snapshot.hasError) {
                return const SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Terjadi kesalahan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 119, 18, 214)
                      ),
                    ),
                  ),
                );
              }

              // By default, show a loading spinner.
              return const SizedBox(
                height: 300,
                width: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 119, 18, 214)
                  ),
                )
              );
            },
          ),
            ]
            ),
          )
        ],
      ),
    );
  }
}

Route createRoute({required String thumb, required String keyMenu,required String title}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => DetailRecipe(thumb:thumb,keyMenu: keyMenu,title:title),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}