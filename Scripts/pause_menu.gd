extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.hide()
	get_tree().paused = false


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_debug_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$"../InteractingObjName".visible = true
	else:
		$"../InteractingObjName".visible = false


func _on_controls_pressed() -> void:
	$MarginContainer/ControlsSetting.show()
