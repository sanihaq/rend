import 'package:flutter/material.dart';

AppColors colors(context) => Theme.of(context).extension<AppColors>()!;

const _lightColor = AppColors(
  color1: Color(0xFFF1F1F1),
  color2: Colors.white,
  color3: Color(0xFFF6F6F6),
  color4: Colors.black,
  color5: Color(0xFFBEBDBD),
  color6: Color(0xFFE8E6E6),
  color7: Colors.black54,
  color8: Color(0xFF4a97e6),
);
const _darkColor = AppColors(
  color1: Color(0xFF252525),
  color2: Color(0xFF323232),
  color3: Color(0xFF444444),
  color4: Colors.white,
  color5: Color(0xFF111111),
  color6: Color(0xFF1d1d1d),
  color7: Color(0xFF808080),
  color8: Color(0xFF4a97e6),
);

ThemeData getAppTheme(BuildContext context, bool isDarkTheme) {
  return ThemeData(
    extensions: <ThemeExtension<AppColors>>[
      if (isDarkTheme) _darkColor else _lightColor
    ],
    scaffoldBackgroundColor:
        isDarkTheme ? _darkColor.color6 : _lightColor.color6,
    textTheme: Theme.of(context)
        .textTheme
        .copyWith(
          titleSmall:
              Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),
        )
        .apply(
          bodyColor: isDarkTheme ? _darkColor.color4 : _lightColor.color4,
          displayColor: Colors.grey,
        ),
    switchTheme: SwitchThemeData(
      thumbColor:
          WidgetStateProperty.all(isDarkTheme ? Colors.orange : Colors.purple),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16.0)),
        textStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal)),
        backgroundColor: WidgetStateProperty.all(
          isDarkTheme ? _darkColor.color3 : _lightColor.color3,
        ),
        foregroundColor: WidgetStateProperty.all(
            isDarkTheme ? _darkColor.color4 : _lightColor.color4),
        shadowColor: WidgetStateProperty.all(
            ((isDarkTheme ? _darkColor.color2 : _lightColor.color2) ??
                    Colors.black)
                .withOpacity(0.6)),
        elevation: WidgetStateProperty.all(5.0),
        visualDensity: VisualDensity.compact,
        minimumSize: WidgetStateProperty.all(const Size(92.0, 38.0)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
        tileColor: isDarkTheme ? _darkColor.color1 : _lightColor.color1),
    appBarTheme: AppBarTheme(
      backgroundColor: isDarkTheme ? _darkColor.color1 : _lightColor.color1,
      foregroundColor: isDarkTheme ? _darkColor.color2 : _lightColor.color2,
      iconTheme: IconThemeData(
          color: isDarkTheme ? _darkColor.color7 : _lightColor.color7),
      titleTextStyle: const TextStyle(fontSize: 12),
    ),
  );
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color? color1;
  final Color? color2;
  final Color? color3;
  final Color? color4;
  final Color? color5;
  final Color? color6;
  final Color? color7;
  final Color? color8;

  const AppColors({
    required this.color1,
    required this.color2,
    required this.color3,
    required this.color4,
    required this.color5,
    required this.color6,
    required this.color7,
    required this.color8,
  });

  @override
  AppColors copyWith({
    Color? color1,
    Color? color2,
    Color? color3,
    Color? color4,
    Color? color5,
    Color? color6,
    Color? color7,
    Color? color8,
  }) {
    return AppColors(
      color1: color1 ?? this.color1,
      color2: color2 ?? this.color2,
      color3: color3 ?? this.color3,
      color4: color4 ?? this.color4,
      color5: color5 ?? this.color5,
      color6: color6 ?? this.color6,
      color7: color7 ?? this.color7,
      color8: color8 ?? this.color8,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      color1: Color.lerp(color1, other.color1, t),
      color2: Color.lerp(color2, other.color2, t),
      color3: Color.lerp(color3, other.color3, t),
      color4: Color.lerp(color4, other.color4, t),
      color5: Color.lerp(color5, other.color5, t),
      color6: Color.lerp(color6, other.color6, t),
      color7: Color.lerp(color7, other.color7, t),
      color8: Color.lerp(color8, other.color7, t),
    );
  }
}
