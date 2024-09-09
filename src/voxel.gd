class_name Voxel
extends StaticBody3D

@export var hp = 1

func hit(n):
	hp -= n
	if hp <= 0:
		queue_free()

func generate():
	var instance = MeshInstance3D.new()
	instance.mesh = Mesh.new()

	var face = Face.new()
	add_child(face)
	face.generate()
