extends Node

var is_looking: bool = false
var power_out: bool = false
var no_oxygen: bool = false

var typed_code: String
var code: String = "1234"

var delivery_num: int = 1

var power_left: float = 65.0

signal interact()
signal button_press()
signal correct_code()
signal incorrect_code()

signal generator_off()
signal generator_on()
		
func add_code_digit(digit):
	typed_code += str(digit)
	button_press.emit()
	
func _ready() -> void:
	code = generate_4_digit_string()
	
func _physics_process(delta: float) -> void:
		
	if typed_code.length() == 4:
		if typed_code == code:
			correct_code.emit()
			is_looking = false
		else:
			incorrect_code.emit()
			is_looking = false
		typed_code = ""
		
func generate_4_digit_string() -> String:
	var result = ""
	for i in range(4):
		# Generates a digit from 1 to 9
		result += str(randi_range(1, 9))
	return result
		
