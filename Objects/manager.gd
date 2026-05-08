extends Node

@onready var des_timer: Timer = $DesTimer
@onready var player: CharacterBody3D = $"../Player"
@onready var how_2_play: Control = $"../GUI/How2Play"
@onready var lights_timer: Timer = $LightsTimer
@onready var anims: AnimationPlayer = $"../anims"
@onready var oxygen_meter_timer: Timer = $OxygenMeterTimer
@onready var oxygen_bar: Control = $"../OxygenLevel/SubViewport/OxygenBar"
@onready var world_environment = $"../WorldEnvironment".get_environment()


var normal_color_texture = load("res://Assets/LUTs/normColor.tres")
var crazy_color_texture = load("res://Assets/LUTs/Cube/16-8bit.png")
var gas_leaking: bool = false

var valve_times_turned: int = 0
var turns_needed: int

var gas_strength: float = 0.05

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
	anims.play("DoorsShut")
	Global.correct_code.connect(_on_correct_code)
	Global.incorrect_code.connect(_on_incorrect_code)
	Global.button_press.connect(_on_button_pressed)
	Global.oxygen_gone.connect(no_oxygen_event)
	Global.generator_off.connect(turn_gen_off)
	Global.generator_on.connect(turn_gen_on)
	random_generator_time()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	
	if Global.is_looking:
		player.speed = 0.0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		player.speed = 5.0
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	Global.power_left = lights_timer.time_left
	
	if gas_leaking:
		$"../Player/CameraPivot/Camera3D/Distortion".mesh.material.set_shader_parameter("aberration_strength", gas_strength)
		turns_needed = round(randf() * 3) + 4
		player.speed = 2.5
		if not $"../Objects/GasValve/GasHiss".playing:
			$"../Objects/GasValve/GasHiss".play()
			var tween = create_tween()
			tween.tween_property(self, "gas_strength", 1.0, 5.0).from(0.05)
			Global.emit_signal("depelete_oxygen")
		$"../Objects/GasValve/ToxicGasVFX".emitting = true
	else:
		$"../Player/CameraPivot/Camera3D/Distortion".mesh.material.set_shader_parameter("aberration_strength", 0)
		valve_times_turned = 0
		turns_needed = 0
		player.speed = 5.0
		if $"../Objects/GasValve/GasHiss".playing:	
			$"../Objects/GasValve/GasHiss".stop()
			var tween = create_tween()
			tween.tween_property(self, "gas_strength", 0.0, 4.0)
		$"../Objects/GasValve/ToxicGasVFX".emitting = false
		
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
	if int_obj != null:
		if int_obj.name == "StaticBody3D":
			int_obj = int_obj.get_parent()
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
				"KeyPad":
					anims.play("LookAtKeypad")
				"KeyPad2":
					open_doors()
				"Main":
					Global.emit_signal("generator_on")
				_:
					$"../GUI/InteractingObjName".text = "#null_obj"

func show_object(obj_name):
	match obj_name:
		"HowToPlay":
			$"../GUI/How2Play".play_anim("show")
			Global.is_looking = true
			
func set_random_lights_timer():
	randomize()
	var random_wait_time: float = randf_range(23.0, 65.0)
	lights_timer.wait_time = random_wait_time
	lights_timer.start()
	
func random_generator_time():
	randomize()
	var random_gen_wait_time: float = randf_range(60.0, 75.0)
	var fake_chance: int = randi_range(1, 5)
	await get_tree().create_timer(random_gen_wait_time).timeout
	if fake_chance == 5:
		Global.emit_signal("generator_off")
		await get_tree().create_timer(5.0).timeout
		Global.emit_signal("generator_on")
	else:
		Global.emit_signal("generator_off")
	

func _on_lights_timer_timeout() -> void:
	gas_leaking = true
	
func turn_on_lights():
	$"../Objects/MainLight".show()
	$"../Objects/SubLights".show()
	Global.power_out = false
	
func open_doors():
	anims.play("DoorOpen")
	await get_tree().create_timer(7.5).timeout
	anims.play("DoorsShut")

func _on_anims_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Lights Flicker":
		$"../Objects/MainLight".hide()
		$"../Objects/SubLights".hide()
		Global.power_out = true
		oxygen_meter_timer.start()
	elif anim_name == "PressOxygenButton":
		oxygen_bar.increase_oxygen()
	elif anim_name == "LookAtKeypad":
		Global.is_looking = true
	elif anim_name == "TurnValve":
		valve_times_turned += 1
		if valve_times_turned == turns_needed:
			gas_leaking = false
			set_random_lights_timer()
		elif valve_times_turned > turns_needed:
			Global.depelete_oxygen.emit()
	elif anim_name == "player_fall":
		get_tree().change_scene_to_file("res://UI/lose_screen.tscn")
		
func check_oxygen():
	oxygen_bar.reduce_oxygen()

func _on_oxygen_meter_timer_timeout() -> void:
	if Global.power_out:
		check_oxygen()
		$OxygenMeterTimer.start()

func no_oxygen_event():
	$"../GUI/Vignette".show()
	world_environment.set_adjustment_color_correction(crazy_color_texture)
	await get_tree().create_timer(10.0).timeout
	anims.play("player_fall")

func _on_correct_code():
	$"../CorrectBuzzer".play()
	$"../GUI/KeypadFace".hide()
	open_doors()

func _on_incorrect_code():
	$"../IncorrectBuzzer".play()
	$"../GUI/KeypadFace".hide()

func _on_button_pressed():
	$"../ButtonPress".play()
	
func turn_gen_off():
	$"../GeneratorHum".stream_paused = true
	$"../OmniLight3D".hide()
	
func turn_gen_on():
	$"../GeneratorHum".stream_paused = false
	$"../OmniLight3D".show()
	random_generator_time()
