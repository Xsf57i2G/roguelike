class_name Room
extends Node3D

var boundary = Vector3(64, 64, 64)
var depth = 16
var doors = []
var height = 16
var noise = FastNoiseLite.new()
var voxel = preload("res://scene/voxel.tscn")
var width = 16

func generate():
	var r = Vector3(
		randi_range(1, boundary.x - width - 1),
		randi_range(1, boundary.y - height - 1),
		randi_range(1, boundary.z - depth - 1)
	)

	for x in range(width):
		for y in range(height):
			for z in range(depth):
				if x == 0 or x == width - 1 or y == 0 or y == height - 1 or z == 0 or z == depth - 1:
					var v = voxel.instantiate()
					v.position = Vector3(x, y, z) + r
					add_child(v)
