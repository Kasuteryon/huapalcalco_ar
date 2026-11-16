import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

import '../data/stops.dart';
import '../theme/hp_theme.dart';
import 'site_controller.dart';

/// Vista 3D del sitio con gestos de órbita y marcadores de paradas.
class SiteViewer extends StatefulWidget {
  const SiteViewer({
    super.key,
    required this.controller,
    this.showPins = true,
    this.pinInsets = EdgeInsets.zero,
  });

  final SiteController controller;
  final bool showPins;

  /// Zonas cubiertas por controles donde no se dibujan marcadores.
  final EdgeInsets pinInsets;

  @override
  State<SiteViewer> createState() => _SiteViewerState();
}

class _SiteViewerState extends State<SiteViewer> {
  double _lastScale = 1;

  SiteController get c => widget.controller;

  @override
  void initState() {
    super.initState();
    c.load();
  }

  Size? _viewport;

  /// Informa al controlador el tamaño visible, fuera del ciclo de construcción.
  void _syncViewport(Size size) {
    if (size == _viewport || size.isEmpty) return;
    _viewport = size;
    final insets = widget.pinInsets;
    final visibleCenter = (insets.top + size.height - insets.bottom) / 2;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      c.setViewport(
        aspect: size.width / size.height,
        focusOffset: 0.5 - visibleCenter / size.height,
      );
    });
  }

  void _onScaleStart(ScaleStartDetails d) => _lastScale = 1;

  void _onScaleUpdate(ScaleUpdateDetails d, Size size) {
    final h = size.height <= 0 ? 1.0 : size.height;
    if (d.pointerCount <= 1) {
      const k = 3.14159 * 0.9;
      c.camera.orbitBy(
        -d.focalPointDelta.dx * k / h,
        -d.focalPointDelta.dy * k / h,
      );
      return;
    }
    final factor = _lastScale == 0 ? 1.0 : d.scale / _lastScale;
    _lastScale = d.scale;
    if (factor != 1) c.camera.dollyBy(factor - 1);
    if (d.focalPointDelta != Offset.zero) {
      c.camera.panBy(
        Offset(d.focalPointDelta.dx / h, d.focalPointDelta.dy / h),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        if (c.error != null) {
          return const _Message(
            'No se pudo cargar el modelo 3D. Revisa que la app se compiló con Flutter GPU activado.',
          );
        }
        if (!c.ready) return const _Message('Cargando el modelo del sitio');
        return LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;
            _syncViewport(size);
            return Stack(
              fit: StackFit.expand,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onScaleStart: _onScaleStart,
                  onScaleUpdate: (d) => _onScaleUpdate(d, size),
                  onDoubleTap: c.showOverview,
                  child: SceneView(
                    c.scene,
                    cameraBuilder: (_) => c.camera.camera,
                    onTick: (_, dt) => c.tick(dt),
                  ),
                ),
                if (widget.showPins)
                  ValueListenableBuilder<int>(
                    valueListenable: c.frame,
                    builder: (context, _, _) => _Pins(
                      controller: c,
                      size: size,
                      insets: widget.pinInsets,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _Pins extends StatelessWidget {
  const _Pins({
    required this.controller,
    required this.size,
    required this.insets,
  });

  final SiteController controller;
  final Size size;
  final EdgeInsets insets;

  @override
  Widget build(BuildContext context) {
    final camera = controller.camera.camera;
    final visible = insets.deflateRect(Offset.zero & size);
    final pins = <Widget>[];
    for (var i = 0; i < kStops.length; i++) {
      final poi = controller.poiOf(kStops[i]);
      if (poi == null) continue;
      final p = camera.worldToScreen(poi + vm.Vector3(0, 0.25, 0), size);
      if (p == null || !visible.contains(p)) continue;
      final active = controller.selected == i;
      pins.add(
        Positioned(
          left: p.dx,
          top: p.dy,
          child: FractionalTranslation(
            translation: const Offset(-0.5, -1),
            child: _Pin(
              label: kStops[i].title,
              active: active,
              onTap: () => controller.selectStop(i),
            ),
          ),
        ),
      );
    }
    return Stack(children: pins);
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Parada $label',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: active
                      ? HpColors.ink
                      : HpColors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(99),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: active ? HpColors.white : HpColors.ink,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: active ? HpColors.brote : HpColors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: HpColors.ink, width: 3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: HpColors.monte,
              ),
            ),
            const SizedBox(height: 16),
            Text(text, textAlign: TextAlign.center, style: HpText.bodyMuted),
          ],
        ),
      ),
    );
  }
}
