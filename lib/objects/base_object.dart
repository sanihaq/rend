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
  double strokeWidth;
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
    this.origin = Offset.zero,
    this.strokeWidth = 0,
    this.fills = const [],
    this.strokes = const [],
  });
}
