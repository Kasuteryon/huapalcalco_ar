# Huapalcalco en realidad aumentada

App de Flutter para la Zona de Monumentos Arqueológicos de Huapalcalco, Tulancingo, Hidalgo. Proyecto en conjunto con el INAH.

La línea gráfica está en [docs/Linea_Grafica_Huapalcalco_AR.pdf](docs/Linea_Grafica_Huapalcalco_AR.pdf).

## Cómo correrla

```bash
flutter pub get
flutter run
```

Flutter GPU ya está activado en `ios/Runner/Info.plist` y en `AndroidManifest.xml`, así que no hace falta ningún flag. El visor 3D usa [flutter_scene](https://pub.dev/packages/flutter_scene), que necesita Flutter 3.47 o superior. Su build hook (`hook/build.dart`) convierte `assets/models/huapalcalco.glb` al formato del motor durante la compilación.

## Estructura

| Carpeta | Contenido |
| --- | --- |
| `lib/theme` | Colores, tipografía y medidas de la línea gráfica |
| `lib/data/stops.dart` | Paradas del recorrido (textos preliminares) |
| `lib/scene` | Carga del modelo, cámara en órbita y marcadores |
| `lib/screens` | Sitio, Recorrido, Estratos y Acervo |
| `lib/app_shell.dart` | Barra de pestañas en teléfono, barra lateral en tablet |
| `lib/ar` y `ios/Runner/AppDelegate.swift` | AR con Quick Look en iOS |
| `tool/blender` | Scripts para regenerar los modelos |

## Regenerar el modelo

El GLB original del dron vive fuera del repositorio. Para volver a generar el GLB del visor (textura de 4K, sin iluminación, con un nodo `poi_<id>` por parada) y el USDZ de AR (textura de 2K, escala 1:50):

```bash
/Applications/Blender.app/Contents/MacOS/Blender -b --factory-startup -P tool/blender/prepare_model.py -- "<ruta>/Modelado_completo_vegetacion.glb" assets/models
```

Para mover una parada, cambia sus coordenadas en `STOPS` dentro de `prepare_model.py`. Las coordenadas son píxeles de la planta que genera `tool/blender/render_plan.py`.

## Pendiente

- AR en Android (ARCore o Scene Viewer).
- Validar con el INAH los nombres de las paradas, los textos y las fechas.
- Probar AR Quick Look en un iPhone físico. El simulador no muestra modelos 3D en Quick Look.
