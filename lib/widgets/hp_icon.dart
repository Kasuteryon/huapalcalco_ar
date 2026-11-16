import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Iconos propios de la línea gráfica: retícula de 24, trazo de 1.8.
enum HpGlyph {
  sitio(
    '<path fill="none" stroke="#000" stroke-width="1.8" d="M3 20h18M5 20V11h14v9M9 20v-5M12 20v-5M15 20v-5M5 11V7h2v4M11 11V7h2v4M17 11V7h2v4"/>',
  ),
  recorrido(
    '<g fill="#000"><ellipse cx="8" cy="16.5" rx="2.3" ry="3.6"/><circle cx="6.2" cy="11" r="1"/><circle cx="8" cy="10.3" r="1"/><circle cx="9.8" cy="11" r="1"/><ellipse cx="16" cy="10.5" rx="2.3" ry="3.6"/><circle cx="14.2" cy="5" r="1"/><circle cx="16" cy="4.3" r="1"/><circle cx="17.8" cy="5" r="1"/></g>',
  ),
  ar(
    '<path fill="none" stroke="#000" stroke-width="1.8" d="M4 8V4h4M16 4h4v4M20 16v4h-4M8 20H4v-4M7 16.5h10M8.5 16.5V14h7v2.5M10.5 14v-2.5h3V14"/>',
  ),
  estratos(
    '<path fill="none" stroke="#000" stroke-width="1.8" d="M4 6h16M4 11h9M16 11h4M4 16h5M12 16h8M4 21h16"/>',
  ),
  pinturas(
    '<g fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round"><circle cx="9" cy="5" r="2"/><path d="M9 7v7M9 14l-3 6M9 14l3 6M9 9.5l-4 2M9 9.5l5-2M12.5 2.5l7 10"/></g>',
  ),
  acervo(
    '<path fill="none" stroke="#000" stroke-width="1.8" d="M3 20h18M5 20c0-9 2.5-15 7-15s7 6 7 15M10 20v-3a2 2 0 0 1 4 0v3"/>',
  ),
  arrow(
    '<path fill="none" stroke="#000" stroke-width="2" d="M7 17 17 7M9 7h8v8"/>',
  ),
  back(
    '<path fill="none" stroke="#000" stroke-width="2" d="M19 12H5M11 6l-6 6 6 6"/>',
  ),
  next(
    '<path fill="none" stroke="#000" stroke-width="2" d="M5 12h14M13 6l6 6-6 6"/>',
  ),
  close(
    '<path fill="none" stroke="#000" stroke-width="2" d="M6 6l12 12M18 6 6 18"/>',
  ),
  orbit(
    '<path fill="none" stroke="#000" stroke-width="1.8" d="M12 4a8 8 0 1 0 8 8M20 4v5h-5"/>',
  ),
  overview(
    '<path fill="none" stroke="#000" stroke-width="1.8" d="M4 9V4h5M15 4h5v5M20 15v5h-5M9 20H4v-5"/>',
  ),
  help(
    '<g fill="none" stroke="#000" stroke-width="1.8"><circle cx="12" cy="12" r="9"/><path d="M9.5 9.5a2.5 2.5 0 1 1 3.5 2.3c-.6.3-1 .9-1 1.6V14M12 17.2v.3"/></g>',
  );

  const HpGlyph(this.body);
  final String body;

  String get svg =>
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">$body</svg>';
}

class HpIcon extends StatelessWidget {
  const HpIcon(this.glyph, {super.key, this.size = 22, this.color});

  final HpGlyph glyph;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? IconTheme.of(context).color ?? const Color(0xFF0B1210);
    return SvgPicture.string(
      glyph.svg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(c, BlendMode.srcIn),
    );
  }
}

/// El icono del app: pirámide de tres cuerpos con escalinata.
class PyramidMark extends StatelessWidget {
  const PyramidMark({super.key, this.size = 40, this.radius});

  final double size;
  final double? radius;

  static const _svg =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">'
      '<rect width="1024" height="1024" fill="#9BE36D"/>'
      '<g fill="#0B1210"><polygon points="136,808 888,808 820,640 204,640"/>'
      '<polygon points="256,604 768,604 708,456 316,456"/>'
      '<polygon points="368,420 656,420 606,296 418,296"/>'
      '<rect x="436" y="224" width="152" height="72"/></g>'
      '<polygon points="480,296 544,296 576,808 448,808" fill="#9BE36D"/></svg>';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? size * 0.225),
      child: SvgPicture.string(_svg, width: size, height: size),
    );
  }
}
