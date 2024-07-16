import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/theme/theme.dart';
import 'package:rend/widgets/common/input_wrapper.dart';
import 'package:rend/widgets/common/text_input.dart';

class AppInputTextfield extends ConsumerStatefulWidget {
  final double? width;
  final double? maxWidth;
  final IconData? suffixIcon;
  final bool readonly;
  final String? value;
  final void Function(String?) onChanged;
  const AppInputTextfield({
    super.key,
    this.width,
    this.maxWidth,
    this.suffixIcon,
    this.readonly = false,
    this.value,
    required this.onChanged,
  });

  @override
  ConsumerState<AppInputTextfield> createState() => _AppInputState();
}

class _AppInputState extends ConsumerState<AppInputTextfield> {
  GlobalKey inputKey = GlobalKey();
  bool isContainerActive = false;
  final textInputFocusNode = FocusNode();

  Offset getInputOffset() {
    RenderBox renderBox =
        inputKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return InputWrapper(
      width: widget.width,
      maxWidth: widget.maxWidth ?? 120,
      isActive: isContainerActive,
      child: Row(
        children: [
          if (widget.suffixIcon != null)
            GestureDetector(
              onTap: () {
                setState(() {
                  isContainerActive = true;
                });
                textInputFocusNode.requestFocus();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(
                  widget.suffixIcon,
                  size: 18,
                  color: colors(context).color7,
                ),
              ),
            ),
          Expanded(
            child: TextInput(
              focusNode: textInputFocusNode,
              onChanged: widget.onChanged,
              readonly: widget.readonly,
              onTap: () {
                setState(() {
                  isContainerActive = true;
                });
              },
              onTapOutside: (_) {
                setState(() {
                  isContainerActive = false;
                });
                textInputFocusNode.unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }
}
