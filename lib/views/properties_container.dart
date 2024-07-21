import 'package:flutter/material.dart';
import 'package:rend/theme/theme.dart';

class PropertiesContainer extends StatefulWidget {
  const PropertiesContainer({
    super.key,
    this.hasDivider = false,
    required this.title,
    required this.children,
    this.child,
  });
  final bool hasDivider;
  final String title;
  final List<Widget> children;
  final Widget? child;

  @override
  State<PropertiesContainer> createState() => _PropertiesContainerState();
}

class _PropertiesContainerState extends State<PropertiesContainer> {
  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.hasDivider ? 2.0 : 0),
      child: Container(
        constraints: const BoxConstraints(minHeight: 42),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: widget.child ??
            Column(
              children: [
                SizedBox(
                  height: 42,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Icon(
                            isExpanded
                                ? Icons.arrow_drop_down_circle_outlined
                                : Icons.arrow_circle_right_outlined,
                            size: 18,
                            color: colors(context).color3,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(widget.title),
                      ],
                    ),
                  ),
                ),
                if (isExpanded)
                  Column(
                    children: widget.children
                        .map((e) => SizedBox(height: 32, child: e))
                        .toList(),
                  )
              ],
            ),
      ),
    );
  }
}
