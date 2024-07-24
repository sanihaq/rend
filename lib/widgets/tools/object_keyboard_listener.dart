import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/canvas_provider.dart';

class ObjectKeyboardListener extends ConsumerStatefulWidget {
  const ObjectKeyboardListener({super.key, this.child});

  final Widget? child;

  @override
  ConsumerState<ObjectKeyboardListener> createState() =>
      _KeyboardListenerState();
}

class _KeyboardListenerState extends ConsumerState<ObjectKeyboardListener> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final canvas = ref.read(canvasStateProvider);
    return Focus(
      autofocus: true,
      onKeyEvent: (focus, event) {
        // print(event.logicalKey);
        if (event is KeyDownEvent) {
          if (Platform.isMacOS &&
                  event.logicalKey == LogicalKeyboardKey.backspace ||
              event.logicalKey == LogicalKeyboardKey.delete) {
            if (canvas.selected != null) {
              canvas.deleteObject(canvas.selected!);
              canvas.selectObject(null);
              return KeyEventResult.handled;
            }
          }
          if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
              event.logicalKey == LogicalKeyboardKey.shiftRight) {
            ref.read(isShiftIsPressedStateProvider.notifier).state = true;
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.altLeft ||
              event.logicalKey == LogicalKeyboardKey.altRight) {
            ref.read(isAltIsPressedStateProvider.notifier).state = true;
            return KeyEventResult.handled;
          }
        }

        if (event is KeyUpEvent) {
          if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
              event.logicalKey == LogicalKeyboardKey.shiftRight) {
            ref.read(isShiftIsPressedStateProvider.notifier).state = false;
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.altLeft ||
              event.logicalKey == LogicalKeyboardKey.altRight) {
            ref.read(isAltIsPressedStateProvider.notifier).state = false;
            return KeyEventResult.handled;
          }
        }

        return KeyEventResult.ignored;
      },
      child: widget.child ?? const SizedBox(),
    );
  }
}
