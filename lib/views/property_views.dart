import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/app_provider.dart';
import 'package:rend/provider/canvas_provider.dart';
import 'package:rend/theme/theme.dart';
import 'package:rend/widgets/app_colorpicker.dart';
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

class ColorStrokeProperty extends ConsumerStatefulWidget {
  const ColorStrokeProperty({super.key});

  @override
  ConsumerState<ColorStrokeProperty> createState() => _ColorStrokeState();
}

class _ColorStrokeState extends ConsumerState<ColorStrokeProperty> {
  GlobalKey buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  Offset getButtonOffset() {
    RenderBox renderBox =
        buttonKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(canvasStateProvider).selected;
    return selected == null
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final off = getButtonOffset();
                    const width = 200.0;
                    const height = 300.0;
                    ref.read(appStackProvider.notifier).state = Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(appStackProvider.notifier).state = null;
                          },
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                        Positioned(
                          left: off.dx - (width + 12),
                          top: off.dy,
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors(context).color1,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            width: width,
                            height: height,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: AppColorPicker(
                                pickerColor: selected.strokes.firstOrNull ??
                                    Colors.transparent,
                                onColorChanged: (c) {
                                  ref
                                      .read(canvasStateProvider)
                                      .updateFill(selected, 0, c);
                                },
                                colorPickerWidth: width,
                                pickerAreaHeightPercent: 0.7,
                                portraitOnly: true,
                                labelTypes: const [],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  child: Container(
                    key: buttonKey,
                    width: 20,
                    height: 20,
                    color: selected.strokes.firstOrNull ?? Colors.transparent,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Stroke'),
                const SizedBox(width: 8),
                AppInputNumberField(
                  value: selected.strokeWidth,
                  onSubmitted: (v) {
                    if (v != null) {
                      ref
                          .read(canvasStateProvider)
                          .updateStrokeWidth(selected, v);
                    }
                  },
                )
              ],
            ),
          );
  }
}

class ColorFillProperty extends ConsumerStatefulWidget {
  const ColorFillProperty({super.key});

  @override
  ConsumerState<ColorFillProperty> createState() => _ColorFillState();
}

class _ColorFillState extends ConsumerState<ColorFillProperty> {
  GlobalKey buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  Offset getButtonOffset() {
    RenderBox renderBox =
        buttonKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(canvasStateProvider).selected;
    return selected == null
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final off = getButtonOffset();
                    const width = 200.0;
                    const height = 300.0;
                    ref.read(appStackProvider.notifier).state = Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(appStackProvider.notifier).state = null;
                          },
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                        Positioned(
                          left: off.dx - (width + 12),
                          top: off.dy,
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors(context).color1,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            width: width,
                            height: height,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: AppColorPicker(
                                pickerColor: selected.fills.firstOrNull ??
                                    Colors.transparent,
                                onColorChanged: (c) {
                                  ref
                                      .read(canvasStateProvider)
                                      .updateFill(selected, 0, c);
                                },
                                colorPickerWidth: width,
                                pickerAreaHeightPercent: 0.7,
                                portraitOnly: true,
                                labelTypes: const [],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  child: Container(
                    key: buttonKey,
                    width: 20,
                    height: 20,
                    color: selected.fills.firstOrNull ?? Colors.transparent,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Fill'),
              ],
            ),
          );
  }
}
