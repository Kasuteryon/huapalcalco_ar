"""Utilidades compartidas para preparar el modelo de Huapalcalco en Blender.

Se ejecutan con Blender en modo sin interfaz, por ejemplo:
  Blender -b --factory-startup -P tool/blender/prepare_model.py -- <args>
"""
import bpy
import mathutils


def import_and_center(src):
    """Importa el GLB y lo mueve para que el centro de la base quede en el origen."""
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.gltf(filepath=src)
    obj = [o for o in bpy.context.scene.objects if o.type == 'MESH'][0]
    bpy.context.view_layer.objects.active = obj
    obj.select_set(True)
    bpy.ops.object.transform_apply(location=True, rotation=True, scale=True)
    corners = [obj.matrix_world @ mathutils.Vector(c) for c in obj.bound_box]
    mn = mathutils.Vector([min(v[i] for v in corners) for i in range(3)])
    mx = mathutils.Vector([max(v[i] for v in corners) for i in range(3)])
    offset = mathutils.Vector(((mn.x + mx.x) / 2, (mn.y + mx.y) / 2, mn.z))
    obj.location -= offset
    bpy.ops.object.transform_apply(location=True)
    size = mx - mn
    return obj, size


def make_emission(obj, strength=1.0):
    """Material sin iluminación: la textura de fotogrametría ya trae su luz."""
    mat = obj.active_material
    nt = mat.node_tree
    img = [n for n in nt.nodes if n.type == 'TEX_IMAGE'][0]
    out = [n for n in nt.nodes if n.type == 'OUTPUT_MATERIAL'][0]
    em = nt.nodes.new('ShaderNodeEmission')
    em.inputs[1].default_value = strength
    nt.links.new(img.outputs[0], em.inputs[0])
    nt.links.new(em.outputs[0], out.inputs[0])
    return img
