import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Abre la maqueta en realidad aumentada con el visor del sistema.
///
/// iOS: AR Quick Look con el USDZ a escala 1:50 (incluido solo en iOS).
/// Android: pendiente. Requiere una vista nativa con ARCore o Scene Viewer.
abstract final class ArLauncher {
  static const _channel = MethodChannel('huapalcalco/ar');
  static const usdzAsset = 'assets/models/huapalcalco.usdz';

  static bool get isSupported => defaultTargetPlatform == TargetPlatform.iOS;

  static Future<void> open() async {
    if (!isSupported) {
      throw UnsupportedError(
        'La realidad aumentada en Android llega en la siguiente versión.',
      );
    }
    await _channel.invokeMethod<void>('openQuickLook', {'asset': usdzAsset});
  }
}
