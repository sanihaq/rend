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
    super.fills = const [boardDefaultColor],
  });
}
