import 'package:flutter/material.dart';

import '../theme/hp_theme.dart';
import 'hp_icon.dart';

/// Título en peso 800 con su complemento en peso 400 en la línea siguiente.
class TitlePair extends StatelessWidget {
  const TitlePair(
    this.title,
    this.complement, {
    super.key,
    this.size = 28,
    this.color = HpColors.ink,
  });

  final String title;
  final String complement;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w800,
            letterSpacing: -size * 0.035,
            height: 1.0,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          complement,
          style: TextStyle(
            fontSize: size * 0.74,
            fontWeight: FontWeight.w400,
            letterSpacing: -size * 0.02,
            height: 1.1,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Botón circular de acción: verde brote por defecto, blanco sobre fondos brote.
class GoButton extends StatelessWidget {
  const GoButton({
    super.key,
    required this.onTap,
    this.glyph = HpGlyph.arrow,
    this.size = 44,
    this.background = HpColors.brote,
    this.semanticLabel,
  });

  final VoidCallback? onTap;
  final HpGlyph glyph;
  final double size;
  final Color background;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: background,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: HpIcon(glyph, size: size * 0.38, color: HpColors.ink),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta sólida blanca (lo que se lee nunca va en vidrio).
class HpCard extends StatelessWidget {
  const HpCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(HpSpace.s16),
    this.color = HpColors.white,
    this.onTap,
    this.radius = HpRadius.card,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final VoidCallback? onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedSuperellipseBorder(
      borderRadius: BorderRadius.circular(radius),
    );
    return Material(
      color: color,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Dato con icono en círculo, en forma de píldora.
class DataTile extends StatelessWidget {
  const DataTile({
    super.key,
    required this.glyph,
    required this.label,
    required this.value,
    this.background = HpColors.white,
  });

  final HpGlyph glyph;
  final String label;
  final String value;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 5, 14, 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: HpColors.canvas,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: HpIcon(glyph, size: 17, color: HpColors.monte),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: HpText.caption.copyWith(fontSize: 11)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: HpColors.ink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Nota de contenido preliminar.
class DraftNote extends StatelessWidget {
  const DraftNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Textos preliminares, sujetos a revisión del INAH.',
      style: HpText.caption,
    );
  }
}
