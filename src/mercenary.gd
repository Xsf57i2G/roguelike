class_name Mercenary
extends Character

@onready var camera := $Camera3D
@onready var ray := $Camera3D/RayCast3D

const SPEED = 5.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * .1))
		camera.rotate_x(deg_to_rad(-event.relative.y * .1))
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

func _physics_process(delta: float):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if Input.is_action_just_pressed("drop"):
		drop()

	if Input.is_action_pressed("up"):
		global_position.y += 0.2
	if Input.is_action_pressed("down"):
		global_position.y -= 0.2
	if Input.is_action_just_pressed("use"):
		$AnimationPlayer.stop()
		$AnimationPlayer.play("Use")

		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider:
				collider.hit(1)

	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 3.0)

	var bob = 0.0

	bob += delta * velocity.length() * 10.0
	camera.transform.origin = Vector3(0, sin(bob * 2.0) * 0.1, 0)

	move_and_slide()

func drop():
	var item = null
	for i in $Camera3D/Inventory.get_children():
		if i is Item:
			item = i
			break

	if item:
		$Camera3D/Inventory.remove_child(item)

		var ray_start = global_transform.origin
		var ray_end = ray_start + Vector3(0, -20, 0)

		var query = PhysicsRayQueryParameters3D.new()
		query.from = ray_start
		query.to = ray_end

		var space_state = get_world_3d().direct_space_state
		var result = space_state.intersect_ray(query)

		if result.size() > 0:
			var ground_position = result.position

			item.global_transform.origin = ground_position
			item.rotation_degrees = Vector3(90, 0, 0)

		get_tree().root.add_child(item)

func pickup(item):
	if item:
		$Camera3D/Inventory.add_child(item)

func _on_inventory_body_entered(body):
	if body is Item:
		pickup(body)
