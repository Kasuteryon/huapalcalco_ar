import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'app_shell.dart';
import 'theme/hp_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Precarga los shaders del vidrio para evitar parpadeos en el primer cuadro.
  await LiquidGlassWidgets.initialize();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  runApp(
    LiquidGlassWidgets.wrap(
      theme: const GlassThemeData.ios27(),
      adaptiveQuality: true,
      respectSystemAccessibility: true,
      // La app solo tiene tema claro.
      brightnessResolver: (_) => Brightness.light,
      child: const HuapalcalcoApp(),
    ),
  );
}

class HuapalcalcoApp extends StatelessWidget {
  const HuapalcalcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Huapalcalco',
      debugShowCheckedModeBanner: false,
      theme: buildHpTheme(),
      themeMode: ThemeMode.light,
      home: const AppShell(),
    );
  }
}
