import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Abre la maqueta a escala 1:50 en realidad aumentada.
///
/// iOS: AR Quick Look con assets/models/huapalcalco.usdz (solo se incluye en iOS).
/// Android: ArActivity con ARCore y SceneView, con
/// android/app/src/main/assets/models/huapalcalco_ar.glb.
abstract final class ArLauncher {
  static const _channel = MethodChannel('huapalcalco/ar');
  static const usdzAsset = 'assets/models/huapalcalco.usdz';

  static bool get isSupported =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;

  /// Lanza [ArUnavailable] con un mensaje para el usuario si no se puede abrir.
  static Future<void> open() async {
    if (!isSupported) {
      throw const ArUnavailable(
        'La realidad aumentada no está disponible en este equipo.',
      );
    }
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _channel.invokeMethod<void>('openQuickLook', {
          'asset': usdzAsset,
        });
      } else {
        await _channel.invokeMethod<void>('openAr');
      }
    } on PlatformException catch (e) {
      throw ArUnavailable(e.message ?? 'No se pudo abrir la maqueta en AR.');
    }
  }
}

class ArUnavailable implements Exception {
  const ArUnavailable(this.message);
  final String message;

  @override
  String toString() => message;
}
