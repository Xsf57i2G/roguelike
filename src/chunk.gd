@tool

class_name Chunk
extends MeshInstance3D

@export var hp = 1
@export var size = 16

var blocks = []
var faces = 0
var a_mesh = ArrayMesh.new()
var vertices = PackedVector3Array()
var indices = PackedInt32Array()
var normals = PackedVector3Array()

func init_blocks(s, at):
	size = s

	blocks.resize(s)
	for x in range(s):
		blocks[x] = []
		for y in range(s):
			blocks[x].append([])
			for z in range(s):
				blocks[x][y].append(get_parent().get_block(Vector3i(x, y, z) + at))

func hit(n):
	hp -= n
	if hp <= 0:
		queue_free()

func add_triangles():
	indices.append(faces * 4 + 0)
	indices.append(faces * 4 + 1)
	indices.append(faces * 4 + 2)
	indices.append(faces * 4 + 0)
	indices.append(faces * 4 + 2)
	indices.append(faces * 4 + 3)
	faces += 1

func gen_cube_mesh(at):
	if is_air(at + Vector3(0, 1, 0)):
		# Top
		vertices.append(at + Vector3(-0.5, 0.5, -0.5))
		vertices.append(at + Vector3(0.5, 0.5, -0.5))
		vertices.append(at + Vector3(0.5, 0.5, 0.5))
		vertices.append(at + Vector3(-0.5, 0.5, 0.5))

		normals.append(Vector3(0, 1, 0))
		normals.append(Vector3(0, 1, 0))
		normals.append(Vector3(0, 1, 0))
		normals.append(Vector3(0, 1, 0))

		add_triangles()

	if is_air(at + Vector3(1, 0, 0)):
		# East
		vertices.append(at + Vector3(0.5, 0.5, 0.5))
		vertices.append(at + Vector3(0.5, 0.5, -0.5))
		vertices.append(at + Vector3(0.5, -0.5, -0.5))
		vertices.append(at + Vector3(0.5, -0.5, 0.5))

		normals.append(Vector3(1, 0, 0))
		normals.append(Vector3(1, 0, 0))
		normals.append(Vector3(1, 0, 0))
		normals.append(Vector3(1, 0, 0))

		add_triangles()

	if is_air(at + Vector3(0, 0, 1)):
		# South
		vertices.append(at + Vector3(-0.5, 0.5, 0.5))
		vertices.append(at + Vector3(0.5, 0.5, 0.5))
		vertices.append(at + Vector3(0.5, -0.5, 0.5))
		vertices.append(at + Vector3(-0.5, -0.5, 0.5))

		normals.append(Vector3(0, 0, 1))
		normals.append(Vector3(0, 0, 1))
		normals.append(Vector3(0, 0, 1))
		normals.append(Vector3(0, 0, 1))

		add_triangles()

	if is_air(at + Vector3(-1, 0, 0)):
		# West
		vertices.append(at + Vector3(-0.5, 0.5, -0.5))
		vertices.append(at + Vector3(-0.5, 0.5, 0.5))
		vertices.append(at + Vector3(-0.5, -0.5, 0.5))
		vertices.append(at + Vector3(-0.5, -0.5, -0.5))

		normals.append(Vector3(-1, 0, 0))
		normals.append(Vector3(-1, 0, 0))
		normals.append(Vector3(-1, 0, 0))
		normals.append(Vector3(-1, 0, 0))

		add_triangles()

	if is_air(at + Vector3(0, 0, -1)):
		# North
		vertices.append(at + Vector3(0.5, 0.5, -0.5))
		vertices.append(at + Vector3(-0.5, 0.5, -0.5))
		vertices.append(at + Vector3(-0.5, -0.5, -0.5))
		vertices.append(at + Vector3(0.5, -0.5, -0.5))

		normals.append(Vector3(0, 0, -1))
		normals.append(Vector3(0, 0, -1))
		normals.append(Vector3(0, 0, -1))
		normals.append(Vector3(0, 0, -1))

		add_triangles()

	if is_air(at + Vector3(0, -1, 0)):
		# Bottom
		vertices.append(at + Vector3(-0.5, -0.5, 0.5))
		vertices.append(at + Vector3(0.5, -0.5, 0.5))
		vertices.append(at + Vector3(0.5, -0.5, -0.5))
		vertices.append(at + Vector3(-0.5, -0.5, -0.5))

		normals.append(Vector3(0, -1, 0))
		normals.append(Vector3(0, -1, 0))
		normals.append(Vector3(0, -1, 0))
		normals.append(Vector3(0, -1, 0))

		add_triangles()

func gen_cube():
	a_mesh = ArrayMesh.new()
	vertices = PackedVector3Array()
	indices = PackedInt32Array()
	normals = PackedVector3Array()

	for x in range(size):
		for y in range(size):
			for z in range(size):
				if blocks[x][y][z] == 0:
					continue
				gen_cube_mesh(Vector3(x, y, z))

	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = vertices
	array[Mesh.ARRAY_INDEX] = indices

	a_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh = a_mesh

func is_air(at):
	if at.x < 0 or at.y < 0 or at.z < 0:
		var block = get_parent().get_block(at + position)
		return block == 0
	if at.x >= size or at.y >= size or at.z >= size:
		var block = get_parent().get_block(at + position)
		return block == 0
	return blocks[int(at.x)][int(at.y)][int(at.z)] == 0

func gen_chunk():
	a_mesh = ArrayMesh.new()
	vertices = PackedVector3Array()
	indices = PackedInt32Array()
	normals = PackedVector3Array()

	for x in range(size):
		for y in range(size):
			for z in range(size):
				if blocks[x][y][z] == 0:
					continue
				gen_cube_mesh(Vector3(x, y, z))

	if vertices.size() == 0 or indices.size() == 0:
		return

	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = vertices
	array[Mesh.ARRAY_INDEX] = indices
	array[Mesh.ARRAY_NORMAL] = normals

	a_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh = a_mesh
