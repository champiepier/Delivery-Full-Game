extends Control

@onready var progress_bar: ProgressBar = $MarginContainer2/MarginContainer/VBoxContainer/ProgressBar
@export var next_scene_path: String = "res://Scenes/delivery_num.tscn"
var progress: Array[float] = []

var stop_process: bool = false

func _ready() -> void:
	ResourceLoader.load_threaded_request(next_scene_path)
	stop_process = true
	await get_tree().create_timer(2.0).timeout
	stop_process = false
	
func _process(_delta: float) -> void:
	
	if stop_process:
		return
	else:
	
		var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
		
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				var pct = progress[0] * 100
				progress_bar.value = pct
			ResourceLoader.THREAD_LOAD_LOADED:
				var scene = ResourceLoader.load_threaded_get(next_scene_path)
				get_tree().change_scene_to_packed(scene)
