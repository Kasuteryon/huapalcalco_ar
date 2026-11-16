/// Paradas del recorrido.
///
/// Los nombres y textos son preliminares y están sujetos a validación del INAH.
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
    title: 'Plaza',
    complement: 'frente a la pirámide',
    body:
        'Espacio abierto frente a la escalinata. Desde aquí se ve el conjunto '
        'completo: la pirámide, el monolito en su recinto y las plataformas.',
    distance: 9.5,
    polar: 0.5,
  ),
  Stop(
    id: 'monolito',
    title: 'Monolito',
    complement: 'en su recinto',
    body:
        'Piedra tallada en la plaza, protegida por un recinto. Se observa '
        'desde fuera, sin tocarla.',
    distance: 5.0,
    polar: 0.6,
  ),
  Stop(
    id: 'escalinata',
    title: 'Escalinata',
    complement: 'de acceso',
    body:
        'Sube desde la plaza hacia los cuerpos de la pirámide. Es el acceso '
        'principal del edificio.',
    distance: 6.5,
    polar: 0.42,
  ),
  Stop(
    id: 'piramide',
    title: 'Pirámide',
    complement: 'de tres cuerpos',
    body:
        'Tres cuerpos escalonados con influencia teotihuacana. En la '
        'excavación se registraron fragmentos de pintura mural con círculos '
        'rojos sobre blanco.',
    distance: 10.0,
    polar: 0.75,
  ),
  Stop(
    id: 'cubierta',
    title: 'Cubierta',
    complement: 'zona protegida',
    body:
        'Techo de protección sobre un sector excavado de la pirámide. Resguarda '
        'la superficie original de la lluvia y el sol.',
    distance: 5.5,
    polar: 0.5,
  ),
  Stop(
    id: 'plataforma',
    title: 'Plataforma',
    complement: 'lateral',
    body:
        'Plataforma baja adosada a la pirámide, con su propia escalinata en el '
        'extremo.',
    distance: 7.0,
    polar: 0.55,
  ),
];
