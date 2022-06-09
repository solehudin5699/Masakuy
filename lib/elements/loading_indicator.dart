import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget{
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}