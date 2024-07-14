import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeVerticalTabState = StateProvider<int>((ref) => 0);

class _VerticalTabItem {
  final String title;
  final IconData icon;
  _VerticalTabItem({
    required this.title,
    required this.icon,
  });
}

class VerticalTabBar extends ConsumerWidget {
  VerticalTabBar({
    super.key,
  });

  final items = [
    _VerticalTabItem(
      icon: Icons.home,
      title: "Home",
    ),
    _VerticalTabItem(
      icon: Icons.search,
      title: "Search",
    ),
    _VerticalTabItem(
      icon: Icons.access_time,
      title: "Recents",
    ),
    _VerticalTabItem(
      icon: Icons.settings,
      title: "Settings",
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tabState = ref.watch(activeVerticalTabState);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              ref.read(activeVerticalTabState.notifier).state = index;
            },
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: tabState == index
                    ? Theme.of(context).appBarTheme.foregroundColor
                    : null,
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                    child: Icon(
                      items[index].icon,
                      size: 18,
                      color:
                          Theme.of(context).appBarTheme.titleTextStyle?.color,
                    ),
                  ),
                  Text(
                    items[index].title,
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
