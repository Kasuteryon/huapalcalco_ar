import 'dart:math' as math;
import 'dart:ui' show Offset;

import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

/// Cámara en órbita alrededor de un punto, con transiciones suaves entre vistas.
///
/// Usa la misma convención que `OrbitCameraController` de flutter_scene
/// (azimut alrededor del eje vertical, elevación acotada), pero expone
/// [flyTo] para viajar entre paradas del recorrido.
class SiteCamera {
  SiteCamera({
    required vm.Vector3 target,
    this.distance = 20,
    this.azimuth = 0,
    this.polar = 0.6,
  }) : target = target.clone(),
       _targetGoal = target.clone(),
       _distanceGoal = distance,
       _azimuthGoal = azimuth,
       _polarGoal = polar;

  static const double minDistance = 2.5;
  static const double maxDistance = 60;
  static const double minPolar = 0.08;
  static const double maxPolar = 1.48;
  static const double fov = 40 * vm.degrees2Radians;

  vm.Vector3 target;
  double distance;
  double azimuth;
  double polar;

  vm.Vector3 _targetGoal;
  double _distanceGoal;
  double _azimuthGoal;
  double _polarGoal;

  /// Segundos aproximados para asentarse. Largo al viajar, corto con los dedos.
  double _smoothing = 0.12;

  static const double _log100 = 4.605170185988091;

  vm.Vector3 get eye {
    final horizontal = math.cos(polar) * distance;
    return target +
        vm.Vector3(-math.sin(azimuth), 0, -math.cos(azimuth)) * horizontal +
        vm.Vector3(0, math.sin(polar) * distance, 0);
  }

  /// Desplazamiento vertical del punto de interés en pantalla, como fracción
  /// de la altura de la vista. Positivo lo sube, para que no quede detrás de
  /// la hoja inferior.
  double focusOffset = 0;

  PerspectiveCamera get camera {
    final e = eye;
    if (focusOffset == 0) {
      return PerspectiveCamera(position: e, target: target, fovRadiansY: fov);
    }
    final forward = (target - e).normalized();
    final worldUp = vm.Vector3(0, 1, 0);
    final screenUp = (worldUp - forward * worldUp.dot(forward)).normalized();
    final viewHeight = 2 * distance * math.tan(fov / 2);
    final shift = screenUp * (-focusOffset * viewHeight);
    return PerspectiveCamera(
      position: e + shift,
      target: target + shift,
      fovRadiansY: fov,
    );
  }

  /// Viaja a una vista nueva con una transición larga.
  void flyTo({
    required vm.Vector3 target,
    required double distance,
    required double azimuth,
    required double polar,
  }) {
    _smoothing = 0.9;
    _targetGoal = target.clone();
    _distanceGoal = distance.clamp(minDistance, maxDistance);
    _polarGoal = polar.clamp(minPolar, maxPolar);
    // Gira por el camino más corto.
    var goal = azimuth;
    while (goal - this.azimuth > math.pi) {
      goal -= 2 * math.pi;
    }
    while (goal - this.azimuth < -math.pi) {
      goal += 2 * math.pi;
    }
    _azimuthGoal = goal;
  }

  void orbitBy(double deltaAzimuth, double deltaPolar) {
    _smoothing = 0.12;
    _azimuthGoal += deltaAzimuth;
    _polarGoal = (_polarGoal + deltaPolar).clamp(minPolar, maxPolar);
  }

  void dollyBy(double amount) {
    _smoothing = 0.12;
    _distanceGoal = (_distanceGoal * math.exp(-amount * 0.9)).clamp(
      minDistance,
      maxDistance,
    );
  }

  /// Desplaza el punto de interés una fracción de la vista.
  void panBy(Offset fraction) {
    _smoothing = 0.12;
    final forward = (target - eye).normalized();
    final right = vm.Vector3(0, 1, 0).cross(forward)..normalize();
    final up = forward.cross(right)..normalize();
    _targetGoal += (right * -fraction.dx + up * fraction.dy) * distance;
  }

  /// Avanza la animación. Devuelve true si la cámara se movió.
  bool update(double deltaSeconds) {
    final dt = deltaSeconds.clamp(0.0, 0.1);
    final r = 1 - math.exp(-_log100 * dt / _smoothing);
    final before = eye;
    azimuth += (_azimuthGoal - azimuth) * r;
    polar += (_polarGoal - polar) * r;
    distance += (_distanceGoal - distance) * r;
    target += (_targetGoal - target) * r;
    return (eye - before).length2 > 1e-10;
  }
}
