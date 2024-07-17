import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/theme/theme.dart';
import 'package:rend/widgets/common/input_wrapper.dart';
import 'package:rend/widgets/common/text_input.dart';

class AppInputTextfield extends ConsumerStatefulWidget {
  final double? width;
  final double? maxWidth;
  final IconData? suffixIcon;
  final String? suffixText;
  final bool readonly;
  final bool alwaysShowOutline;
  final VisualDensity density;
  final String? value;
  final void Function(String?) onChanged;
  const AppInputTextfield({
    super.key,
    this.width,
    this.maxWidth,
    this.suffixIcon,
    this.suffixText,
    this.density = VisualDensity.compact,
    this.readonly = false,
    this.alwaysShowOutline = false,
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
      alwaysShowOutline: widget.alwaysShowOutline,
      density: widget.density,
      child: Row(
        children: [
          if (widget.suffixText != null || widget.suffixIcon != null)
            GestureDetector(
              onTap: () {
                setState(() {
                  isContainerActive = true;
                });
                textInputFocusNode.requestFocus();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 4.0),
                child: widget.suffixIcon != null
                    ? Icon(
                        widget.suffixIcon,
                        size: 18,
                        color: colors(context).color7,
                      )
                    : Text(
                        widget.suffixText ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors(context).color7,
                        ),
                      ),
              ),
            ),
          Expanded(
            child: TextInput(
              focusNode: textInputFocusNode,
              onChanged: widget.onChanged,
              readonly: widget.readonly,
              value: widget.value,
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
