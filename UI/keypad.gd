extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	Global.add_code_digit(7)


func _on_button_2_pressed() -> void:
	Global.add_code_digit(8)


func _on_button_3_pressed() -> void:
	Global.add_code_digit(9)

func _on_button_4_pressed() -> void:
	Global.add_code_digit(4)


func _on_button_5_pressed() -> void:
	Global.add_code_digit(5)


func _on_button_6_pressed() -> void:
	Global.add_code_digit(6)


func _on_button_7_pressed() -> void:
	Global.add_code_digit(1)


func _on_button_8_pressed() -> void:
	Global.add_code_digit(2)

func _on_button_9_pressed() -> void:
	Global.add_code_digit(3)
