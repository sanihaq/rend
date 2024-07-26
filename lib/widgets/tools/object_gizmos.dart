import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/objects/art_board.dart';
import 'package:rend/objects/base_object.dart';
import 'package:rend/provider/app_provider.dart';
import 'package:rend/provider/canvas_provider.dart';
import 'package:rend/theme/theme.dart';
import 'package:rend/widgets/popup_button.dart';

class SelectGizmos extends ConsumerStatefulWidget {
  const SelectGizmos(
      {super.key, required this.object, this.child, required this.isFreeze});

  final BaseObject object;
  final Widget? child;
  final bool isFreeze;

  @override
  ConsumerState<SelectGizmos> createState() => _SelectGizmosState();
}

class _SelectGizmosState extends ConsumerState<SelectGizmos> {
  final double _controllerSize = 16;
  final double controllerCornerBy = 8;

  @override
  void initState() {
    super.initState();
  }

  final corner = Padding(
    padding: const EdgeInsets.all(4),
    child: Container(
      color: Colors.white,
    ),
  );

  Alignment? side;
  MouseCursor? cursor;
  @override
  Widget build(BuildContext context) {
    final canvas = ref.read(canvasStateProvider);
    final cleanGizmoLevel = ref.watch(cleanGizmosLevelProviderState);
    return Stack(
      children: [
        Transform.translate(
          offset: widget.object.position + widget.object.origin,
          child: Transform.rotate(
            angle: widget.object.rotation * 3.14 / 180,
            origin: -widget.object.origin,
            child: Transform.scale(
              scale: canvas.zoom,
              child: Stack(
                children: [
                  if (cleanGizmoLevel <= 1)
                    Center(
                      child: OverflowBox(
                        minWidth: 0.0,
                        maxWidth: double.infinity,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: DeferPointer(
                          child: GestureDetector(
                            onTap: () {},
                            behavior: HitTestBehavior.translucent,
                            onPanUpdate: (d) {
                              if (widget.isFreeze &&
                                  widget.object is! Artboard) {
                                canvas.updateOrigin(widget.object, d.delta);
                              } else {
                                if (ref.read(activeToolStateProvider) ==
                                    ToolCode.select) {
                                  canvas.updatePosition(widget.object, d.delta);
                                } else if (ref.read(activeToolStateProvider) ==
                                    ToolCode.artboard) {
                                  print(d.globalPosition);
                                }
                              }
                            },
                            child: Container(
                              width: widget.object.width + 2,
                              height: widget.object.height + 2,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: colors(context).color9 ??
                                      Colors.transparent,
                                ),
                              ),
                              child: widget.child,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (cleanGizmoLevel == 0 && !widget.isFreeze)
                    Center(
                      child: OverflowBox(
                        minWidth: 0.0,
                        maxWidth: double.infinity,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: DeferPointer(
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: widget.object.height),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeUp,
                              child: GestureDetector(
                                onTap: () {},
                                onVerticalDragUpdate: (d) {
                                  if (d.delta.dy < 0) {
                                    canvas.updateHeight(
                                        widget.object, d.delta.dy.abs(), true);
                                  } else {
                                    canvas.updateHeight(
                                        widget.object, -d.delta.dy, true);
                                  }
                                },
                                onVerticalDragEnd: (_) {
                                  canvas.onDragEnd();
                                },
                                child: Container(
                                  width: widget.object.width + _controllerSize,
                                  height: _controllerSize,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (cleanGizmoLevel == 0 && !widget.isFreeze)
                    Center(
                      child: OverflowBox(
                        minWidth: 0.0,
                        maxWidth: double.infinity,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: DeferPointer(
                          child: Padding(
                            padding: EdgeInsets.only(top: widget.object.height),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeDown,
                              child: GestureDetector(
                                onTap: () {},
                                onVerticalDragUpdate: (d) {
                                  if (d.delta.dy > 0) {
                                    canvas.updateHeight(
                                        widget.object, d.delta.dy, false);
                                  } else {
                                    canvas.updateHeight(
                                        widget.object, d.delta.dy, false);
                                  }
                                },
                                onVerticalDragEnd: (_) {
                                  canvas.onDragEnd();
                                },
                                child: Container(
                                  width: widget.object.width + _controllerSize,
                                  height: _controllerSize,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (cleanGizmoLevel == 0 && !widget.isFreeze)
                    Center(
                      child: OverflowBox(
                        minWidth: 0.0,
                        maxWidth: double.infinity,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: DeferPointer(
                          child: Padding(
                            padding:
                                EdgeInsets.only(right: widget.object.width),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeLeft,
                              child: GestureDetector(
                                onTap: () {},
                                onHorizontalDragUpdate: (d) {
                                  if (d.delta.dx < 0) {
                                    canvas.updateWidth(
                                        widget.object, d.delta.dx.abs(), true);
                                  } else {
                                    canvas.updateWidth(
                                        widget.object, -d.delta.dx, true);
                                  }
                                },
                                onHorizontalDragEnd: (_) {
                                  canvas.onDragEnd();
                                },
                                child: Container(
                                  width: _controllerSize,
                                  height:
                                      widget.object.height + _controllerSize,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (cleanGizmoLevel == 0 && !widget.isFreeze)
                    Center(
                      child: OverflowBox(
                        minWidth: 0.0,
                        maxWidth: double.infinity,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: DeferPointer(
                          child: Padding(
                            padding: EdgeInsets.only(left: widget.object.width),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeRight,
                              child: GestureDetector(
                                onTap: () {},
                                onHorizontalDragUpdate: (d) {
                                  if (d.delta.dx > 0) {
                                    canvas.updateWidth(
                                        widget.object, d.delta.dx, false);
                                  } else {
                                    canvas.updateWidth(
                                        widget.object, d.delta.dx, false);
                                  }
                                },
                                onHorizontalDragEnd: (_) {
                                  canvas.onDragEnd();
                                },
                                child: Container(
                                  width: _controllerSize,
                                  height:
                                      widget.object.height + _controllerSize,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // UP LEFT CORNER ROTATE GIZMO
                  if (widget.object is! Artboard &&
                      cleanGizmoLevel == 0 &&
                      !widget.isFreeze)
                    Center(
                      child: OverflowBox(
                        minWidth: 0.0,
                        maxWidth: double.infinity,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: DeferPointer(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: widget.object.width + controllerCornerBy,
                                bottom:
                                    widget.object.height + controllerCornerBy),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.grab,
                              child: GestureDetector(
                                onTap: () {},
                                onPanUpdate: (d) {
                                  canvas.updateRotationBy(
                                      widget.object, -d.delta.dy);
                                },
                                onPanEnd: (_) {},
                                child: Container(
                                  width: _controllerSize + controllerCornerBy,
                                  height: _controllerSize + controllerCornerBy,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // UP LEFT CORNER RESIZE GIZMO
                  if (cleanGizmoLevel == 0 && !widget.isFreeze)
                    Center(
                      child: OverflowBox(
                        minWidth: 0.0,
                        maxWidth: double.infinity,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: DeferPointer(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: widget.object.width,
                                bottom: widget.object.height),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeUpLeft,
                              child: GestureDetector(
                                onTap: () {},
                                onPanUpdate: (d) {
                                  if (d.delta.dx < 0) {
                                    canvas.updateWidthHeight(
                                      widget.object,
                                      deltaX: -d.delta.dx,
                                      reverseX: true,
                                      deltaY: -d.delta.dy,
                                      reverseY: true,
                                    );
                                  } else {
                                    canvas.updateWidthHeight(
                                      widget.object,
                                      deltaX: -d.delta.dx,
                                      reverseX: true,
                                      deltaY: -d.delta.dy,
                                      reverseY: true,
                                    );
                                  }
                                },
                                onPanEnd: (_) {
                                  canvas.onDragEnd();
                                },
                                child: Container(
                                  width: _controllerSize,
                                  height: _controllerSize,
                                  color: Colors.transparent,
                                  child: corner,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // UP RIGHT CORNER ROTATE GIZMO
                  if (widget.object is! Artboard &&
                      cleanGizmoLevel == 0 &&
                      !widget.isFreeze)
                    Center(
                      child: OverflowBox(
                        minWidth: 0.0,
                        maxWidth: double.infinity,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: DeferPointer(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: widget.object.width + controllerCornerBy,
                                bottom:
                                    widget.object.height + controllerCornerBy),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.grab,
                              child: GestureDetector(
                                onTap: () {},
                                onPanUpdate: (d) {
                                  final v = d.delta.dx.abs() > d.delta.dy.abs()
                                      ? d.delta.dx
                                      : d.delta.dy;
                                  canvas.updateRotationBy(
                                      widget.object, v / 1.4);
                                },
                                onPanEnd: (_) {},
                                child: Container(
                                  width: _controllerSize + controllerCornerBy,
                                  height: _controllerSize + controllerCornerBy,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // UP RIGHT CORNER RESIZE GIZMO
                  if (cleanGizmoLevel == 0 && !widget.isFreeze)
                    Center(
                      child: OverflowBox(
                        minWidth: 0.0,
                        maxWidth: double.infinity,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: DeferPointer(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: widget.object.width,
                                bottom: widget.object.height),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeUpLeft,
                              child: GestureDetector(
                                onTap: () {},
                                onPanUpdate: (d) {
                                  if (d.delta.dx < 0) {
                                    canvas.updateWidthHeight(
                                      widget.object,
                                      deltaX: d.delta.dx,
                                      reverseX: false,
                                      deltaY: -d.delta.dy,
                                      reverseY: true,
                                    );
                                  } else {
                                    canvas.updateWidthHeight(
                                      widget.object,
                                      deltaX: d.delta.dx,
                                      reverseX: false,
                                      deltaY: d.delta.dy.abs(),
                                      reverseY: true,
                                    );
                                  }
                                },
                                onPanEnd: (_) {},
                                child: Container(
                                  width: _controllerSize,
                                  height: _controllerSize,
                                  color: Colors.transparent,
                                  child: corner,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // BOTTOM RIGHT CORNER ROTATE GIZMO
                  if (widget.object is! Artboard &&
                      cleanGizmoLevel == 0 &&
                      !widget.isFreeze)
                    Center(
                      child: OverflowBox(
                        minWidth: 0.0,
                        maxWidth: double.infinity,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: DeferPointer(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: widget.object.width + controllerCornerBy,
                                top: widget.object.height + controllerCornerBy),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.grab,
                              child: GestureDetector(
                                onTap: () {},
                                onPanUpdate: (d) {
                                  canvas.updateRotationBy(
                                      widget.object, d.delta.dy);
                                },
                                onPanEnd: (_) {},
                                child: Container(
                                  width: _controllerSize + controllerCornerBy,
                                  height: _controllerSize + controllerCornerBy,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // BOTTOM RIGHT CORNER RESIZE GIZMO
                  if (cleanGizmoLevel == 0 && !widget.isFreeze)
                    Center(
                      child: OverflowBox(
                        minWidth: 0.0,
                        maxWidth: double.infinity,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: DeferPointer(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: widget.object.width,
                                top: widget.object.height),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeUpLeft,
                              child: GestureDetector(
                                onTap: () {},
                                onPanUpdate: (d) {
                                  if (d.delta.dx < 0) {
                                    canvas.updateWidthHeight(
                                      widget.object,
                                      deltaX: d.delta.dx,
                                      reverseX: false,
                                      deltaY: d.delta.dy,
                                      reverseY: false,
                                    );
                                  } else {
                                    canvas.updateWidthHeight(
                                      widget.object,
                                      deltaX: d.delta.dx,
                                      reverseX: false,
                                      deltaY: d.delta.dy,
                                      reverseY: false,
                                    );
                                  }
                                },
                                onPanEnd: (_) {
                                  canvas.onDragEnd();
                                },
                                child: Container(
                                  width: _controllerSize,
                                  height: _controllerSize,
                                  color: Colors.transparent,
                                  child: corner,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // BOTTOM LEFT CORNER ROTATE GIZMO
                  if (widget.object is! Artboard &&
                      cleanGizmoLevel == 0 &&
                      !widget.isFreeze)
                    Center(
                      child: OverflowBox(
                        minWidth: 0.0,
                        maxWidth: double.infinity,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: DeferPointer(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: widget.object.width + controllerCornerBy,
                                top: widget.object.height + controllerCornerBy),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.grab,
                              child: GestureDetector(
                                onTap: () {},
                                onPanUpdate: (d) {
                                  canvas.updateRotationBy(
                                      widget.object, -d.delta.dy);
                                },
                                onPanEnd: (_) {},
                                child: Container(
                                  width: _controllerSize + controllerCornerBy,
                                  height: _controllerSize + controllerCornerBy,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // BOTTOM LEFT CORNER RESIZE GIZMO
                  if (cleanGizmoLevel == 0 && !widget.isFreeze)
                    Center(
                      child: OverflowBox(
                        minWidth: 0.0,
                        maxWidth: double.infinity,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: DeferPointer(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: widget.object.width,
                                top: widget.object.height),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeUpLeft,
                              child: GestureDetector(
                                onTap: () {},
                                onPanUpdate: (d) {
                                  if (d.delta.dx < 0) {
                                    canvas.updateWidthHeight(
                                      widget.object,
                                      deltaX: -d.delta.dx,
                                      reverseX: true,
                                      deltaY: d.delta.dy,
                                      reverseY: false,
                                    );
                                  } else {
                                    canvas.updateWidthHeight(
                                      widget.object,
                                      deltaX: -d.delta.dx,
                                      reverseX: true,
                                      deltaY: d.delta.dy,
                                      reverseY: false,
                                    );
                                  }
                                },
                                onPanEnd: (_) {
                                  canvas.onDragEnd();
                                },
                                child: Container(
                                  width: _controllerSize,
                                  height: _controllerSize,
                                  color: Colors.transparent,
                                  child: corner,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (widget.object is! Artboard)
          Transform.translate(
            offset: widget.object.position,
            child: Center(
              child: GestureDetector(
                onTap: () {},
                onPanUpdate: (d) {},
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(
                      width: 1.4,
                      color: Colors.white,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
