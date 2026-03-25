extends Control

@onready var delivery_num_label: RichTextLabel = $MarginContainer/MarginContainer/DeliveryNumLabel
@onready var anims: AnimationPlayer = $anims

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	delivery_num_label.text = "Delivery: " + str(Global.delivery_num)


func _on_stay_on_screen_time_timeout() -> void:
	anims.play("fade_out")


func _on_anims_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://Misc/main.tscn")
