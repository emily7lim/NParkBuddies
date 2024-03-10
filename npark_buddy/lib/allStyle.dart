import 'package:flutter/material.dart';

abstract class TextFieldStyle {
  //for enabled border
  static const OutlineInputBorder unclickedTF = OutlineInputBorder(
    borderSide: BorderSide(
      width: 0.5,
    ),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  //for focused border
  static const OutlineInputBorder clickedTF = OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: Color(0xFF023307),
    ),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );
}
