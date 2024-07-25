import 'package:flutter/material.dart';
import 'package:rend/objects/base_object.dart';
import 'package:rend/objects/consts.dart';

class Artboard extends BaseObject {
  Artboard({
    required super.id,
    required super.name,
    required super.width,
    required super.height,
    super.position = const Offset(0, 0),
    required super.fills,
    super.strokeWidth,
    super.strokes,
  });

  factory Artboard.empty({
    required int id,
    required String name,
    required double width,
    required double height,
    Offset position = const Offset(0, 0),
  }) {
    return Artboard(
      id: id,
      name: name,
      width: width,
      height: height,
      fills: [boardDefaultColor],
      strokes: [objDefaultStrokeColor],
    );
  }
}
