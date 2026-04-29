extends Node

var is_looking: bool = false
var power_out: bool = false
var no_oxygen: bool = false

var typed_code: String
var code: String = "1234"

var delivery_num: int = 1

var power_left: float = 65.0

signal interact()
signal correct_code()
signal incorrect_code()
		
func add_code_digit(digit):
	typed_code += str(digit)
	print(typed_code)
	
func _physics_process(delta: float) -> void:
		
	if typed_code.length() == 4:
		if typed_code == code:
			correct_code.emit()
			is_looking = false
		else:
			incorrect_code.emit()
		typed_code = ""
		
		
