import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/theme/theme.dart';

class AppButton extends ConsumerStatefulWidget {
  const AppButton({super.key, this.onTap, required this.text});
  final void Function()? onTap;
  final String text;

  @override
  ConsumerState<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends ConsumerState<AppButton> {
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (h) {
        setState(() {
          _isHovered = h;
        });
      },
      child: Container(
        height: 28,
        decoration: BoxDecoration(
          color: _isHovered ? colors(context).color9 : colors(context).color1,
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 12,
              color:
                  _isHovered ? colors(context).color4 : colors(context).color7,
            ),
          ),
        ),
      ),
    );
  }
}

class LinkButton extends StatefulWidget {
  const LinkButton({
    super.key,
    this.isActive = false,
    this.onTap,
  });
  final bool isActive;
  final void Function()? onTap;

  @override
  State<LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<LinkButton> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (v) {
        setState(() {
          _isHovered = v;
        });
      },
      onTap: widget.onTap,
      child: SizedBox(
        width: 18,
        child: Transform.rotate(
          angle: 3.14 / 2,
          child: Icon(
            widget.isActive || _isHovered ? Icons.link : Icons.link_off,
            size: 18,
            color: widget.isActive || _isHovered
                ? colors(context).color7
                : colors(context).color3,
          ),
        ),
      ),
    );
  }
}
