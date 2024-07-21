import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/widgets/app_input_textfield.dart';

class AppInputNumberField extends ConsumerStatefulWidget {
  const AppInputNumberField({
    super.key,
    this.width,
    this.maxWidth,
    this.suffixIcon,
    this.suffixText,
    this.density = VisualDensity.compact,
    this.readonly = false,
    this.alwaysShowOutline = false,
    this.value,
    required this.onSubmitted,
    this.onChanged,
  });

  final double? width;
  final double? maxWidth;
  final IconData? suffixIcon;
  final String? suffixText;
  final bool readonly;
  final bool alwaysShowOutline;
  final VisualDensity density;
  final double? value;
  final void Function(double?) onSubmitted;
  final void Function(double?)? onChanged;

  @override
  ConsumerState<AppInputNumberField> createState() => _AppInputNumberState();
}

class _AppInputNumberState extends ConsumerState<AppInputNumberField> {
  double _convertToDouble(String value) {
    return double.parse(value);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppInputTextfield(
      width: widget.width,
      maxWidth: widget.maxWidth,
      density: widget.density,
      value: '${widget.value?.round() ?? ''}',
      readonly: widget.readonly,
      alwaysShowOutline: widget.alwaysShowOutline,
      suffixIcon: widget.suffixIcon,
      suffixText: widget.suffixText,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onSubmitted: (v) {
        widget.onSubmitted(v == null || v == '' ? null : _convertToDouble(v));
      },
      onChanged: (v) {
        widget.onChanged
            ?.call(v == null || v == '' ? null : _convertToDouble(v));
      },
    );
  }
}
