class_name Character
extends CharacterBody3D

@export var invulnerable = false
@export var inventory = [Item.new()]
@export var mana = 100
@export var armor = 0
@export var speed = 64
@export var hp = 3
@export var alive = true
@export var fleeing = false

func _ready():
	pass

func move(direction):
	velocity = direction * speed

func jump():
	velocity.y = speed

func hit(n: int):
	hp -= n
	if hp <= 0:
		queue_free()

func wander():
	var r = randi() % 4
	move(r)

func follow(target):
	var direction = target.global_position - global_position
	direction = direction.normalized()
	move(direction)

func flee(target):
	var direction = global_position - target.global_position
	direction = direction.normalized()
	move(direction)

func drink(potion):
	if potion is Potion:
		potion.effect(self)
