import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {

  final void Function()? onPressed;
  final String text;
  final double? width; 
  final Color? buttonColor;

  const CustomFilledButton({
    super.key, 
    this.onPressed, 
    required this.text,
    this.width, 
    this.buttonColor
  });

  @override
  Widget build(BuildContext context) {

    const radius = Radius.circular(20);

    return SizedBox(
      width: width,    
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: buttonColor ?? Colors.deepOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(radius),
            side: BorderSide(
              color: buttonColor == Colors.transparent 
                ? Colors.white 
                : Colors.transparent
            )
          )),
        onPressed: onPressed, 
        child: Text(text)
      ),
    );
  }
}