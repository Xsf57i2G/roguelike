extends Node3D

func _ready():
	var dungeon := Dungeon.new()

	add_child(dungeon)

	dungeon.generate()
