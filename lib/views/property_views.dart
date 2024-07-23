import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/canvas_provider.dart';
import 'package:rend/widgets/app_input_number_field.dart';

class RotationProperty extends ConsumerWidget {
  const RotationProperty({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final canvas = ref.watch(canvasStateProvider);
    return canvas.selected == null
        ? const SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Rotation'),
              ),
              AppInputNumberField(
                suffixText: 'R',
                value: canvas.selected!.rotation,
                maxWidth: 120,
                onSubmitted: (v) {
                  if (v == null) return;
                  canvas.updateRotation(canvas.selected!, v);
                },
              ),
            ],
          );
  }
}

class PositionProperty extends ConsumerWidget {
  const PositionProperty({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final selected = ref.watch(canvasStateProvider).selected;
    return selected == null
        ? const SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Position'),
              AppInputNumberField(
                suffixText: 'X',
                value: selected.position.dx,
                maxWidth: 80,
                onSubmitted: (v) {},
              ),
              AppInputNumberField(
                suffixText: 'Y',
                width: 80,
                value: selected.position.dy,
                onSubmitted: (v) {},
              ),
            ],
          );
  }
}
