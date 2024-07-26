import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/objects/art_board.dart';
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
        if (widget.isFreeze &&
            event.logicalKey != LogicalKeyboardKey.keyY &&
            event.logicalKey != LogicalKeyboardKey.keyV) {
          return KeyEventResult.ignored;
        }
        if (event is KeyDownEvent) {
          // print(event.logicalKey);
          if (Platform.isMacOS &&
                  event.logicalKey == LogicalKeyboardKey.backspace ||
              event.logicalKey == LogicalKeyboardKey.delete) {
            if (canvas.selected != null) {
              canvas.deleteObject(canvas.selected!);
              canvas.selectObject(null);
              return KeyEventResult.handled;
            }
          }
          if (event.logicalKey == LogicalKeyboardKey.metaLeft ||
              event.logicalKey == LogicalKeyboardKey.metaRight) {
            ref.read(isMetaIsPressedStateProvider.notifier).state = true;
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.controlLeft ||
              event.logicalKey == LogicalKeyboardKey.controlRight) {
            ref.read(isCtrlIsPressedStateProvider.notifier).state = true;
            return KeyEventResult.handled;
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
              ref.read(canvasStateProvider).selected is! Artboard &&
              event.logicalKey == LogicalKeyboardKey.keyY) {
            final f = ref.read(activeToolStateProvider) == ToolCode.freeze;
            ref.read(activeToolStateProvider.notifier).state =
                f ? ToolCode.select : ToolCode.freeze;

            return KeyEventResult.handled;
          }
          if (ref.read(isMetaIsPressedStateProvider) &&
              event.logicalKey == LogicalKeyboardKey.digit0) {
            canvas.resetZoom();
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.keyV) {
            if (ref.read(activeToolStateProvider) != ToolCode.select) {
              ref.read(activeToolStateProvider.notifier).state =
                  ToolCode.select;
            }
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.keyA) {
            if (ref.read(activeToolStateProvider) != ToolCode.artboard) {
              ref.read(activeToolStateProvider.notifier).state =
                  ToolCode.artboard;
            }
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.keyR) {
            if (ref.read(activeToolStateProvider) != ToolCode.artboard) {
              ref.read(activeToolStateProvider.notifier).state =
                  ToolCode.rectangle;
            }
            return KeyEventResult.handled;
          }
        }

        if (event is KeyUpEvent) {
          if (event.logicalKey == LogicalKeyboardKey.metaLeft ||
              event.logicalKey == LogicalKeyboardKey.metaRight) {
            ref.read(isMetaIsPressedStateProvider.notifier).state = false;
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.controlLeft ||
              event.logicalKey == LogicalKeyboardKey.controlRight) {
            ref.read(isCtrlIsPressedStateProvider.notifier).state = true;
            return KeyEventResult.handled;
          }
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
