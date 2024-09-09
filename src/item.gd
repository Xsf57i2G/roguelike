class_name Item
extends StaticBody3D

var damage = 1
var hp = 1
var speed = 1
var value = 1
var durability = 1

func hit(n):
	hp -= n
	if hp <= 0:
		queue_free()
