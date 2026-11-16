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
    // Fuente: ficha oficial del INAH (https://lugares.inah.gob.mx/es/node/4414).
    // El significado del nombre viene de la Foto del día del INAH,
    // "Huapalcalco: primer hogar de Ce Ácatl Topiltzin" (27 de junio de 2023).
    final cards = <Widget>[
      const _Entry(
        eyebrow: 'EL NOMBRE',
        title: 'Casa de madera',
        complement: 'huapalcalli',
        body:
            'Se dice que aquí Ce Ácatl Topiltzin construyó su huapalcalli, una '
            'casa de madera, que da nombre a la zona arqueológica.',
      ),
      const _Entry(
        eyebrow: 'PINTURA RUPESTRE',
        eyebrowColor: HpColors.almagre,
        title: 'En los acantilados',
        complement: 'de La Mesa y El Tecolote',
        body:
            'Las pinturas rupestres pertenecen a la ocupación más antigua del '
            'sitio, junto con puntas de proyectil y un hacha de mano.',
      ),
      const _Entry(
        eyebrow: 'OBSIDIANA',
        title: 'Centro regional',
        complement: 'y cruce de caminos',
        body:
            'Huapalcalco aprovechó el yacimiento de obsidiana de El Pizarrín y '
            'fue paso entre la Cuenca de México y la Huasteca.',
      ),
      const _Entry(
        eyebrow: 'HALLAZGOS',
        title: 'Yugos y fuego',
        complement: 'piezas del sitio',
        body:
            'Dos yugos de origen totonaco, una escultura del Dios Viejo del '
            'Fuego, material de obsidiana y cerámica de varias épocas.',
      ),
      const _Entry(
        eyebrow: 'EXPLORACIÓN',
        title: 'Desde 1954',
        complement: 'Müller y Lizardi Ramos',
        body:
            'Las exploraciones comenzaron en 1954 con Florencia J. Müller y '
            'César Lizardi Ramos. Ese año se restauró la plaza ceremonial.',
      ),
      const _Entry(
        eyebrow: 'PLANEA TU VISITA',
        title: 'Todos los días',
        complement: 'de 9:00 a 17:00',
        body:
            'Último acceso a las 16:00. Entrada gratuita y visitas guiadas. '
            'No se permite fumar, introducir alimentos ni mascotas. '
            'Teléfono: 771 714 3520.',
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
              mainAxisExtent: 250,
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
          // const SizedBox(height: 20),
          // Text('Diseño y desarrollo', style: HpText.caption),
          // const Text(
          //   'Eduardo Ignacio Castellón Castillo',
          //   style: TextStyle(fontWeight: FontWeight.w600),
          // ),
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
