extends StaticBody3D

func use():
	var bodies = $Area3D.get_overlapping_bodies()

	for body in bodies:
		if body is CharacterBody3D:
			pass
