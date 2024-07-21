import 'package:flutter/material.dart';

abstract class BaseObject {
  int id;
  String name;
  double width;
  double height;
  double scaleX;
  double scaleY;
  double rotation;
  Offset position;
  Offset origin;
  List<Color> fills;
  List<Color> strokes;

  BaseObject({
    required this.id,
    required this.name,
    required this.width,
    required this.height,
    this.scaleX = 1,
    this.scaleY = 1,
    this.rotation = 0,
    required this.position,
    Offset? origin,
    this.fills = const [],
    this.strokes = const [],
  }) : origin = origin ?? Offset(width / 2, height / 2);
}
