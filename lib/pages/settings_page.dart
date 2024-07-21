import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/theme_provider.dart';
import 'package:rend/store/shared_preferences.dart';
import 'package:rend/widgets/app_input_dropdown.dart';
import 'package:rend/widgets/app_input_textfield.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin<SettingsPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsets.all(4.0),
      children: [
        ListTile(
          title: Text(
            "Text input",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          trailing: AppInputTextfield(onSubmitted: (v) {}),
        ),
        const SizedBox(height: 4),
        ListTile(
          title: Text(
            "Theme mode",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          trailing: Consumer(
            builder: (context, ref, child) {
              var themeMode = ref.watch(themeModeProvider);
              return AppInputDropdown<int>(
                value: themeMode,
                readonly: true,
                onSubmitted: (v) {
                  ref.read(themeModeProvider.notifier).state = v ?? 0;
                  SharedStore().setThemeMode(v ?? 0);
                } as void Function(dynamic), // FIXME: fix type
                dropdownItems: const [
                  DropdownItem<int>(
                    label: 'System',
                    value: 0,
                    isDivided: true,
                  ),
                  DropdownItem<int>(label: 'Dark', value: 2),
                  DropdownItem<int>(label: 'Light', value: 1),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
