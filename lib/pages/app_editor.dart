import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/canvas_provider.dart';
import 'package:rend/theme/theme.dart';
import 'package:rend/views/app_canvas.dart';
import 'package:rend/views/properties_container.dart';
import 'package:rend/views/property_views.dart';

class AppEditor extends ConsumerWidget {
  const AppEditor({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final canvas = ref.read(canvasStateProvider);
    return Container(
      color: colors(context).color5,
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Row(
          children: [
            Container(
              width: 300,
              constraints: const BoxConstraints(minWidth: 300),
              height: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: GestureDetector(
                  onTap: () {
                    canvas.selectObject(null);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: const AppCanvas(),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                width: 240,
                height: MediaQuery.of(context).size.height - 80,
                child: Column(
                  children: List.generate(
                    3,
                    (i) {
                      var container = PropertiesContainer(
                        hasDivider: i < 2,
                        title: 'title: $i',
                        children: i == 1
                            ? [
                                const PositionProperty(),
                                const RotationProperty(),
                              ]
                            : [
                                Container(),
                                Container(),
                                Container(),
                              ],
                        child: i == 0 ? Container() : null,
                      );
                      return i == 2
                          ? Expanded(
                              child: container,
                            )
                          : container;
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
