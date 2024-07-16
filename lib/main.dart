import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/app_provider.dart';
import 'package:rend/provider/theme_provider.dart';
import 'package:rend/store/shared_preferences.dart';
import 'package:rend/theme/theme.dart';
import 'package:rend/widgets/app_input_dropdown.dart';
import 'package:rend/widgets/app_input_textfield.dart';
import 'package:rend/widgets/horizontal_tab_bar.dart';
import 'package:rend/widgets/vertical_tab_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedStore().init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Rend',
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(context, false),
      darkTheme: getAppTheme(context, true),
      themeMode: themeMode == 0
          ? ThemeMode.system
          : themeMode == 1
              ? ThemeMode.light
              : ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage>
    with TickerProviderStateMixin {
  late TabController tabController;
  late TabController verticalTabController;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: 2, vsync: this, animationDuration: Duration.zero);
    verticalTabController =
        TabController(length: 4, vsync: this, animationDuration: Duration.zero);
  }

  @override
  void dispose() {
    tabController.dispose();
    verticalTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tabState = ref.watch(activeTabProvider);
    tabController.animateTo(tabState == null ? 0 : 1);
    var verticalTabState = ref.watch(activeVerticalTabState);
    verticalTabController.animateTo(verticalTabState);
    final stack1 = ref.watch(appStackProvider);
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Column(
                children: [
                  const HorizontalTabBar(),
                  Container(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                    height: 42,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2.0),
                      child: (tabState == null)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    SizedBox(width: 210),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('New File'),
                                ),
                              ],
                            )
                          : const Row(
                              children: [
                                Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: [
                Row(
                  children: [
                    Container(
                      width: 238,
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: VerticalTabBar(),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: verticalTabController,
                        children: [
                          Container(),
                          Container(),
                          Container(),
                          ListView(
                            padding: const EdgeInsets.all(4.0),
                            children: [
                              ListTile(
                                title: Text(
                                  "Text input",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                trailing: AppInputTextfield(onChanged: (v) {}),
                              ),
                              const SizedBox(height: 4),
                              ListTile(
                                title: Text(
                                  "Theme mode",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                trailing: Consumer(
                                  builder: (context, ref, child) {
                                    var themeMode =
                                        ref.watch(themeModeProvider);
                                    return AppInputDropdown<int>(
                                      value: themeMode,
                                      readonly: true,
                                      onChanged: (v) {
                                        ref
                                            .read(themeModeProvider.notifier)
                                            .state = v ?? 0;
                                        SharedStore().setThemeMode(v ?? 0);
                                      } as void Function(
                                          dynamic), // FIXME: fix type
                                      dropdownItems: const [
                                        DropdownItem<int>(
                                          label: 'System',
                                          value: 0,
                                          isDivided: true,
                                        ),
                                        DropdownItem<int>(
                                            label: 'Dark', value: 2),
                                        DropdownItem<int>(
                                            label: 'Light', value: 1),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(),
              ],
            ),
          ),
          if (stack1 != null) stack1
        ],
      ),
    );
  }
}
