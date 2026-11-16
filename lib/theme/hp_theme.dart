import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Paleta de la línea gráfica 1.0. Solo tema claro.
abstract final class HpColors {
  static const white = Color(0xFFFFFFFF); // tarjetas, hojas, paneles
  static const canvas = Color(0xFFEEF2F0); // fondo de pantalla
  static const brote = Color(0xFF9BE36D); // acción principal
  static const ink = Color(0xFF0B1210); // texto y estado activo
  static const monte = Color(0xFF134E32); // iconos, progreso, enlaces
  static const stone = Color(0xFF5E6A65); // texto secundario
  static const almagre = Color(0xFFC2492F); // solo pintura rupestre
  static const line = Color(0xFFDCE3DF); // filetes
}

abstract final class HpRadius {
  static const tile = 22.0;
  static const card = 28.0;
  static const sheet = 34.0;
}

abstract final class HpSpace {
  static const s4 = 4.0;
  static const s8 = 8.0;
  static const s12 = 12.0;
  static const s16 = 16.0;
  static const s24 = 24.0;
  static const s32 = 32.0;
  static const s48 = 48.0;
}

abstract final class HpBreakpoints {
  static const tablet = 600.0;
  static const tabletWide = 1024.0;
}

/// En iOS se usa la fuente del sistema (SF Pro). La licencia de SF Pro solo
/// permite usarla en plataformas de Apple, así que en Android va Plus Jakarta Sans.
String? hpFontFamily() {
  final p = defaultTargetPlatform;
  return (p == TargetPlatform.iOS || p == TargetPlatform.macOS)
      ? null
      : 'PlusJakartaSans';
}

abstract final class HpText {
  static TextStyle get display => const TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.2,
    height: 1.0,
    color: HpColors.ink,
  );
  static TextStyle get displaySub => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
    height: 1.15,
    color: HpColors.ink,
  );
  static TextStyle get title => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: HpColors.ink,
  );
  static TextStyle get body =>
      const TextStyle(fontSize: 16, height: 1.5, color: HpColors.ink);
  static TextStyle get bodyMuted =>
      const TextStyle(fontSize: 15, height: 1.5, color: HpColors.stone);
  static TextStyle get data => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: HpColors.ink,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static TextStyle get caption => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: HpColors.stone,
  );
  static TextStyle get eyebrow => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    color: HpColors.monte,
  );
}

ThemeData buildHpTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: hpFontFamily(),
    scaffoldBackgroundColor: HpColors.canvas,
    colorScheme: const ColorScheme.light(
      primary: HpColors.ink,
      onPrimary: HpColors.white,
      secondary: HpColors.brote,
      onSecondary: HpColors.ink,
      surface: HpColors.white,
      onSurface: HpColors.ink,
      outline: HpColors.line,
    ),
    splashFactory: NoSplash.splashFactory,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: HpColors.ink,
      displayColor: HpColors.ink,
    ),
  );
}
