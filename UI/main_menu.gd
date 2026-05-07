extends Control

var menu_images = [
	preload("res://Assets/Art/DeliveryMM-1.jpg"),
	preload("res://Assets/Art/DeliveryMM-2.jpg"),
	preload("res://Assets/Art/DeliveryMM-3.jpg")	
]

@onready var bg_image: TextureRect = $MarginContainer/BG_IMAGE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg_image.texture = menu_images.pick_random()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/delivery_num.tscn")


func _on_settings_pressed() -> void:
	$MarginContainer/ControlsSetting.show()
