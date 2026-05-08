extends Control

@onready var oxygen_meter: ProgressBar = $MarginContainer/OxygenMeter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("depelete_oxygen", reduce_oxygen)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if oxygen_meter.value <= 0:
		Global.oxygen_gone.emit()

func reduce_oxygen():
	oxygen_meter.value -= oxygen_meter.step
	
func increase_oxygen():
	if oxygen_meter.value < oxygen_meter.max_value * 0.5:
		oxygen_meter.value += oxygen_meter.step
