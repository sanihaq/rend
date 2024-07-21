import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/objects/base_object.dart';
import 'package:rend/objects/painter/rectangle.dart';

class RectangleWidget extends ConsumerWidget {
  const RectangleWidget({
    super.key,
    required this.object,
  });

  final BaseObject object;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: object.width,
      height: object.height,
      child: CustomPaint(
        painter: RectanglePainter(object: object),
      ),
    );
  }
}
