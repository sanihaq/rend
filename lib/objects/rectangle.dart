import 'package:flutter/material.dart';
import 'package:rend/objects/base_object.dart';
import 'package:rend/objects/consts.dart';

class Rectangle extends BaseObject {
  Rectangle({
    required super.id,
    required super.name,
    required super.width,
    required super.height,
    super.position = const Offset(0, 0),
    required super.fills,
    super.strokeWidth,
    super.strokes,
  });

  factory Rectangle.empty({
    required int id,
    required String name,
    required double width,
    required double height,
    Offset position = const Offset(0, 0),
  }) {
    return Rectangle(
      id: id,
      name: name,
      width: width,
      height: height,
      fills: [boardDefaultColor],
      strokes: [objDefaultStrokeColor],
    );
  }
}
