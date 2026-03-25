extends Node

@onready var des_timer: Timer = $DesTimer
@onready var player: CharacterBody3D = $"../Player"
@onready var how_2_play: Control = $"../GUI/How2Play"
@onready var lights_timer: Timer = $LightsTimer
@onready var anims: AnimationPlayer = $"../anims"
@onready var oxygen_meter_timer: Timer = $OxygenMeterTimer
@onready var oxygen_bar: Control = $"../GUI/OxygenBar"
@onready var world_environment = $"../WorldEnvironment".get_environment()


var normal_color_texture = load("res://Assets/LUTs/normColor.tres")
var crazy_color_texture = load("res://Assets/LUTs/Cube/16-8bit.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("interact", on_interact)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	world_environment.set_adjustment_enabled(true)
	world_environment.set_adjustment_color_correction(normal_color_texture)
	$"../GUI/Vignette".hide()
	$"../GUI/Pause Menu".hide()
	$"../GUI/InteractingObjName".hide()
	lights_timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	
	if Global.is_looking:
		player.speed = 0.0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		player.speed = 5.0
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if Global.no_oxygen:
		no_oxygen_event()
		
	Global.power_left = lights_timer.time_left
		
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		$"../GUI/Pause Menu".show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		
	if event.is_action_pressed("screenshot"):
		screenshot()
		
func screenshot():
	$"../GUI".hide()
	await RenderingServer.frame_post_draw
	
	var timestamp = Time.get_datetime_string_from_system().replace(":", "-")
	var folder = ProjectSettings.globalize_path("user://Screenshots")
	if not DirAccess.dir_exists_absolute(folder):
		DirAccess.make_dir_recursive_absolute(folder)
	var path = "%s/screenshot_%s.jpg" % [folder, timestamp]
	
	# take scrnshot
	get_viewport().get_texture().get_image().save_jpg(path)
	$"../GUI".show()
		
func destination_reached():
	get_tree().change_scene_to_file("res://UI/win_screen.tscn")

func _on_des_timer_timeout() -> void:
	destination_reached()
	
func on_interact():
	var int_obj = player.find_crosshair_col()
	if int_obj != null and !int_obj.name in ["Walls", "Ceiling", "Floors"]:
		$"../GUI/InteractingObjName".text = str(int_obj.name)
		if int_obj.is_in_group("CanLookAt"):
			show_object(int_obj.name)
		elif "FoodCrate" in int_obj.name:
			int_obj.reset_food()
			
		match int_obj.name:
			"PowerBox":
				if lights_timer.time_left <= 0.0:
					turn_on_lights()
					set_random_lights_timer()
			"OxygenButton":
				anims.play("PressOxygenButton")
			"GasValve":
				anims.play("TurnValve")
			"MailBoxDoor":
				anims.play("open_mail_door")
				await get_tree().create_timer(5.0).timeout
				anims.play("close_mail_door")
			_:
				$"../GUI/InteractingObjName".text = "#null_obj"
		
		
func show_object(obj_name):
	match obj_name:
		"HowToPlay":
			$"../GUI/How2Play".play_anim("show")
			Global.is_looking = true
			
func set_random_lights_timer():
	randomize()
	var random_wait_time: int = roundf((randf() * 50) * 4)
	random_wait_time = clamp(random_wait_time, 45, 155)
	lights_timer.wait_time = random_wait_time
	$"../Objects/PowerBox/PowerLeft/SubViewport/EnergyLeftMeter".reset_energy_level(random_wait_time)
	lights_timer.start()

func _on_lights_timer_timeout() -> void:
	anims.play("Lights Flicker")
	
func turn_on_lights():
	$"../Objects/MainLight".show()
	$"../Objects/SubLights".show()
	Global.power_out = false

func _on_anims_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Lights Flicker":
		$"../Objects/MainLight".hide()
		$"../Objects/SubLights".hide()
		Global.power_out = true
		oxygen_meter_timer.start()
	elif anim_name == "PressOxygenButton":
		oxygen_bar.increase_oxygen()
		
func check_oxygen():
	oxygen_bar.reduce_oxygen()

func _on_oxygen_meter_timer_timeout() -> void:
	if Global.power_out:
		check_oxygen()
		$OxygenMeterTimer.start()

func no_oxygen_event():
	$"../GUI/Vignette".show()
	world_environment.set_adjustment_color_correction(crazy_color_texture)
	await get_tree().create_timer(15.0).timeout
	get_tree().change_scene_to_file("res://UI/lose_screen.tscn")
