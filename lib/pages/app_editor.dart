import 'package:flutter/material.dart';
import 'package:rend/theme/theme.dart';
import 'package:rend/widgets/app_button.dart';
import 'package:rend/widgets/app_input_textfield.dart';

class AppEditor extends StatelessWidget {
  const AppEditor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: const AppCanvas(),
                ),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                width: 240,
                height: MediaQuery.of(context).size.height - 80,
                child: Column(
                  children: List.generate(
                    2,
                    (i) {
                      var container = Padding(
                        padding: EdgeInsets.only(bottom: i < 1 ? 2.0 : 0),
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 40),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).appBarTheme.backgroundColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                        ),
                      );
                      return i == 1
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

class AppCanvas extends StatelessWidget {
  const AppCanvas({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            height: 80,
            width: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppInputTextfield(
                      alwaysShowOutline: true,
                      width: 80,
                      suffixText: 'W',
                      value: '500',
                      onChanged: (v) {},
                    ),
                    const SizedBox(width: 16),
                    AppInputTextfield(
                      alwaysShowOutline: true,
                      width: 80,
                      suffixText: 'H',
                      value: '500',
                      onChanged: (v) {},
                    ),
                  ],
                ),
                AppButton(
                  onTap: () {},
                  text: 'Create artboard',
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
