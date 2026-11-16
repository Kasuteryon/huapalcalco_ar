"""Prepara los archivos del modelo para el app.

Genera, a partir del GLB original del dron:
  assets/models/huapalcalco.glb   visor 3D, textura de 4096 px, material sin iluminación,
                                  con un nodo vacío por parada (poi_<id>)
  assets/models/huapalcalco.usdz  AR en iOS (Quick Look), textura de 2048 px, escala 1:50

Uso:
  Blender -b --factory-startup -P tool/blender/prepare_model.py -- <glb original> <carpeta salida>
"""
import os
import sys

import bpy
import mathutils

sys.path.append(os.path.dirname(__file__))
from model_common import import_and_center  # noqa: E402

# Paradas ubicadas sobre la planta ortogonal de render_plan.py (1000 x 1000 px).
PLAN_SCALE = 17.3193
STOPS = {
    'plaza': (620, 230),
    'monolito': (423, 145),
    'escalinata': (440, 405),
    'piramide': (450, 610),
    'cubierta': (575, 705),
    'plataforma': (180, 610),
}
AR_SCALE = 1 / 50

argv = sys.argv[sys.argv.index("--") + 1:]
src, out_dir = argv[0], argv[1]
os.makedirs(out_dir, exist_ok=True)

obj, size = import_and_center(src)
scene = bpy.context.scene
depsgraph = bpy.context.evaluated_depsgraph_get()

# Un nodo vacío por parada, sobre la superficie del modelo.
for stop_id, (px, py) in STOPS.items():
    x = (px / 1000 - 0.5) * PLAN_SCALE
    y = (0.5 - py / 1000) * PLAN_SCALE
    hit, loc, *_ = scene.ray_cast(depsgraph, mathutils.Vector((x, y, 20)), mathutils.Vector((0, 0, -1)))
    z = loc.z if hit else 0.0
    empty = bpy.data.objects.new(f"poi_{stop_id}", None)
    empty.location = (x, y, z)
    scene.collection.objects.link(empty)
    print("POI", stop_id, round(x, 3), round(y, 3), round(z, 3))

mat = obj.active_material
nt = mat.node_tree
img_node = [n for n in nt.nodes if n.type == 'TEX_IMAGE'][0]
out_node = [n for n in nt.nodes if n.type == 'OUTPUT_MATERIAL'][0]
principled = [n for n in nt.nodes if n.type == 'BSDF_PRINCIPLED'][0]
image = img_node.image

# GLB del visor: material sin iluminación (KHR_materials_unlit) y textura de 4K.
bg = nt.nodes.new('ShaderNodeBackground')
nt.links.new(img_node.outputs[0], bg.inputs[0])
nt.links.new(bg.outputs[0], out_node.inputs[0])
image.scale(4096, 4096)
bpy.ops.export_scene.gltf(
    filepath=os.path.join(out_dir, 'huapalcalco.glb'),
    export_format='GLB',
    export_image_format='JPEG',
    export_jpeg_quality=86,
    export_yup=True,
)

# USDZ de AR: material estándar, textura de 2K, escala 1:50 para que quepa en una mesa.
nt.links.new(principled.outputs[0], out_node.inputs[0])
principled.inputs['Roughness'].default_value = 1.0
# El exportador de USD copia el archivo de origen, así que la textura reducida
# se guarda como un JPEG nuevo y se reasigna al material.
image.scale(2048, 2048)
small_path = os.path.join(bpy.app.tempdir, 'huapalcalco_2k.jpg')
scene.render.image_settings.file_format = 'JPEG'
scene.render.image_settings.quality = 85
image.save_render(small_path, scene=scene)
img_node.image = bpy.data.images.load(small_path)
for o in list(scene.objects):
    if o.type == 'EMPTY':
        bpy.data.objects.remove(o)
obj.scale = (AR_SCALE, AR_SCALE, AR_SCALE)
bpy.ops.object.select_all(action='DESELECT')
obj.select_set(True)
bpy.ops.object.transform_apply(scale=True)
bpy.ops.wm.usd_export(
    filepath=os.path.join(out_dir, 'huapalcalco.usdz'),
    export_materials=True,
    export_textures=True,
    export_normals=False,
    export_uvmaps=True,
)
print("DONE", tuple(round(v, 3) for v in size))
