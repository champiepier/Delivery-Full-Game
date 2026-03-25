extends CharacterBody3D

@onready var interact_ray: RayCast3D = $CameraPivot/Camera3D/InteractRay

@onready var camera_pivot_og_position = $CameraPivot.position.y

var speed = 5.0
var crouch_speed = 2.5
const JUMP_VELOCITY = 4.5

var SENSITIVITY = 0.003

var gravity = 9.8

const BOB_FREQ = 2.0
const BOB_AMP = 0.06
var t_bob = 0.0

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_pivot.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(100))
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
		
	# head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	if interact_ray.is_colliding() and !interact_ray.get_collider().name in ["Walls", "Ceiling", "Floors"]:
		$"../GUI/Crosshair".is_colliding = true
	else:
		$"../GUI/Crosshair".is_colliding = false

	move_and_slide()
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	
func find_crosshair_col() -> StaticBody3D:
	return interact_ray.get_collider()
