import 'package:flutter/material.dart';

class CustomHomeText extends StatelessWidget {
  final String label;
  final FontWeight fontWeight;
  final Color color;
  final double? fontsize;

  const CustomHomeText({
    super.key,
    required this.label,
    this.fontWeight =  FontWeight.w400,
    this.color = const Color.fromRGBO(51, 101, 138, 1),
    this.fontsize = 24 ,
  });

  @override
  Widget build(BuildContext context) {
    return Text(label,
        textAlign: TextAlign.left,
        style: TextStyle(
          
            color: color,
            fontWeight: fontWeight ,
            fontSize: fontsize));
  }
}
