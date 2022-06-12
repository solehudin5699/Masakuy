import 'package:flutter/material.dart';
import 'package:masak_apa/blocs/bloc_export.dart';
import 'package:masak_apa/screens/home.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory()
  );
  HydratedBlocOverrides.runZoned(
    () => runApp(const MyApp()),
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteRecipeBloc>(
      create: (context)=>FavoriteRecipeBloc(),
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Masakuy',
        theme: ThemeData(
          fontFamily: 'Poppins'
        ),
        home: const Home(),
      )
    );
  }
}

