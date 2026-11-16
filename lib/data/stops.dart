/// Paradas del recorrido.
///
/// Fuente de los textos: ficha oficial del INAH, https://lugares.inah.gob.mx/es/node/4414
/// La parada "cubierta" describe un elemento moderno visible en el modelo y no
/// aparece en esa ficha. Todo el contenido queda sujeto a revisión del INAH.
///
/// Cada parada corresponde a un nodo vacío `poi_<id>` dentro del modelo,
/// generado por tool/blender/prepare_model.py.
class Stop {
  const Stop({
    required this.id,
    required this.title,
    required this.complement,
    required this.body,
    this.distance = 7.0,
    this.polar = 0.55,
  });

  final String id;
  final String title;
  final String complement;
  final String body;

  /// Distancia de la cámara a la parada, en metros del modelo.
  final double distance;

  /// Elevación de la cámara, en radianes.
  final double polar;

  String get nodeName => 'poi_$id';
}

const List<Stop> kStops = [
  Stop(
    id: 'plaza',
    title: 'Plaza ceremonial',
    complement: 'restaurada en 1954',
    body:
        'Espacio abierto con la pirámide principal al oriente y un anexo '
        'piramidal en el lado norte. Al centro está el altar-estela.',
    distance: 9.5,
    polar: 0.5,
  ),
  Stop(
    id: 'altar',
    title: 'Altar-estela',
    complement: 'al centro de la plaza',
    body:
        'Una piedra irregular, sin trabajar. César Lizardi Ramos la registró '
        'como altar y presunta estela.',
    distance: 5.0,
    polar: 0.6,
  ),
  Stop(
    id: 'escalinata',
    title: 'Escalinata',
    complement: 'fachada poniente',
    body:
        'Ocho escalones limitados por alfardas lisas. Arranca de un zócalo que '
        'corre a lo largo de todo el frente del monumento.',
    distance: 6.5,
    polar: 0.42,
  ),
  Stop(
    id: 'piramide',
    title: 'Pirámide',
    complement: 'principal',
    body:
        'Tiene varias etapas constructivas superpuestas. Sus elementos de '
        'talud y tablero muestran influencia teotihuacana.',
    distance: 10.0,
    polar: 0.75,
  ),
  Stop(
    id: 'cubierta',
    title: 'Cubierta',
    complement: 'de protección',
    body:
        'Techo moderno colocado sobre un sector de la pirámide para protegerlo '
        'de la lluvia y el sol.',
    distance: 5.5,
    polar: 0.5,
  ),
  Stop(
    id: 'anexo',
    title: 'Anexo piramidal',
    complement: 'al norte de la plaza',
    body:
        'Estructura piramidal que cierra la plaza por su lado norte, frente '
        'al altar-estela.',
    distance: 7.0,
    polar: 0.55,
  ),
];
