extends StaticBody3D

@onready var rot_timer: Timer = $RotTimer
@onready var type_label: Label = $Sprite3D/SubViewport/TypeLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	type_label.text = "Food"
	set_random_wait_time()
	
func set_random_wait_time():
	var random_wait_time: float = roundf((randf() * 50) * 4)
	random_wait_time = clamp(random_wait_time, 5, 30)


func _on_rot_timer_timeout() -> void:
	type_label.text = "Rotten Food"
	
func reset_food():
	type_label.text = "Food"
	set_random_wait_time()
