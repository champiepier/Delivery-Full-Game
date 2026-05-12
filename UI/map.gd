extends Control

@onready var path: Line2D = $MarginContainer/Path
@onready var cur: Sprite2D = $MarginContainer/Cur
@onready var des: Sprite2D = $MarginContainer/Des

var map_tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path.set_point_position(0, Vector2(553, 85))
	path.set_point_position(1, Vector2(243, 420))
	des.position = path.get_point_position(0)
	cur.position = path.get_point_position(1)
	Global.generator_off.connect(turn_gen_off)
	Global.generator_on.connect(turn_gen_on)
	
	start_movement()

func start_movement():
	path.set_point_position(1, cur.position)
	
	var duration = %DesTimer.wait_time
	map_tween = get_tree().create_tween()
	
	map_tween.set_trans(Tween.TRANS_LINEAR)
	map_tween.tween_property(cur, "position", des.position, duration)
	
func turn_gen_off():
	map_tween.pause()
	%DesTimer.paused = true

func turn_gen_on():
	map_tween.play()
	%DesTimer.paused = false

func _physics_process(delta: float) -> void:
	path.set_point_position(1, cur.position)
