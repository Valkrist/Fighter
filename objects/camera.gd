extends InterpolatedCamera

export var default_speed = 10
onready var tracked_entity = get_node(target).owner

# Called when the node enters the scene tree for the first time.
func _ready():
	tracked_entity.has_camera = true
	reset_speed()

func _on_sword_fighter_requested_camera(entity):
	$AnimationPlayer.play("switch_player")
	$AnimationPlayer.advance(0)
#	get_tree().paused = true
	tracked_entity.has_camera = false
	tracked_entity = entity
	tracked_entity.has_camera = true
	target = entity.get_node("CameraPointPivot/Position3D").get_path()
#	speed = 3
#	$Timer.start()

func _on_Timer_timeout():
	speed = default_speed
	get_tree().paused = false

func set_pause(value):
	get_tree().paused = value

func reset_speed():
	speed = default_speed
