extends Control

@onready var path: Line2D = $MarginContainer/Path
@onready var cur: Sprite2D = $MarginContainer/Cur
@onready var des: Sprite2D = $MarginContainer/Des


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path.set_point_position(0, Vector2(553, 85))
	path.set_point_position(1, Vector2(243, 420))
	des.position = path.get_point_position(0)
	cur.position = path.get_point_position(1)
	
	start_movement()

func start_movement():
	path.set_point_position(1, cur.position)
	
	var duration = $"../../../../../Manager".des_timer.wait_time
	var tween = get_tree().create_tween()
	
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(cur, "position", des.position, duration)

# Called every frame. 'delta' is the elapsed time since the previous frame.	
func _physics_process(delta: float) -> void:
	path.set_point_position(1, cur.position)
