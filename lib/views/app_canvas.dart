import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/canvas_provider.dart';
import 'package:rend/views/create_artboard_dialog.dart';
import 'package:rend/widgets/objects/rectangle_widget.dart';
import 'package:rend/widgets/tools/canvas_keyboard_listener.dart';
import 'package:rend/widgets/tools/object_gizmos.dart';

class AppCanvas extends ConsumerStatefulWidget {
  const AppCanvas({super.key});

  @override
  ConsumerState<AppCanvas> createState() => _AppCanvasState();
}

class _AppCanvasState extends ConsumerState<AppCanvas> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final canvas = ref.watch(canvasStateProvider);
    final isFreeze = ref.watch(isFreezeProviderState);

    return CanvasKeyboardListener(
      child: Stack(
        children: [
          if (canvas.boards.isEmpty)
            const Center(child: CreateArtboardDialog())
          else
            ...canvas.boards.map(
              (board) => Center(
                child: Transform.translate(
                  offset: board.position + board.origin,
                  child: Transform.rotate(
                    angle: board.rotation * 3.14 / 180,
                    origin: -board.origin,
                    child: GestureDetector(
                      onTap: isFreeze ? null : () => canvas.selectObject(board),
                      onPanUpdate: isFreeze
                          ? null
                          : (d) {
                              canvas.selectObject(board);
                              canvas.updatePosition(board, d.delta);
                            },
                      child: RectangleWidget(object: board),
                    ),
                  ),
                ),
              ),
            ),
          if (canvas.selected != null)
            SelectGizmos(
              object: canvas.selected!,
              isFreeze: isFreeze,
              child: const CanvasKeyboardListener(),
            )
        ],
      ),
    );
  }
}
