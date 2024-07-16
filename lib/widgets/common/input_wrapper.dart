import 'package:flutter/material.dart';
import 'package:rend/theme/theme.dart';

class InputWrapper extends StatefulWidget {
  const InputWrapper({
    super.key,
    this.width,
    required this.maxWidth,
    required this.child,
    this.isActive = false,
  });

  final double? width;
  final bool isActive;
  final double maxWidth;
  final Widget child;

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
          border: _isActive || _isOnHover
              ? Border.all(
                  color: colors(context).color3 ?? Colors.transparent,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignOutside,
                )
              : null,
        ),
        height: 32,
        width: widget.width,
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: widget.child,
        ),
      ),
    );
  }
}
