class_name Dungeon
extends MeshInstance3D

@export var noise = FastNoiseLite.new()

var chunks = {}
var size = 8
var corridors = []
var rooms = []
var boundary = Vector3(64, 64, 64)
var voxel = preload("res://scene/voxel.tscn")

func _ready():
	noise.seed = randi()

	generate()

func generate():
	for r in range(16):
		var room = Room.new()
		room.position = Vector3(randi_range(0, size * size), randi_range(0, size * size), randi_range(0, size * size))
		room.size = Vector3(randi_range(1, 4), randi_range(1, 4), randi_range(1, 4))
		rooms.append(room)
		add_child(room)

	for x in range(size):
		for y in range(size):
			for z in range(size):
				generate_chunk(Vector3i(x, y, z) * size)

				await Engine.get_main_loop().process_frame

func generate_chunk(at):
	var chunk = Chunk.new()
	chunk.position = at
	add_child(chunk)
	chunks[at] = chunk
	chunk.init_blocks(size, at)
	chunk.gen_chunk()

func get_block(at):
	if noise.get_noise_3d(at.x, at.y, at.z) > 0:
		return 1
	else:
		return 0
