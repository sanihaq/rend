import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/canvas_provider.dart';
import 'package:rend/widgets/app_input_number_field.dart';

class PositionProperty extends ConsumerWidget {
  const PositionProperty({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final canvas = ref.watch(canvasStateProvider);
    return canvas.boards.isEmpty
        ? const SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Position'),
              AppInputNumberField(
                suffixText: 'X',
                value: canvas.boards.first.position.dx,
                maxWidth: 80,
                onSubmitted: (v) {},
              ),
              AppInputNumberField(
                suffixText: 'Y',
                width: 80,
                value: canvas.boards.first.position.dy,
                onSubmitted: (v) {},
              ),
            ],
          );
  }
}
