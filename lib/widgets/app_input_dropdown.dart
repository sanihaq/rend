import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/app_provider.dart';
import 'package:rend/theme/theme.dart';
import 'package:rend/widgets/common/input_wrapper.dart';
import 'package:rend/widgets/common/text_input.dart';

class DropdownItem<T> {
  final String label;
  final T? value;
  final bool isDivided;
  const DropdownItem({
    required this.label,
    required this.value,
    this.isDivided = false,
  });
}

class AppInputDropdown<T> extends ConsumerStatefulWidget {
  final double? width;
  final double? maxWidth;
  final T? value;
  final bool readonly;
  final void Function(T?) onChanged;
  final List<DropdownItem<T>> dropdownItems;
  const AppInputDropdown({
    super.key,
    this.width,
    this.maxWidth,
    this.value,
    this.readonly = false,
    required this.onChanged,
    this.dropdownItems = const [],
  });

  @override
  ConsumerState<AppInputDropdown> createState() => _AppInputState<T>();
}

class _AppInputState<T> extends ConsumerState<AppInputDropdown> {
  GlobalKey inputKey = GlobalKey();
  bool isContainerActive = false;
  final textInputFocusNode = FocusNode();
  T? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant AppInputDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _value = widget.value;
    }
  }

  Offset getInputOffset() {
    RenderBox renderBox =
        inputKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  getDisPlayValue(T? value) {
    if (value == null) {
      return null;
    }
    return widget.dropdownItems
        .firstWhere((element) => element.value == value)
        .label;
  }

  final double _maxWidth = 120;

  _showDropDown() {
    setState(() {
      isContainerActive = true;
    });
    if (widget.dropdownItems.isEmpty) return;
    double screenHeight = MediaQuery.of(context).size.height;
    final dividerHeights =
        widget.dropdownItems.map((item) => item.isDivided ? 10 : 0);
    final sumOfDivider = dividerHeights.reduce((int a, int b) => a + b);
    final containerHeight =
        (30.0 * widget.dropdownItems.length) + 8 + sumOfDivider;
    final off = getInputOffset();
    double offY = off.dy + 30;
    final availableHeight = screenHeight - offY;
    final height = offY > availableHeight ? offY - 30 : availableHeight;
    offY = availableHeight > containerHeight
        ? offY
        : height > containerHeight
            ? height - containerHeight + 2
            : height > offY
                ? offY
                : 4;
    ref.read(appStackProvider.notifier).state = Positioned(
      left: off.dx - 4,
      top: offY,
      child: Container(
        width: widget.width ?? widget.maxWidth ?? _maxWidth + 8,
        height: containerHeight < height ? containerHeight : height - 4,
        decoration: BoxDecoration(
          color: colors(context).color5,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListView.builder(
            itemCount: widget.dropdownItems.length,
            itemBuilder: (context, index) {
              final item = widget.dropdownItems[index];
              return _ListItem(
                item: item,
                onTap: () {
                  widget.onChanged(item.value);

                  // _unFocus(); // NOTE: don't need call this "onTapOutside" already called unFocus at this point (possibly a need refactor)
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _unFocus() {
    setState(() {
      isContainerActive = false;
    });
    textInputFocusNode.unfocus();
    if (widget.dropdownItems.isEmpty) return;
    ref.read(appStackProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    return InputWrapper(
      key: inputKey,
      width: widget.width,
      maxWidth: widget.maxWidth ?? _maxWidth,
      isActive: isContainerActive,
      child: Row(
        children: [
          Expanded(
            child: TextInput(
              value: getDisPlayValue(_value),
              focusNode: textInputFocusNode,
              onChanged: widget.onChanged,
              readonly: widget.readonly,
              onTap: _showDropDown,
              onTapOutside: (_) async {
                await Future.delayed(const Duration(milliseconds: 150));
                _unFocus();
              },
            ),
          ),
          if (widget.dropdownItems.isNotEmpty)
            GestureDetector(
              onTap: () {
                textInputFocusNode.requestFocus();
                _showDropDown();
              },
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 12,
                color: colors(context).color7,
              ),
            ),
        ],
      ),
    );
  }
}

class _ListItem extends StatefulWidget {
  const _ListItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  final DropdownItem item;
  final void Function() onTap;

  @override
  State<_ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<_ListItem> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onHover: (v) {
            setState(() {
              _isHovered = v;
            });
          },
          onTap: widget.onTap,
          child: Container(
            color: _isHovered ? colors(context).color1 : null,
            height: 30,
            width: double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                widget.item.label,
                style: TextStyle(
                  color: _isHovered
                      ? colors(context).color4
                      : colors(context).color7,
                ),
              ),
            ),
          ),
        ),
        if (widget.item.isDivided)
          Divider(
            height: 10,
            thickness: 0.5,
            indent: 0,
            endIndent: 0,
            color: colors(context).color7,
          )
      ],
    );
  }
}
