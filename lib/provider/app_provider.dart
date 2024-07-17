import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/widgets/popup_button.dart';

final activeTabProvider = StateProvider<int?>((ref) => null);
final activeVerticalTabProvider = StateProvider<int>((ref) => 0);
final appStackProvider = StateProvider<Widget?>((ref) => null);
final dummyTextInputTapProvider = StateProvider<FocusNode?>((ref) =>
    null); // hacky fix for input not unfocusing when taping  another input
final activeToolStateProvider =
    StateProvider<ToolCode>((ref) => ToolCode.select);
