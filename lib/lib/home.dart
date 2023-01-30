import 'package:flutter/material.dart';

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(image: AssetImage('assets/home.jpg')),
    );
  }
}
