class_name Dungeon
extends Node3D

@export var noise = FastNoiseLite.new()

var width = 64
var height = 64
var depth = 64
var corridors = []
var rooms = []
var voxel = preload("res://scene/voxel.tscn")

func _ready():
	generate()

func generate():
	noise.seed = randi()

	for i in range(16):
		var room = Room.new()
		room.generate()
		rooms.append(room)
		add_child(room)

	fill_with_noise()

func fill_with_noise():
	for x in range(width):
		for y in range(height):
			for z in range(depth):
				var n = noise.get_noise_3d(x, y, z)
				if n > 0.1:
					var v = voxel.instantiate()
					v.position = Vector3(x, y, z)
					add_child(v)
