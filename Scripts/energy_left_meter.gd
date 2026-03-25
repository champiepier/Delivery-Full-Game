extends Control

@onready var meter_go_down_timer: Timer = $MeterGoDownTimer
@onready var power_left: ProgressBar = $MarginContainer/VBoxContainer/PowerLeft


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	power_left.max_value = 65
	power_left.value = 65


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reset_energy_level(max_time):
	power_left.max_value = max_time
	power_left.value = max_time


func _on_meter_go_down_timer_timeout() -> void:
	power_left.value -= 1
