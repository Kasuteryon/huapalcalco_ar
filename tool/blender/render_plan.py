"""Renderiza una planta ortogonal del modelo centrado.

La imagen sirve para ubicar las paradas: el pixel (px, py) corresponde a
x = (px / W - 0.5) * escala, y = (0.5 - py / H) * escala, en metros de Blender.
"""
import os
import sys

import bpy

sys.path.append(os.path.dirname(__file__))
from model_common import import_and_center, make_emission  # noqa: E402

argv = sys.argv[sys.argv.index("--") + 1:]
src, out = argv[0], argv[1]
obj, size = import_and_center(src)
make_emission(obj)
scale = max(size.x, size.y) * 1.04
sc = bpy.context.scene
sc.render.engine = 'BLENDER_EEVEE_NEXT' if 'BLENDER_EEVEE_NEXT' in [
    e.identifier for e in bpy.types.RenderSettings.bl_rna.properties['engine'].enum_items] else 'BLENDER_EEVEE'
sc.render.resolution_x = sc.render.resolution_y = 1000
sc.render.film_transparent = True
sc.view_settings.view_transform = 'Standard'
cam_data = bpy.data.cameras.new("cam")
cam_data.type = 'ORTHO'
cam_data.ortho_scale = scale
cam = bpy.data.objects.new("cam", cam_data)
sc.collection.objects.link(cam)
sc.camera = cam
cam.location = (0, 0, 30)
cam.rotation_euler = (0, 0, 0)  # mira hacia -Z, arriba de la imagen es +Y, derecha es +X
sc.render.filepath = out
bpy.ops.render.render(write_still=True)
print("PLAN_SCALE", round(scale, 4), "SIZE", tuple(round(v, 3) for v in size))
