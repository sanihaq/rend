import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/app_provider.dart';
import 'package:rend/provider/canvas_provider.dart';
import 'package:rend/widgets/popup_button.dart';

class CanvasKeyboardListener extends ConsumerStatefulWidget {
  const CanvasKeyboardListener({super.key, this.child, required this.isFreeze});

  final Widget? child;
  final bool isFreeze;

  @override
  ConsumerState<CanvasKeyboardListener> createState() =>
      _KeyboardListenerState();
}

class _KeyboardListenerState extends ConsumerState<CanvasKeyboardListener> {
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
        if (widget.isFreeze) return KeyEventResult.ignored;
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
          if (ref.read(canvasStateProvider).selected != null &&
              event.logicalKey == LogicalKeyboardKey.keyY) {
            final f = ref.read(activeToolStateProvider) == ToolCode.freeze;
            ref.read(activeToolStateProvider.notifier).state =
                f ? ToolCode.select : ToolCode.freeze;

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
