import 'package:flutter/material.dart';

import '../data/stops.dart';
import '../theme/hp_theme.dart';
import '../widgets/hp_icon.dart';
import '../widgets/hp_widgets.dart';

/// Pestaña Sitio: portada con la pirámide, el recorrido y el acceso a AR.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.wide,
    required this.onOpenStop,
    required this.onStartTour,
    required this.onOpenAr,
  });

  final bool wide;
  final ValueChanged<int> onOpenStop;
  final VoidCallback onStartTour;
  final VoidCallback onOpenAr;

  int get _pyramidIndex => kStops.indexWhere((s) => s.id == 'piramide');

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final side = wide ? HpSpace.s32 : HpSpace.s16;
    return ListView(
      padding: EdgeInsets.fromLTRB(side, pad.top + 12, side, pad.bottom + 120),
      children: [
        _Header(wide: wide),
        const SizedBox(height: HpSpace.s24),
        if (wide)
          SizedBox(
            height: 420,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: _PyramidCard(
                    onTap: () => onOpenStop(_pyramidIndex),
                    large: true,
                  ),
                ),
                const SizedBox(width: HpSpace.s16),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _TourCard(onTap: onStartTour)),
                      const SizedBox(height: HpSpace.s16),
                      Expanded(child: _ArCard(onTap: onOpenAr)),
                    ],
                  ),
                ),
              ],
            ),
          )
        else ...[
          _PyramidCard(onTap: () => onOpenStop(_pyramidIndex)),
          const SizedBox(height: HpSpace.s12),
          SizedBox(height: 112, child: _TourCard(onTap: onStartTour)),
          const SizedBox(height: HpSpace.s12),
          SizedBox(height: 104, child: _ArCard(onTap: onOpenAr)),
        ],
        const SizedBox(height: HpSpace.s32),
        Text('Paradas del recorrido', style: HpText.title),
        const SizedBox(height: HpSpace.s12),
        _StopGrid(columns: wide ? 3 : 1, onOpenStop: onOpenStop),
        const SizedBox(height: HpSpace.s16),
        const DraftNote(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tulancingo, Hidalgo',
                style: HpText.caption.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                'Huapalcalco',
                style: HpText.display.copyWith(fontSize: wide ? 40 : 32),
              ),
            ],
          ),
        ),
        if (!wide) const PyramidMark(size: 44),
      ],
    );
  }
}

class _PyramidCard extends StatelessWidget {
  const _PyramidCard({required this.onTap, this.large = false});

  final VoidCallback onTap;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return HpCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: large ? null : 230,
        child: Stack(
          children: [
            Positioned(
              right: large ? -20 : -40,
              bottom: large ? 24 : 34,
              width: large ? 420 : 250,
              child: Image.asset('assets/images/hero.png', fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.all(HpSpace.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TitlePair(
                          'Pirámide',
                          'de tres cuerpos',
                          size: large ? 34 : 28,
                        ),
                      ),
                      GoButton(onTap: onTap, semanticLabel: 'Ver la pirámide'),
                    ],
                  ),
                  const Spacer(),
                  const _MiniStats(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStats extends StatelessWidget {
  const _MiniStats();

  @override
  Widget build(BuildContext context) {
    Widget stat(String value, String label) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: HpText.data),
        Text(label, style: HpText.caption),
      ],
    );
    return IntrinsicHeight(
      child: Row(
        children: [
          stat('16.7 m', 'Frente del sitio'),
          const VerticalDivider(width: 24, color: HpColors.line),
          stat('3', 'Cuerpos'),
        ],
      ),
    );
  }
}

class _TourCard extends StatelessWidget {
  const _TourCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HpCard(
      color: HpColors.brote,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TitlePair('Recorrido', '${kStops.length} paradas', size: 26),
          ),
          GoButton(
            onTap: onTap,
            background: HpColors.white,
            semanticLabel: 'Empezar el recorrido',
          ),
        ],
      ),
    );
  }
}

class _ArCard extends StatelessWidget {
  const _ArCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HpCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: TitlePair('Maqueta en AR', 'a escala 1:50', size: 24),
          ),
          GoButton(
            onTap: onTap,
            glyph: HpGlyph.ar,
            semanticLabel: 'Ver la maqueta en realidad aumentada',
          ),
        ],
      ),
    );
  }
}

class _StopGrid extends StatelessWidget {
  const _StopGrid({required this.columns, required this.onOpenStop});

  final int columns;
  final ValueChanged<int> onOpenStop;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      for (var i = 0; i < kStops.length; i++)
        HpCard(
          radius: HpRadius.tile,
          padding: const EdgeInsets.fromLTRB(10, 10, 14, 10),
          onTap: () => onOpenStop(i),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: HpColors.canvas,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: HpColors.monte,
                  ),
                ),
              ),
              const SizedBox(width: HpSpace.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kStops[i].title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      kStops[i].complement,
                      style: HpText.caption.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const HpIcon(HpGlyph.next, size: 18, color: HpColors.stone),
            ],
          ),
        ),
    ];
    if (columns == 1) {
      return Column(
        children: [
          for (final t in tiles)
            Padding(padding: const EdgeInsets.only(bottom: 8), child: t),
        ],
      );
    }
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 76,
      ),
      children: tiles,
    );
  }
}
