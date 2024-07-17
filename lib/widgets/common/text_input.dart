import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/app_provider.dart';
import 'package:rend/theme/theme.dart';

class TextInput extends ConsumerStatefulWidget {
  const TextInput({
    super.key,
    this.width,
    this.maxWidth,
    this.readonly = false,
    this.focusNode,
    this.value,
    this.onTap,
    this.onChanged,
    this.onTapOutside,
  });
  final double? width;
  final double? maxWidth;
  final String? value;
  final bool readonly;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onTapOutside;

  @override
  ConsumerState<TextInput> createState() => _TextInputState();
}

class _TextInputState extends ConsumerState<TextInput> {
  late TextEditingController controller;
  bool _isDummyCalled = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    controller = TextEditingController(text: widget.value ?? '');
    ref.read(dummyTextInputTapProvider.notifier).addListener((_) {
      if (_isDummyCalled) {
        widget.onTapOutside?.call(controller.text);
        _isDummyCalled = false;
      }
    });
    _focusNode.addListener(() {
      if (widget.readonly) return;
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      );
    });
  }

  @override
  void didUpdateWidget(covariant TextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      readOnly: widget.readonly,
      controller: controller,
      style: TextStyle(
        color: colors(context).color4,
        fontSize: 12,
        height: 1.2,
      ),
      cursorColor: colors(context).color4,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 14.0),
        isDense: true,
      ),
      onChanged: widget.onChanged,
      onTap: () {
        // should be trigger on focus (via focus node)
        ref.read(dummyTextInputTapProvider.notifier).state = widget.focusNode;
        _isDummyCalled = true;
        //
        widget.onTap?.call();
      },
      onTapOutside: (_) {
        widget.onTapOutside?.call(controller.text);
      },
    );
  }
}
