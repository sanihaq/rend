import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/objects/base_object.dart';
import 'package:rend/provider/canvas_provider.dart';
import 'package:rend/theme/theme.dart';

class SelectGizmos extends ConsumerStatefulWidget {
  const SelectGizmos({super.key, required this.object, this.child});

  final BaseObject object;
  final Widget? child;

  @override
  ConsumerState<SelectGizmos> createState() => _SelectGizmosState();
}

class _SelectGizmosState extends ConsumerState<SelectGizmos> {
  final double _controllerSize = 16;
  @override
  void initState() {
    super.initState();
  }

  Alignment? side;
  MouseCursor? cursor;
  @override
  Widget build(BuildContext context) {
    final canvas = ref.read(canvasStateProvider);
    var corner = Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        color: Colors.white,
      ),
    );
    return Transform.translate(
      offset: widget.object.position,
      child: Stack(
        children: [
          Center(
            child: GestureDetector(
              onPanUpdate: (d) {
                canvas.updatePosition(widget.object, d.delta);
              },
              child: Container(
                width: widget.object.width + 2,
                height: widget.object.height + 2,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: colors(context).color9 ?? Colors.transparent,
                  ),
                ),
                child: widget.child,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.object.height),
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUp,
                child: GestureDetector(
                  onVerticalDragUpdate: (d) {
                    if (d.delta.dy < 0) {
                      canvas.updateHeight(
                          widget.object, d.delta.dy.abs(), true);
                    } else {
                      canvas.updateHeight(widget.object, -d.delta.dy, true);
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
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: widget.object.height),
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeDown,
                child: GestureDetector(
                  onVerticalDragUpdate: (d) {
                    if (d.delta.dy > 0) {
                      canvas.updateHeight(widget.object, d.delta.dy, false);
                    } else {
                      canvas.updateHeight(widget.object, d.delta.dy, false);
                    }
                  },
                  onVerticalDragEnd: (_) {
                    print('object');
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
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: widget.object.width),
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeft,
                child: GestureDetector(
                  onHorizontalDragUpdate: (d) {
                    if (d.delta.dx < 0) {
                      canvas.updateWidth(widget.object, d.delta.dx.abs(), true);
                    } else {
                      canvas.updateWidth(widget.object, -d.delta.dx, true);
                    }
                  },
                  onHorizontalDragEnd: (_) {
                    canvas.onDragEnd();
                  },
                  child: Container(
                    width: _controllerSize,
                    height: widget.object.height + _controllerSize,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: widget.object.width),
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeRight,
                child: GestureDetector(
                  onHorizontalDragUpdate: (d) {
                    if (d.delta.dx > 0) {
                      canvas.updateWidth(widget.object, d.delta.dx, false);
                    } else {
                      canvas.updateWidth(widget.object, d.delta.dx, false);
                    }
                  },
                  onHorizontalDragEnd: (_) {
                    canvas.onDragEnd();
                  },
                  child: Container(
                    width: _controllerSize,
                    height: widget.object.height + _controllerSize,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                  right: widget.object.width, bottom: widget.object.height),
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpLeft,
                child: GestureDetector(
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
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: corner,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                  left: widget.object.width, bottom: widget.object.height),
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpLeft,
                child: GestureDetector(
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
                  onPanEnd: (_) {
                    canvas.onDragEnd();
                  },
                  child: Container(
                    width: _controllerSize,
                    height: _controllerSize,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: corner,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                  left: widget.object.width, top: widget.object.height),
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpLeft,
                child: GestureDetector(
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
                    decoration: const BoxDecoration(),
                    child: corner,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                  right: widget.object.width, top: widget.object.height),
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpLeft,
                child: GestureDetector(
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
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: corner,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
