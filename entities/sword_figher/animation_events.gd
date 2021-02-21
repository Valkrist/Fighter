tool
extends AnimationPlayer

export var add_animations = false setget set_add_animations
export var make_trigger = false setget set_make_trigger

func set_add_animations(value):
	var target_player = get_node("../ModelContainer/sword_fighter/AnimationPlayer")
	
	for animation in target_player.get_animation_list():
		if not has_animation(animation):
			var new_animation = Animation.new()
#			new_animation.resource_name = animation
			new_animation.length = target_player.get_animation(animation).length
			add_animation(animation, new_animation)


func set_make_trigger(value):
	if value:
		var track_names = [
		"AnimationFlags:idling",
		"AnimationFlags:hyper_armor",
		"AnimationFlags:is_defending",
		"AnimationFlags:is_cancelable",
		"AnimationFlags:is_evade_cancelable",
		"AnimationFlags:is_command_cancelable",
		"AnimationFlags:reload_cancelable",
		"AnimationFlags:is_active",
		"AnimationFlags:is_stringable",
		"AnimationFlags:is_alt_stringable",
		"AnimationFlags:buffer_input",
		"AnimationFlags:gravity",
		]
		
		for animation in get_animation_list():
			var anim = get_animation(animation)
			for track in track_names:
				var t = anim.find_track(track)
				if t != -1:
					anim.value_track_set_update_mode(t, Animation.UPDATE_TRIGGER)
#					print(anim.value_track_get_update_mode(t))
	#	get_animation("def_hi_light").find_track("AnimationFlags:is_stringable")
	
	pass
	

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
