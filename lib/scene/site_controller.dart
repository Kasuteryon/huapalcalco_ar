import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

import '../data/stops.dart';
import 'site_camera.dart';

/// Dueño de la escena 3D del sitio: carga el modelo, conoce la posición de
/// cada parada y mueve la cámara entre ellas.
class SiteController extends ChangeNotifier {
  SiteController();

  static const modelPath = 'assets/models/huapalcalco.glb';

  final Scene scene = Scene();
  final SiteCamera camera = SiteCamera(target: vm.Vector3(0, 0.8, 0));

  /// Aumenta cada vez que la cámara se mueve, para redibujar los marcadores.
  final ValueNotifier<int> frame = ValueNotifier(0);

  final Map<String, vm.Vector3> _poi = {};
  vm.Vector3 _center = vm.Vector3(0, 0.8, 0);

  bool _loading = false;
  bool ready = false;
  Object? error;

  /// Parada seleccionada, o null en la vista general.
  int? selected;

  /// Relación ancho/alto de la vista. En vertical la cámara se aleja para que
  /// el sitio quepa de lado a lado.
  double _aspect = 1.4;

  void setViewport({required double aspect, required double focusOffset}) {
    camera.focusOffset = focusOffset;
    if ((aspect - _aspect).abs() < 0.01) return;
    _aspect = aspect;
    if (!ready) return;
    final i = selected;
    i == null ? showOverview() : selectStop(i);
  }

  double get _distanceFactor => (1.0 / _aspect).clamp(1.0, 2.2);

  double get _overviewDistance =>
      (15.5 / (2 * math.tan(SiteCamera.fov / 2) * _aspect)).clamp(25.0, 55.0);

  vm.Vector3? poiOf(Stop stop) => _poi[stop.id];

  Future<void> load() async {
    if (_loading || ready) return;
    _loading = true;
    try {
      await Scene.initializeStaticResources();
      final model = await loadScene(modelPath);
      scene.add(model);
      for (final stop in kStops) {
        final node = model.getChildByName(stop.nodeName);
        if (node != null) {
          _poi[stop.id] = node.globalTransform.getTranslation();
        }
      }
      if (_poi.isNotEmpty) {
        final sum = _poi.values.fold(vm.Vector3.zero(), (a, b) => a + b);
        _center = sum / _poi.length.toDouble();
        _center.y = 0.8;
      }
      _snapToOverview();
      ready = true;
    } catch (e, st) {
      error = e;
      debugPrint('No se pudo cargar el modelo: $e\n$st');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Azimut que deja la cámara del lado de la plaza, mirando hacia la pirámide.
  double _azimuthFrom(vm.Vector3 from, vm.Vector3 to) {
    final d = from - to;
    return math.atan2(-d.x, -d.z);
  }

  double get _plazaAzimuth {
    final plaza = _poi['plaza'];
    final piramide = _poi['piramide'];
    if (plaza == null || piramide == null) return 0;
    return _azimuthFrom(plaza, piramide);
  }

  void _snapToOverview() {
    camera
      ..target = _center.clone()
      ..azimuth = _plazaAzimuth
      ..polar = 0.62
      ..distance = _overviewDistance;
    showOverview();
  }

  void showOverview() {
    selected = null;
    camera.flyTo(
      target: _center,
      distance: _overviewDistance,
      azimuth: _plazaAzimuth,
      polar: 0.62,
    );
    notifyListeners();
  }

  void selectStop(int index) {
    final stop = kStops[index];
    final poi = _poi[stop.id];
    selected = index;
    if (poi != null) {
      final offset = vm.Vector3(poi.x - _center.x, 0, poi.z - _center.z);
      // Fuera del centro, la cámara se coloca más allá de la parada mirando
      // hacia el conjunto. Cerca del centro, mira desde la plaza.
      final azimuth = offset.length > 2.5
          ? _azimuthFrom(poi, vm.Vector3(_center.x, poi.y, _center.z))
          : _plazaAzimuth;
      camera.flyTo(
        target: poi,
        distance: stop.distance * _distanceFactor,
        azimuth: azimuth,
        polar: stop.polar,
      );
    }
    notifyListeners();
  }

  void next() => selectStop(((selected ?? -1) + 1) % kStops.length);

  void previous() =>
      selectStop(((selected ?? 0) - 1 + kStops.length) % kStops.length);

  /// Llamado en cada cuadro por la vista.
  void tick(double deltaSeconds) {
    if (camera.update(deltaSeconds)) frame.value++;
  }

  @override
  void dispose() {
    frame.dispose();
    super.dispose();
  }
}
