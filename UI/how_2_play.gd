extends Control

@onready var anims: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		play_anim("hide")
		Global.is_looking = false
	
func play_anim(anim_name):
	anims.play(anim_name)
