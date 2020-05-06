extends Area

export var active = false setget set_active

onready var entity = owner

func set_active(value):
	active = value
#	if value:
#		modulate = ColorN("red", 0.25)
#	else:
#		modulate = ColorN("blue", 0.25)

#	set_visible(value)
	pass

#func _ready():
#	visible = DebugManager.visible_collisions
#	DebugManager.connect("changed_visible_collisions", self, "set_visible_collisions")

#func get_size():
#	return Vector2(scale.x * 2, scale.y * 2)

#func set_visible_collisions():
#		yield(get_tree(), "physics_frame")
#		visible = DebugManager.visible_collisions
