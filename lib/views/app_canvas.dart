import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/objects/art_board.dart';
import 'package:rend/objects/base_object.dart';
import 'package:rend/provider/app_provider.dart';
import 'package:rend/provider/canvas_provider.dart';
import 'package:rend/views/create_artboard_dialog.dart';
import 'package:rend/widgets/objects/rectangle_widget.dart';
import 'package:rend/widgets/popup_button.dart';
import 'package:rend/widgets/tools/canvas_keyboard_listener.dart';
import 'package:rend/widgets/tools/object_gizmos.dart';

class AppCanvas extends ConsumerStatefulWidget {
  const AppCanvas({super.key, required this.isFreeze});

  static final GlobalKey centerPointKey = GlobalKey();

  static Offset getCenterPoint() {
    RenderBox renderBox = AppCanvas.centerPointKey.currentContext!
        .findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

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
          Center(
            child: SizedBox(
              key: AppCanvas.centerPointKey,
              width: 10,
              height: 10,
            ),
          ),
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
                                      : () {
                                          if (ref.read(
                                                  activeToolStateProvider) ==
                                              ToolCode.select) {
                                            canvas.selectObject(obj);
                                          } else {
                                            ref
                                                .read(activeToolStateProvider
                                                    .notifier)
                                                .state = ToolCode.select;
                                          }
                                        },
                                  onPanUpdate: widget.isFreeze
                                      ? null
                                      : (d) {
                                          if (ref.read(
                                                  activeToolStateProvider) ==
                                              ToolCode.select) {
                                            canvas.selectObject(obj);
                                            canvas.updatePosition(obj, d.delta);
                                          }
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
            ),
        ],
      ),
    );
  }

  GestureDetector getObjectWidget(BaseObject obj, AppCanvasNotifier canvas) {
    BaseObject? dragObj;
    return GestureDetector(
      onTap: widget.isFreeze || obj is Artboard
          ? () {
              if (ref.read(activeToolStateProvider) != ToolCode.select) {
                ref.read(activeToolStateProvider.notifier).state =
                    ToolCode.select;
              }
            }
          : () {
              if (ref.read(activeToolStateProvider) == ToolCode.select) {
                canvas.selectObject(obj);
              } else {
                ref.read(activeToolStateProvider.notifier).state =
                    ToolCode.select;
              }
            },
      onPanUpdate: widget.isFreeze
          ? null
          : (d) {
              if (ref.read(activeToolStateProvider) == ToolCode.select &&
                  obj is! Artboard) {
                canvas.selectObject(obj);
                canvas.updatePosition(obj, d.delta);
              } else if (ref.read(activeToolStateProvider) ==
                  ToolCode.artboard) {
                dragObj ??= canvas.getNewArtBoard(0, 0);
                canvas.addObjectWithDrag(dragObj!, d.globalPosition);
              }
            },
      onPanEnd: (_) {
        dragObj = null;
      },
      child: RectangleWidget(object: obj),
    );
  }
}
