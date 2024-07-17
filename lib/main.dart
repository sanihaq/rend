import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/pages/settings_page.dart';
import 'package:rend/provider/app_provider.dart';
import 'package:rend/provider/theme_provider.dart';
import 'package:rend/store/shared_preferences.dart';
import 'package:rend/theme/theme.dart';
import 'package:rend/widgets/horizontal_tab_bar.dart';
import 'package:rend/widgets/popup_button.dart';
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
                          : Row(
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.0, right: 12.0),
                                  child: Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  ),
                                ),
                                AppPopupMenuButton(
                                  items: [
                                    AppPopupMenuItem(
                                      toolCode: ToolCode.select,
                                      icon: Icons.arrow_upward_outlined,
                                      title: 'Select',
                                      info: 'V',
                                    ),
                                  ],
                                ),
                                AppPopupMenuButton(
                                  items: [
                                    AppPopupMenuItem(
                                      toolCode: ToolCode.artboard,
                                      icon: Icons.border_style_outlined,
                                      title: 'Artboard',
                                      info: 'A',
                                    ),
                                  ],
                                ),
                                AppPopupMenuButton(
                                  items: [
                                    AppPopupMenuItem(
                                      toolCode: ToolCode.pen,
                                      icon: Icons.create_sharp,
                                      title: 'Pen',
                                      info: 'P',
                                      hasDivider: true,
                                    ),
                                    AppPopupMenuItem(
                                      toolCode: ToolCode.rectangle,
                                      icon: Icons.check_box_outline_blank,
                                      title: 'Rectangle',
                                      info: 'R',
                                    ),
                                    AppPopupMenuItem(
                                      toolCode: ToolCode.ellipse,
                                      icon: Icons.circle_outlined,
                                      title: 'Ellipse',
                                      info: 'O',
                                    ),
                                    AppPopupMenuItem(
                                      toolCode: ToolCode.polygon,
                                      icon: Icons.pentagon_outlined,
                                      title: 'Polygon',
                                      info: 'O',
                                    ),
                                  ],
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
                          const SettingsPage(),
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
