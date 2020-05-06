extends InterpolatedCamera

#export(NodePath) var look_at_target
#onready var node_to_look_at = get_node(look_at_target)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#var t = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
##	look_at(node_to_look_at.global_transform.origin, Vector3.UP)
#	if rotation.angle_to(node_to_look_at.global_transform.origin) > 10:
##		rotate(Vector3.UP, rotation.angle_to(node_to_look_at.global_transform.origin))
#		t += delta * 0.1
#		var rot = lerp(rotation.y, translation.direction_to(node_to_look_at.global_transform.origin).y, t)
#		rotation = Vector3(0, rot + 1, 0)
#	else:
#		t = 0
#	pass
