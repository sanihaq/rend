import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/app_provider.dart';
import 'package:rend/provider/canvas_provider.dart';
import 'package:rend/theme/theme.dart';
import 'package:rend/views/app_canvas.dart';
import 'package:rend/views/properties_container.dart';
import 'package:rend/views/property_views.dart';
import 'package:rend/widgets/popup_button.dart';

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
                child: Consumer(builder: (context, ref, _) {
                  final isFreeze = ref.watch(isFreezeProviderState);
                  return GestureDetector(
                    onTap: () {
                      if (isFreeze) {
                        ref.read(isFreezeProviderState.notifier).state = false;
                        ref.read(activeToolStateProvider.notifier).state =
                            ToolCode.select;
                      } else {
                        canvas.selectObject(null);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        border: Border.all(
                          color: isFreeze
                              ? colors(context).color9 ?? Colors.transparent
                              : Colors.transparent,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: AppCanvas(isFreeze: isFreeze),
                    ),
                  );
                }),
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
                                const ColorFillProperty(),
                                const ColorStrokeProperty(),
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
