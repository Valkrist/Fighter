tool
extends AnimationPlayer

export var add_animations = false setget set_add_animations

func set_add_animations(value):
	var target_player = get_node("../ModelContainer/sword_fighter/AnimationPlayer")
	
	for animation in target_player.get_animation_list():
		if not has_animation(animation):
			var new_animation = Animation.new()
#			new_animation.resource_name = animation
			new_animation.length = target_player.get_animation(animation).length
			add_animation(animation, new_animation)


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
