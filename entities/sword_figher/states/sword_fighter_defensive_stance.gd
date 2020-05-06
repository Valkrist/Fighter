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

func get_animation_data():
	# Name, seek and blend length 
	return ["defensive_stance", 0.0, 3.0]

# Initialize state here: Set animation, add impulse, etc.
func _enter_state():
	entity.current_stance = entity.Stances.DEFENSIVE
	
#	if entity.input_listener.is_key_pressed(InputManager.UP) and entity.input_listener.is_key_released(InputManager.DOWN):
#		set_next_state("walk")
#		return
#	elif entity.input_listener.is_key_pressed(InputManager.DOWN) and entity.input_listener.is_key_released(InputManager.UP):
#		set_next_state("walk")
#		return
#	elif entity.input_listener.is_key_pressed(InputManager.LEFT) and entity.input_listener.is_key_released(InputManager.RIGHT):
#		set_next_state("walk")
#		return
#	elif entity.input_listener.is_key_pressed(InputManager.RIGHT) and entity.input_listener.is_key_released(InputManager.LEFT):
#		set_next_state("walk")
#		return
	
	._enter_state()

# Inverse of enter_state.
#func _exit_state():
#	pass

#func _animation_finished(anim_name):
#	if anim_name == "stance_def_to_off":
#		set_next_state("offensive_stance")
#	._animation_finished(anim_name)

func _process_state(delta):
	entity.apply_root_motion(delta)
	._process_state(delta)

#func _received_input(key, state):
#	if entity.get_current_animation() != "stance_def_to_off":
#		._received_input(key, state)
#		if state:
#			if key == InputManager.LIGHT:
#				set_next_state("def_hi_light")
#			if key == InputManager.HEAVY:
#				set_next_state("off_kick")
#			if key == InputManager.STANCE:
#				entity.set_animation("stance_def_to_off", 0, 3.0)
			
