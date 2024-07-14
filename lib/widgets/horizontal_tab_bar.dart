import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/app_provider.dart';
import 'package:rend/theme/theme.dart';

final _isDragging = StateProvider<bool>((ref) => false);
final _dragOnState = StateProvider<int?>((ref) => null);

class HorizontalTabBar extends ConsumerWidget {
  const HorizontalTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tabState = ref.watch(activeTabProvider);
    var isDragging = ref.watch(_isDragging);
    var onDragState = ref.watch(_dragOnState);

    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      height: 38,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => ref.read(activeTabProvider.notifier).state = null,
              child: Container(
                width: 46,
                decoration: BoxDecoration(
                  color: tabState == null
                      ? Theme.of(context).appBarTheme.foregroundColor
                      : null,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.menu,
                  color: Theme.of(context).appBarTheme.iconTheme?.color,
                  size: 24,
                ),
              ),
            ),
            _TabDivider(
              visible: tabState == null || tabState == 0,
              isActive: onDragState == -1,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  const tabSize = 238.0;
                  final isActive = tabState == index;
                  final GlobalKey tabKey = GlobalKey();
                  Offset getTabOffset() {
                    RenderBox renderBox =
                        tabKey.currentContext!.findRenderObject() as RenderBox;
                    return renderBox.localToGlobal(Offset.zero);
                  }

                  return GestureDetector(
                    onTap: () {
                      ref.read(activeTabProvider.notifier).state = index;
                    },
                    child: DragTarget<int>(
                      onMove: (details) {
                        if (details.data == index) return;
                        if (details.offset.dx <
                            getTabOffset().dx + (tabSize / 2)) {
                          if (details.data == index - 1) return;
                          ref.read(_dragOnState.notifier).state = index - 1;
                        } else {
                          if (details.data == index + 1) return;
                          ref.read(_dragOnState.notifier).state = index;
                        }
                      },
                      onWillAcceptWithDetails: (details) {
                        if (details.data == index) return false;
                        if (details.offset.dx <
                            getTabOffset().dx + (tabSize / 2)) {
                          if (details.data == index - 1) {
                            ref.read(_dragOnState.notifier).state = index;
                          } else {
                            ref.read(_dragOnState.notifier).state = index - 1;
                          }
                        } else {
                          if (details.data == index + 1) {
                            ref.read(_dragOnState.notifier).state = index - 1;
                          } else {
                            ref.read(_dragOnState.notifier).state = index;
                          }
                        }
                        return details.data != index &&
                            details.data == index + 1;
                      },
                      onAcceptWithDetails: (_) {
                        ref.read(_dragOnState.notifier).state = null;
                      },
                      onLeave: (_) {
                        ref.read(_dragOnState.notifier).state = null;
                      },
                      builder: (context, _, __) {
                        return Row(
                          children: [
                            Draggable<int>(
                              onDragStarted: () {
                                ref.read(_isDragging.notifier).state = true;
                              },
                              onDragEnd: (_) {
                                ref.read(_isDragging.notifier).state = false;
                              },
                              data: index,
                              dragAnchorStrategy:
                                  (draggable, context, position) =>
                                      const Offset(0, -16),
                              feedback: Material(
                                color: Colors.transparent,
                                child: Text(
                                  "Untitled ${index + 1}",
                                  style: Theme.of(context)
                                      .appBarTheme
                                      .titleTextStyle,
                                ),
                              ),
                              child: Container(
                                key: tabKey,
                                width: tabSize,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Theme.of(context)
                                          .appBarTheme
                                          .foregroundColor
                                      : null,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 14.0, right: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Untitled ${index + 1}",
                                        style: Theme.of(context)
                                            .appBarTheme
                                            .titleTextStyle,
                                      ),
                                      IconButton(
                                        onPressed: !isDragging ? () {} : null,
                                        icon: const Icon(
                                          Icons.close,
                                        ),
                                        visualDensity: VisualDensity.compact,
                                        iconSize: 14,
                                        color: Theme.of(context)
                                            .appBarTheme
                                            .iconTheme
                                            ?.color,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            _TabDivider(
                              visible: isActive || tabState == index + 1,
                              isActive: onDragState == index,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TabDivider extends StatelessWidget {
  const _TabDivider({
    super.key,
    required this.visible,
    required this.isActive,
  });

  final bool visible;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !visible || isActive,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: VerticalDivider(
        width: 2,
        thickness: 2,
        indent: isActive ? 3 : 8,
        endIndent: isActive ? 0 : 8,
        color:
            isActive ? Theme.of(context).primaryColor : colors(context).color5,
      ),
    );
  }
}
