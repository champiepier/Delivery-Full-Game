extends Control

@onready var anims: AnimationPlayer = $AnimationPlayer
@onready var progrss_bar_tint: AnimationPlayer = $ProgrssBarTint
@onready var cross_hair: TextureRect = $MarginContainer/MarginContainer/CrossHair

var is_colliding: bool = false

var can_interact: bool = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("interact") and can_interact:
		anims.play("Interact")
		progrss_bar_tint.play("InteractTint")
		
	if Input.is_action_just_released("interact") and anims.is_playing():
		anims.pause()
		progrss_bar_tint.stop()
		$MarginContainer/InteractProgressBar.tint_progress = Color.RED
		await get_tree().create_timer(0.1).timeout
		anims.play_backwards("Interact")
		
	check_if_colliding()

func _on_interact_cooldown_timeout() -> void:
	can_interact = true

func _on_progrss_bar_tint_animation_finished(anim_name: StringName) -> void:
	if anim_name == "InteractTint":
		Global.emit_signal("interact")
		$InteractCooldown.start()
		can_interact = false
		
func check_if_colliding():
	if is_colliding:
		cross_hair.modulate = Color.AQUAMARINE
	else:
		cross_hair.modulate = Color.WHITE
	
