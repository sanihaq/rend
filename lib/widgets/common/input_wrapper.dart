import 'package:flutter/material.dart';
import 'package:rend/theme/theme.dart';

class InputWrapper extends StatefulWidget {
  const InputWrapper({
    super.key,
    this.width,
    required this.maxWidth,
    required this.child,
    this.isActive = false,
    this.alwaysShowOutline = false,
    this.density = VisualDensity.compact,
  });

  final double? width;
  final bool alwaysShowOutline;
  final bool isActive;
  final double maxWidth;
  final Widget child;
  final VisualDensity density;

  @override
  State<InputWrapper> createState() => _InputWrapperState();
}

class _InputWrapperState extends State<InputWrapper> {
  bool _isOnHover = false;
  bool _isActive = false;

  @override
  void didUpdateWidget(covariant InputWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (widget.isActive != oldWidget.isActive) _isActive = widget.isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _isOnHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isOnHover = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _isActive || _isOnHover ? colors(context).color6 : null,
          borderRadius: BorderRadius.circular(4),
          border: widget.alwaysShowOutline || _isActive || _isOnHover
              ? Border.all(
                  color: _isActive
                      ? colors(context).color8 ??
                          colors(context).color3 ??
                          Colors.transparent
                      : colors(context).color3 ?? Colors.transparent,
                  width: _isActive ? 1.4 : 1.2,
                  strokeAlign: BorderSide.strokeAlignOutside,
                )
              : null,
        ),
        height: widget.density == VisualDensity.compact ? 28 : 32,
        width: widget.width,
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.8),
          child: widget.child,
        ),
      ),
    );
  }
}
