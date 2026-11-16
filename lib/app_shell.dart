import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'ar/ar_launcher.dart';
import 'scene/site_controller.dart';
import 'screens/archive_screen.dart';
import 'screens/home_screen.dart';
import 'screens/layers_screen.dart';
import 'screens/tour_screen.dart';
import 'theme/hp_theme.dart';
import 'widgets/hp_icon.dart';

class _Section {
  const _Section(this.label, this.glyph);
  final String label;
  final HpGlyph glyph;
}

const _sections = [
  _Section('Sitio', HpGlyph.sitio),
  _Section('Recorrido', HpGlyph.recorrido),
  _Section('Estratos', HpGlyph.estratos),
  _Section('Acervo', HpGlyph.acervo),
];

/// Navegación adaptable: barra de pestañas de vidrio en teléfono y barra
/// lateral en tablet. No es una versión estirada del teléfono.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final SiteController _site = SiteController();
  int _tab = 0;

  @override
  void dispose() {
    _site.dispose();
    super.dispose();
  }

  void _go(int tab) => setState(() => _tab = tab);

  void _openStop(int index) {
    _go(1);
    _site.load().then((_) => _site.selectStop(index));
  }

  void _startTour() => _openStop(0);

  Future<void> _openAr() async {
    try {
      await ArLauncher.open();
    } on UnsupportedError catch (e) {
      _toast(
        e.message ?? 'La realidad aumentada no está disponible en este equipo.',
      );
    } catch (_) {
      _toast('No se pudo abrir la maqueta en AR. Intenta de nuevo.');
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  List<Widget> _pages(bool wide) => [
    HomeScreen(
      wide: wide,
      onOpenStop: _openStop,
      onStartTour: _startTour,
      onOpenAr: _openAr,
    ),
    TourScreen(site: _site, wide: wide, onOpenAr: _openAr),
    LayersScreen(wide: wide),
    ArchiveScreen(wide: wide),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= HpBreakpoints.tablet;
        final pages = IndexedStack(index: _tab, children: _pages(wide));
        if (wide) {
          return Scaffold(
            backgroundColor: HpColors.canvas,
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Rail(
                  selected: _tab,
                  compact: constraints.maxWidth < HpBreakpoints.tabletWide,
                  onSelect: _go,
                  onOpenAr: _openAr,
                ),
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeLeft: true,
                    child: pages,
                  ),
                ),
              ],
            ),
          );
        }
        // Material da el estilo de texto por defecto a todo lo que está debajo.
        return Material(
          type: MaterialType.transparency,
          child: GlassScaffold(
            backgroundColor: HpColors.canvas,
            body: pages,
            bottomBar: GlassTabBar.bottom(
              selectedIndex: _tab,
              onTabSelected: _go,
              indicatorColor: HpColors.ink,
              selectedIconColor: HpColors.white,
              unselectedIconColor: HpColors.ink,
              selectedLabelColor: HpColors.white,
              unselectedLabelColor: HpColors.ink,
              tabs: [
                for (final s in _sections)
                  GlassTab(icon: HpIcon(s.glyph), label: s.label),
              ],
              extraButton: GlassTabBarExtraButton(
                icon: const HpIcon(HpGlyph.ar, color: HpColors.ink),
                label: 'Ver en AR',
                onTap: _openAr,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Barra lateral de tablet. En tablet vertical solo muestra iconos.
class _Rail extends StatelessWidget {
  const _Rail({
    required this.selected,
    required this.compact,
    required this.onSelect,
    required this.onOpenAr,
  });

  final int selected;
  final bool compact;
  final ValueChanged<int> onSelect;
  final VoidCallback onOpenAr;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    return SizedBox(
      width: compact ? 88 : 220,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14, pad.top + 20, 14, pad.bottom + 20),
        child: Column(
          crossAxisAlignment: compact
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(left: compact ? 0 : 6, bottom: 24),
              child: Row(
                mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
                children: [
                  const PyramidMark(size: 38),
                  if (!compact) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Huapalcalco',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                          Text('Tulancingo, Hgo.', style: HpText.caption),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            for (var i = 0; i < _sections.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: _RailItem(
                  section: _sections[i],
                  active: selected == i,
                  compact: compact,
                  onTap: () => onSelect(i),
                ),
              ),
            const Spacer(),
            _RailItem(
              section: const _Section('Ver en AR', HpGlyph.ar),
              active: false,
              accent: true,
              compact: compact,
              onTap: onOpenAr,
            ),
          ],
        ),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.section,
    required this.active,
    required this.compact,
    required this.onTap,
    this.accent = false,
  });

  final _Section section;
  final bool active;
  final bool compact;
  final bool accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = active
        ? HpColors.ink
        : (accent ? HpColors.brote : Colors.transparent);
    final fg = active
        ? HpColors.white
        : (accent ? HpColors.ink : HpColors.stone);
    return Semantics(
      button: true,
      selected: active,
      label: section.label,
      child: Material(
        color: bg,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: SizedBox(
            height: 46,
            width: compact ? 52 : null,
            child: Row(
              mainAxisAlignment: compact || accent
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                if (!compact && !accent) const SizedBox(width: 16),
                HpIcon(section.glyph, size: 20, color: fg),
                if (!compact) ...[
                  const SizedBox(width: 10),
                  Text(
                    section.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: active || accent
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: fg,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
