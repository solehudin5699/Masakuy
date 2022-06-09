import 'package:flutter/material.dart';

class CardRecipe extends StatelessWidget{
  final Map data;
  final Function navigator;
  const CardRecipe({Key? key,required this.data,required this.navigator}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
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
                        color: Colors.white.withOpacity(0.3),
                        border: Border.all(
                          color: const Color.fromARGB(255, 119, 18, 214),
                          width: 1,
                        )
                      ),
                      child: IconButton(
                        focusColor: const Color.fromARGB(255, 119, 18, 214),
                        iconSize: 25,
                        onPressed: (){}, 
                        icon: const Icon(Icons.favorite,color:Color.fromARGB(255, 119, 18, 214) ,)
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
}