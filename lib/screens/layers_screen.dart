import 'package:flutter/material.dart';

import '../theme/hp_theme.dart';
import '../widgets/hp_widgets.dart';

class _Layer {
  const _Layer(this.title, this.complement, this.body, {this.rockArt = false});
  final String title;
  final String complement;
  final String body;
  final bool rockArt;
}

// De lo más reciente (arriba) a lo más profundo (abajo), como en una excavación.
// Las fechas se agregan cuando el INAH las valide.
const _layers = [
  _Layer(
    'Hoy',
    'zona de monumentos',
    'El INAH resguarda el sitio y continúa su investigación. La mayor parte del asentamiento sigue sin excavar.',
  ),
  _Layer(
    'Tradición tolteca',
    'Ce Ácatl Topiltzin',
    'La tradición cuenta que aquí construyó su casa de madera, el huapalcalli, antes de gobernar Tula.',
  ),
  _Layer(
    'Centro ceremonial',
    'influencia teotihuacana',
    'Se levantan la plaza y la pirámide de tres cuerpos, con acabados de estuco y pintura mural.',
  ),
  _Layer(
    'Pinturas rupestres',
    'antigüedad en estudio',
    'Las propuestas van desde grupos de cazadores hasta tradiciones mesoamericanas posteriores.',
    rockArt: true,
  ),
  _Layer(
    'Abrigos rocosos',
    'primeros ocupantes',
    'Los grupos más antiguos del valle se refugiaron en los abrigos de los acantilados de La Mesa y El Huiztli.',
  ),
];

/// Pestaña Estratos: el tiempo en capas, de hoy hacia lo más antiguo.
class LayersScreen extends StatelessWidget {
  const LayersScreen({super.key, required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final side = wide ? HpSpace.s32 : HpSpace.s16;
    return ListView(
      padding: EdgeInsets.fromLTRB(side, pad.top + 12, side, pad.bottom + 120),
      children: [
        TitlePair('Estratos', 'el tiempo en capas', size: wide ? 40 : 32),
        const SizedBox(height: HpSpace.s12),
        Text(
          'De hoy hacia lo más antiguo, como se lee una excavación.',
          style: HpText.bodyMuted,
        ),
        const SizedBox(height: HpSpace.s24),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                for (var i = 0; i < _layers.length; i++) ...[
                  _LayerCard(layer: _layers[i], depth: i),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: HpSpace.s8),
        Text('Fechas por validar con el INAH.', style: HpText.caption),
      ],
    );
  }
}

class _LayerCard extends StatelessWidget {
  const _LayerCard({required this.layer, required this.depth});

  final _Layer layer;
  final int depth;

  @override
  Widget build(BuildContext context) {
    return HpCard(
      padding: const EdgeInsets.all(HpSpace.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Las capas se oscurecen con la profundidad.
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.lerp(
                HpColors.canvas,
                HpColors.monte,
                depth / (_layers.length - 1),
              ),
            ),
            child: Text(
              '${depth + 1}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: depth >= 2 ? HpColors.white : HpColors.monte,
              ),
            ),
          ),
          const SizedBox(width: HpSpace.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (layer.rockArt)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      'PINTURA RUPESTRE',
                      style: HpText.eyebrow.copyWith(
                        color: HpColors.almagre,
                        fontSize: 11,
                      ),
                    ),
                  ),
                TitlePair(layer.title, layer.complement, size: 20),
                const SizedBox(height: 8),
                Text(layer.body, style: HpText.bodyMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
