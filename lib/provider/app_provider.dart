import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeTabProvider = StateProvider<int?>((ref) => null);
final activeVerticalTabProvider = StateProvider<int>((ref) => 0);
