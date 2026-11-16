import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:huapalcalco_ar/data/stops.dart';
import 'package:huapalcalco_ar/scene/site_camera.dart';
import 'package:vector_math/vector_math.dart' as vm;

void main() {
  test('flyTo llega a la vista pedida', () {
    final cam = SiteCamera(
      target: vm.Vector3.zero(),
      distance: 20,
      azimuth: 0,
      polar: 0.6,
    );
    cam.flyTo(
      target: vm.Vector3(2, 1, -3),
      distance: 8,
      azimuth: 1.2,
      polar: 0.4,
    );
    for (var i = 0; i < 300; i++) {
      cam.update(1 / 60);
    }
    expect(cam.target.x, closeTo(2, 1e-3));
    expect(cam.target.z, closeTo(-3, 1e-3));
    expect(cam.distance, closeTo(8, 1e-3));
    expect(cam.azimuth, closeTo(1.2, 1e-3));
    expect(cam.polar, closeTo(0.4, 1e-3));
  });

  test('flyTo gira por el camino corto', () {
    final cam = SiteCamera(target: vm.Vector3.zero(), azimuth: 3.0);
    cam.flyTo(
      target: vm.Vector3.zero(),
      distance: 10,
      azimuth: -3.0,
      polar: 0.5,
    );
    for (var i = 0; i < 300; i++) {
      cam.update(1 / 60);
    }
    // -3.0 equivale a 2π - 3.0, a menos de media vuelta de 3.0.
    expect(cam.azimuth, closeTo(-3.0 + 2 * math.pi, 1e-3));
  });

  test('la elevación y la distancia se mantienen en sus límites', () {
    final cam = SiteCamera(target: vm.Vector3.zero());
    cam.orbitBy(0, 10);
    cam.dollyBy(-100);
    for (var i = 0; i < 300; i++) {
      cam.update(1 / 60);
    }
    expect(cam.polar, lessThanOrEqualTo(SiteCamera.maxPolar + 1e-9));
    expect(cam.distance, lessThanOrEqualTo(SiteCamera.maxDistance + 1e-9));
  });

  test('cada parada tiene identificador único', () {
    final ids = kStops.map((s) => s.id).toSet();
    expect(ids.length, kStops.length);
    expect(kStops.every((s) => s.nodeName == 'poi_${s.id}'), isTrue);
  });
}
