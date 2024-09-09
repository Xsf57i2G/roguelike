class_name Damage
extends Label3D

var amount = 0.0
var force = 0.0
var direction = Vector3.ZERO

func _ready():
	var t = create_tween()
	var end = position + Vector3(randf(), 1.0, 0)

	t.tween_property(self, "position", end, 1.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	t.finished.connect(queue_free)

func display(n):
	var step = 1
	var damage = snapped(n, step)

	text = str(damage)
