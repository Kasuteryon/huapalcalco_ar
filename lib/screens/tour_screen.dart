import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../data/stops.dart';
import '../scene/site_controller.dart';
import '../scene/site_viewer.dart';
import '../theme/hp_theme.dart';
import '../widgets/hp_icon.dart';
import '../widgets/hp_widgets.dart';

/// Pestaña Recorrido: el modelo 3D con las paradas.
///
/// En teléfono la ficha es una hoja de vidrio sobre el modelo. En tablet la
/// ficha vive en un panel blanco fijo y el modelo nunca se tapa.
class TourScreen extends StatelessWidget {
  const TourScreen({
    super.key,
    required this.site,
    required this.wide,
    required this.onOpenAr,
  });

  final SiteController site;
  final bool wide;
  final VoidCallback onOpenAr;

  @override
  Widget build(BuildContext context) {
    return wide
        ? _WideTour(site: site, onOpenAr: onOpenAr)
        : _PhoneTour(site: site, onOpenAr: onOpenAr);
  }
}

class _PhoneTour extends StatelessWidget {
  const _PhoneTour({required this.site, required this.onOpenAr});

  final SiteController site;
  final VoidCallback onOpenAr;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    const sheetHeight = 236.0;
    final bottom = pad.bottom + 92;
    return ColoredBox(
      color: HpColors.canvas,
      child: Stack(
        children: [
          Positioned.fill(
            child: SiteViewer(
              controller: site,
              pinInsets: EdgeInsets.only(
                top: pad.top + 64,
                bottom: bottom + sheetHeight,
              ),
            ),
          ),
          Positioned(
            top: pad.top + 8,
            left: 16,
            right: 16,
            child: Row(
              children: [
                GlassIconButton(
                  icon: const HpIcon(HpGlyph.overview, size: 20),
                  onPressed: site.showOverview,
                  useOwnLayer: true,
                  semanticLabel: 'Vista general',
                ),
                const Spacer(),
                ListenableBuilder(
                  listenable: site,
                  builder: (context, _) => site.selected == null
                      ? const SizedBox.shrink()
                      : GlassContainer(
                          useOwnLayer: true,
                          shape: const LiquidRoundedSuperellipse(
                            borderRadius: 22,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 11,
                          ),
                          child: Text(
                            '${site.selected! + 1} de ${kStops.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: bottom,
            height: sheetHeight,
            child: GlassContainer(
              useOwnLayer: true,
              shape: const LiquidRoundedSuperellipse(
                borderRadius: HpRadius.sheet,
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
              child: ListenableBuilder(
                listenable: site,
                builder: (context, _) =>
                    _StopDetail(site: site, onOpenAr: onOpenAr, compact: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WideTour extends StatelessWidget {
  const _WideTour({required this.site, required this.onOpenAr});

  final SiteController site;
  final VoidCallback onOpenAr;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: SiteViewer(
                  controller: site,
                  pinInsets: EdgeInsets.only(top: pad.top + 96, bottom: 96),
                ),
              ),
              Positioned(
                top: pad.top + 20,
                left: 24,
                right: 24,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: TitlePair('Recorrido', 'por el sitio', size: 34),
                    ),
                    GlassIconButton(
                      icon: const HpIcon(HpGlyph.overview, size: 20),
                      onPressed: site.showOverview,
                      useOwnLayer: true,
                      semanticLabel: 'Vista general',
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: pad.bottom + 24,
                left: 0,
                right: 0,
                child: Center(
                  child: GlassContainer(
                    useOwnLayer: true,
                    shape: const LiquidRoundedSuperellipse(borderRadius: 99),
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ToolbarButton(
                          glyph: HpGlyph.overview,
                          label: 'Vista general',
                          onTap: site.showOverview,
                        ),
                        _ToolbarButton(
                          glyph: HpGlyph.back,
                          label: 'Anterior',
                          onTap: site.previous,
                        ),
                        _ToolbarButton(
                          glyph: HpGlyph.next,
                          label: 'Siguiente',
                          onTap: site.next,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 340,
          margin: EdgeInsets.fromLTRB(0, pad.top + 14, 14, pad.bottom + 14),
          decoration: ShapeDecoration(
            color: HpColors.white,
            shape: RoundedSuperellipseBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          padding: const EdgeInsets.all(HpSpace.s24),
          child: ListenableBuilder(
            listenable: site,
            builder: (context, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StopDetail(site: site, onOpenAr: onOpenAr, compact: false),
                const SizedBox(height: HpSpace.s16),
                const Divider(color: HpColors.line, height: 1),
                const SizedBox(height: HpSpace.s8),
                Expanded(child: _StopList(site: site)),
                const DraftNote(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.glyph,
    required this.label,
    required this.onTap,
  });

  final HpGlyph glyph;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HpIcon(glyph, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ficha de la parada seleccionada, o invitación a empezar.
class _StopDetail extends StatelessWidget {
  const _StopDetail({
    required this.site,
    required this.onOpenAr,
    required this.compact,
  });

  final SiteController site;
  final VoidCallback onOpenAr;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final i = site.selected;
    final stop = i == null ? null : kStops[i];
    final title = stop?.title ?? 'Vista general';
    final complement = stop?.complement ?? 'del conjunto';
    final body =
        stop?.body ??
        'Gira el modelo con un dedo y acércate con dos. Toca un marcador o '
            'empieza el recorrido.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          i == null ? 'RECORRIDO' : 'PARADA ${i + 1} DE ${kStops.length}',
          style: HpText.eyebrow.copyWith(fontSize: 11),
        ),
        const SizedBox(height: 6),
        TitlePair(title, complement, size: compact ? 26 : 30),
        const SizedBox(height: 10),
        Text(
          body,
          maxLines: compact ? 3 : 6,
          overflow: TextOverflow.ellipsis,
          style: HpText.bodyMuted.copyWith(
            fontSize: compact ? 14 : 15,
            color: HpColors.ink.withValues(alpha: 0.72),
          ),
        ),
        if (compact) const Spacer() else const SizedBox(height: HpSpace.s16),
        Row(
          children: [
            if (i != null) ...[
              GoButton(
                onTap: site.previous,
                glyph: HpGlyph.back,
                background: compact ? HpColors.white : HpColors.canvas,
                semanticLabel: 'Parada anterior',
              ),
              const SizedBox(width: 8),
            ],
            GoButton(
              onTap: onOpenAr,
              glyph: HpGlyph.ar,
              background: compact ? HpColors.white : HpColors.canvas,
              semanticLabel: 'Ver en AR',
            ),
            const Spacer(),
            _NextPill(
              label: i == null
                  ? 'Empezar'
                  : (i == kStops.length - 1 ? 'Volver al inicio' : 'Siguiente'),
              onTap: i == kStops.length - 1 ? site.showOverview : site.next,
            ),
          ],
        ),
      ],
    );
  }
}

class _NextPill extends StatelessWidget {
  const _NextPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HpColors.brote,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 14, 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              const HpIcon(HpGlyph.next, size: 18, color: HpColors.ink),
            ],
          ),
        ),
      ),
    );
  }
}

class _StopList extends StatelessWidget {
  const _StopList({required this.site});

  final SiteController site;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: kStops.length,
      itemBuilder: (context, i) {
        final now = site.selected == i;
        final done = site.selected != null && i < site.selected!;
        return Material(
          color: now ? HpColors.canvas : Colors.transparent,
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            customBorder: RoundedSuperellipseBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onTap: () => site.selectStop(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: now
                          ? HpColors.brote
                          : (done ? HpColors.monte : HpColors.canvas),
                    ),
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: done && !now ? HpColors.white : HpColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    kStops[i].title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: now ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
