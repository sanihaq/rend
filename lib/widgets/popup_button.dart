import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/app_provider.dart';
import 'package:rend/theme/theme.dart';
import 'package:rend/widgets/common/list_divider.dart';

enum ToolCode { select, artboard, pen, rectangle, ellipse, polygon }

class AppPopupMenuItem {
  final ToolCode toolCode;
  final String title;
  final String? info;
  final IconData icon;
  final VoidCallback? onTap;
  final bool hasDivider;
  AppPopupMenuItem({
    required this.toolCode,
    required this.icon,
    required this.title,
    this.info,
    this.onTap,
    this.hasDivider = false,
  });
}

class AppPopupMenuButton extends ConsumerStatefulWidget {
  const AppPopupMenuButton({super.key, required this.items})
      : assert(items.length > 0);

  final List<AppPopupMenuItem> items;

  @override
  ConsumerState<AppPopupMenuButton> createState() => _PopupMenuButtonState();
}

class _PopupMenuButtonState extends ConsumerState<AppPopupMenuButton> {
  GlobalKey buttonKey = GlobalKey();
  bool _isOnHover = false;

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
    final activeTool = ref.watch(activeToolStateProvider);
    final selectedItem = widget.items.firstWhere(
        (item) => item.toolCode == activeTool,
        orElse: () => widget.items.first);
    return InkWell(
      onTap: () {
        final off = getButtonOffset();
        final dividerHeights =
            widget.items.map((item) => item.hasDivider ? 10 : 0);
        final sumOfDivider = dividerHeights.reduce((int a, int b) => a + b);
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
              left: off.dx + 10,
              top: off.dy + 40,
              child: Transform.rotate(
                angle: 0.8,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: colors(context).color5,
                  ),
                ),
              ),
            ),
            Positioned(
              left: off.dx - 10,
              top: off.dy + 44,
              child: Container(
                decoration: BoxDecoration(
                  color: colors(context).color5,
                  borderRadius: BorderRadius.circular(4),
                ),
                width: 200,
                height: (widget.items.length * 40) + sumOfDivider + 16,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: widget.items
                        .map(
                          (e) => _PopUpItem(
                            item: e,
                            isActive: activeTool == e.toolCode,
                            onTap: () {
                              ref.read(activeToolStateProvider.notifier).state =
                                  e.toolCode;
                              ref.read(appStackProvider.notifier).state = null;
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      onHover: (value) {
        setState(() {
          _isOnHover = value;
        });
      },
      child: Container(
        key: buttonKey,
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          color: _isOnHover ? colors(context).color3 : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 30,
              child: Icon(
                selectedItem.icon,
                color: activeTool == selectedItem.toolCode
                    ? colors(context).color8
                    : colors(context).color7,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 12,
              color: colors(context).color7,
            ),
          ],
        ),
      ),
    );
  }
}

class _PopUpItem extends StatefulWidget {
  const _PopUpItem({
    super.key,
    required this.item,
    this.isActive = false,
    required this.onTap,
  });
  final AppPopupMenuItem item;
  final bool isActive;
  final void Function() onTap;

  @override
  State<_PopUpItem> createState() => _PopUpItemState();
}

class _PopUpItemState extends State<_PopUpItem> {
  bool _isOnHover = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: widget.onTap,
          onHover: (value) {
            setState(() {
              _isOnHover = value;
            });
          },
          child: Container(
            height: 40,
            color: _isOnHover ? colors(context).color1 : null,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Center(
                          child: Icon(
                            widget.item.icon,
                            size: 22,
                            color: widget.isActive
                                ? colors(context).color8
                                : colors(context).color7,
                          ),
                        ),
                      ),
                      Text(
                        widget.item.title,
                        style: TextStyle(
                          color: colors(context).color7,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.item.info ?? '',
                    style: TextStyle(
                      color: colors(context).color7,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.item.hasDivider) const ListDivider()
      ],
    );
  }
}
