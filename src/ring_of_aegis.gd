extends Node

func _process(_delta):
	for body in $Area3D.get_overlapping_bodies():
		if body is Character:
			body.armor += 1
