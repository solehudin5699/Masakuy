// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:screenshot/screenshot.dart';

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
  final ScreenshotController screenshotController;
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
    required this.step,
    required this.thumb,
    required this.screenshotController
    }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 247, 247, 247)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
      ),
    );
  }
}