@tool
class_name Face
extends Node3D

const VERTICES = [
	Vector3(-0.5, -0.5, -0.5),
	Vector3(0.5, -0.5, -0.5),
	Vector3(0.5, 0.5, -0.5),
	Vector3(-0.5, 0.5, -0.5),
	Vector3(-0.5, -0.5, 0.5),
	Vector3(0.5, -0.5, 0.5),
	Vector3(0.5, 0.5, 0.5),
	Vector3(-0.5, 0.5, 0.5),
]

const FACES = [
	[0, 1, 2, 3], # Front face
	[4, 5, 6, 7], # Back face
	[0, 1, 5, 4], # Bottom face
	[2, 3, 7, 6], # Top face
	[1, 2, 6, 5], # Right face
	[0, 3, 7, 4], # Left face
]

var st = SurfaceTool.new()

func _ready():
	generate()

func generate():
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for face in FACES:
		st.add_vertex(VERTICES[face[0]])
		st.add_vertex(VERTICES[face[1]])
		st.add_vertex(VERTICES[face[2]])
		st.add_vertex(VERTICES[face[2]])
		st.add_vertex(VERTICES[face[3]])
		st.add_vertex(VERTICES[face[0]])

	st.index()
	st.generate_normals()

	var mesh = st.commit()
	var instance = MeshInstance3D.new()

	instance.mesh = mesh
	add_child(instance)
