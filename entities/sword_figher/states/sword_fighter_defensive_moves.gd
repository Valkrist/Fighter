extends "res://entities/sword_figher/states/sword_fighter_state.gd"

func get_possible_transitions():
	return [
		"def_step",
		"def_hi_light",
		"off_kick",
		"off_block",
		"stance_switch",
#		"walk",
		]

# Initialize state here: Set animation, add impulse, etc.
#func _enter_state():
#	entity.set_animation(get_animation_name(), 0, 3.0)

# Inverse of enter_state.
#func _exit_state():
#	pass

func _animation_finished(anim_name):
	set_next_state("defensive_stance")

func _process_state(delta):
	entity.apply_root_motion(delta)
	entity.apply_drag(delta)
#	pass

func _flag_changed(flag, state):
	if flag == "is_evade_cancelable" and state:
		if entity.input_listener.is_key_pressed(InputManager.GUARD):
			set_next_state("off_block")
			return
#		if entity.input_listener.is_key_pressed(InputManager.UP):
#			set_next_state("walk")
#		if entity.input_listener.is_key_pressed(InputManager.DOWN):
#			set_next_state("walk")
#		if entity.input_listener.is_key_pressed(InputManager.LEFT):
#			set_next_state("walk")
#		if entity.input_listener.is_key_pressed(InputManager.RIGHT):
#			set_next_state("walk")
	pass

#func _received_input(key, state):
#	if state:
#		if key == InputManager.LIGHT:
#			set_next_state("def_hi_light")
#		if key == InputManager.HEAVY:
#			set_next_state("off_kick")
#		if key == "evade":
#			entity.set_animation("stance_def_to_off", 0, 3.0)
			
