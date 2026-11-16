import 'package:flutter/material.dart';

import '../theme/hp_theme.dart';
import '../widgets/hp_icon.dart';
import '../widgets/hp_widgets.dart';

/// Pestaña Acervo: fichas del sitio, cuidado y créditos institucionales.
class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key, required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final side = wide ? HpSpace.s32 : HpSpace.s16;
    final cards = <Widget>[
      const _Entry(
        eyebrow: 'EL NOMBRE',
        title: 'Lugar de la casa',
        complement: 'de madera',
        body: 'Huapalcalco viene del náhuatl huapalli, tabla o viga, y calli, casa, con el locativo co.',
      ),
      const _Entry(
        eyebrow: 'PINTURA RUPESTRE',
        eyebrowColor: HpColors.almagre,
        title: 'Rojo sobre roca',
        complement: 'en los abrigos',
        body: 'Figuras humanas, un cazador con átlatl, una lagartija, manos y astros, en varios tonos de rojo, blanco y negro.',
      ),
      const _Entry(
        eyebrow: 'LEYENDA',
        title: 'El puente',
        complement: 'del 24 de junio',
        body: 'Se cuenta que la ciudad quedó enterrada y que a medianoche del 24 de junio aparece un puente sobre la pirámide.',
      ),
      const _Entry(
        eyebrow: 'CUIDADO DEL SITIO',
        title: 'Mira sin tocar',
        complement: 'y sin rayar',
        body: 'Las pinturas y los muros se dañan con el contacto y el grafiti. Camina solo por los senderos abiertos al público.',
      ),
    ];
    return ListView(
      padding: EdgeInsets.fromLTRB(side, pad.top + 12, side, pad.bottom + 120),
      children: [
        TitlePair('Acervo', 'fichas y créditos', size: wide ? 40 : 32),
        const SizedBox(height: HpSpace.s24),
        if (wide)
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 236,
            ),
            children: cards,
          )
        else
          for (final c in cards)
            Padding(padding: const EdgeInsets.only(bottom: 12), child: c),
        const SizedBox(height: HpSpace.s12),
        const _Credits(),
        const SizedBox(height: HpSpace.s16),
        const DraftNote(),
      ],
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry({
    required this.eyebrow,
    required this.title,
    required this.complement,
    required this.body,
    this.eyebrowColor = HpColors.monte,
  });

  final String eyebrow;
  final String title;
  final String complement;
  final String body;
  final Color eyebrowColor;

  @override
  Widget build(BuildContext context) {
    return HpCard(
      padding: const EdgeInsets.all(HpSpace.s16 + 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: HpText.eyebrow.copyWith(color: eyebrowColor, fontSize: 11),
          ),
          const SizedBox(height: 8),
          TitlePair(title, complement, size: 22),
          const SizedBox(height: 8),
          Text(body, style: HpText.bodyMuted),
        ],
      ),
    );
  }
}

class _Credits extends StatelessWidget {
  const _Credits();

  @override
  Widget build(BuildContext context) {
    return HpCard(
      padding: const EdgeInsets.all(HpSpace.s24),
      child: Column(
        children: [
          const PyramidMark(size: 56),
          const SizedBox(height: 12),
          const TitlePair('Huapalcalco', 'en realidad aumentada', size: 24),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo-inah.png',
                height: 64,
                semanticLabel: 'INAH',
              ),
              Container(
                width: 1,
                height: 52,
                color: HpColors.line,
                margin: const EdgeInsets.symmetric(horizontal: 20),
              ),
              Image.asset(
                'assets/images/logo-upiih.png',
                height: 64,
                semanticLabel: 'UPIIH',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Diseño y desarrollo', style: HpText.caption),
          const Text(
            'Eduardo Ignacio Castellón Castillo',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            'Proyecto en conjunto con el Instituto Nacional de Antropología e Historia. '
            'Modelo 3D obtenido por fotogrametría con dron.',
            textAlign: TextAlign.center,
            style: HpText.caption,
          ),
        ],
      ),
    );
  }
}
