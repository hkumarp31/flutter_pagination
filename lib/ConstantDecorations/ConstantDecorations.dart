import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConstantDecorations{

  static InputDecoration inputFieldDecoration(String labelText){
    return InputDecoration(
      counterText: "",
      labelText: labelText,
      labelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      errorStyle: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w300,
      ),
    );
  }
  static TextStyle tournamentStatic(){
    return TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.bold
    );
  }

  static TextStyle tournamentStaticText(){
    return TextStyle(
        fontSize: 16,
        color: Colors.white
    );
  }

  static BoxDecoration setGradient(int color1, int color2){
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Color(color1), Color(color2)]
        )
    );
  }
}