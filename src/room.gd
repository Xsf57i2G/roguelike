@tool

class_name Room
extends Node3D

var boundary = Vector3(64, 64, 64)
var size = 16.0
var doors = []
var noise = FastNoiseLite.new()
var voxel = load("res://scene/voxel.tscn")

func generate():
	var r = Vector3(
		randi_range(1, boundary.x - size - 1),
		randi_range(1, boundary.y - size - 1),
		randi_range(1, boundary.z - size - 1)
	)

	for x in range(size):
		for y in range(size):
			for z in range(size):
				if x == 0 or x == size - 1 or y == 0 or y == size - 1 or z == 0 or z == size - 1:
					var v = voxel.instantiate()
					v.position = Vector3(x, y, z) + r
					add_child(v)
