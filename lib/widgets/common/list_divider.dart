import 'package:flutter/material.dart';
import 'package:rend/theme/theme.dart';

class ListDivider extends StatelessWidget {
  const ListDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 10,
      thickness: 0.4,
      indent: 0,
      endIndent: 0,
      color: colors(context).color4,
    );
  }
}
