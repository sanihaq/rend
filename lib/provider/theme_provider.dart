import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/store/shared_preferences.dart';

final themeModeProvider =
    StateProvider<int>((ref) => SharedStore().getThemeMode());
