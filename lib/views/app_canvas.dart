import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/objects/art_board.dart';
import 'package:rend/objects/base_object.dart';
import 'package:rend/provider/canvas_provider.dart';
import 'package:rend/views/create_artboard_dialog.dart';
import 'package:rend/widgets/objects/rectangle_widget.dart';
import 'package:rend/widgets/tools/canvas_keyboard_listener.dart';
import 'package:rend/widgets/tools/object_gizmos.dart';

class AppCanvas extends ConsumerStatefulWidget {
  const AppCanvas({super.key, required this.isFreeze});

  final bool isFreeze;

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

    return CanvasKeyboardListener(
      isFreeze: widget.isFreeze,
      child: Stack(
        children: [
          if (canvas.roots.isEmpty)
            const Center(child: CreateArtboardDialog())
          else
            ...canvas.roots.map(
              (obj) => Center(
                child: Transform.translate(
                  offset: obj.position + obj.origin,
                  child: Transform.rotate(
                    angle: obj.rotation * 3.14 / 180,
                    origin: -obj.origin,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 22.0),
                      child: obj is Artboard
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: widget.isFreeze
                                      ? null
                                      : () => canvas.selectObject(obj),
                                  onPanUpdate: widget.isFreeze
                                      ? null
                                      : (d) {
                                          canvas.selectObject(obj);
                                          canvas.updatePosition(obj, d.delta);
                                        },
                                  child: SizedBox(
                                    width: obj.width,
                                    child: Row(
                                      children: [
                                        Text(
                                          obj.name,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                getObjectWidget(obj, canvas),
                              ],
                            )
                          : getObjectWidget(obj, canvas),
                    ),
                  ),
                ),
              ),
            ),
          if (canvas.selected != null)
            SelectGizmos(
              object: canvas.selected!,
              isFreeze: widget.isFreeze,
            )
        ],
      ),
    );
  }

  GestureDetector getObjectWidget(BaseObject obj, AppCanvasNotifier canvas) {
    return GestureDetector(
      onTap: widget.isFreeze || obj is Artboard
          ? () {}
          : () => canvas.selectObject(obj),
      onPanUpdate: widget.isFreeze || obj is Artboard
          ? null
          : (d) {
              canvas.selectObject(obj);
              canvas.updatePosition(obj, d.delta);
            },
      child: RectangleWidget(object: obj),
    );
  }
}
