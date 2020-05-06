extends "res://entities/sword_figher/states/sword_fighter_defensive_moves.gd"

func get_animation_data():
	# Name, seek and blend length 
	return ["def_hi_light", 0.0, 8.0]

#func get_animation_name():
#	return "def_hi_light"

# Initialize state here: Set animation, add impulse, etc.
func _enter_state():
	if entity.input_listener.last_input_direction == InputManager.LEFT:
		entity.set_animation("def_step_l", 0, -1.0)
	if entity.input_listener.last_input_direction == InputManager.RIGHT:
		entity.set_animation("def_step_r", 0, -1.0)
	if entity.input_listener.last_input_direction == InputManager.UP:
		entity.set_animation("def_step_f", 0, -1.0)
	if entity.input_listener.last_input_direction == InputManager.DOWN:
		entity.set_animation("def_step_b", 0, -1.0)
#	._enter_state()

# Inverse of enter_state.
#func _exit_state():
#	pass

#func _animation_finished(anim_name):
#	set_next_state("defensive_stance")
#
func _process_state(delta):
	entity.apply_tracking(delta)
	entity.apply_root_motion(delta)
	entity.apply_drag(delta)
	
#
#	if entity.input_listener.is_key_pressed(InputManager.UP) and entity.input_listener.is_key_released(InputManager.DOWN):
#		set_next_state("walk")
#	if entity.input_listener.is_key_pressed(InputManager.DOWN) and entity.input_listener.is_key_released(InputManager.UP):
#		set_next_state("walk")
#	if entity.input_listener.is_key_pressed(InputManager.LEFT) and entity.input_listener.is_key_released(InputManager.RIGHT):
#		set_next_state("walk")
#	if entity.input_listener.is_key_pressed(InputManager.RIGHT) and entity.input_listener.is_key_released(InputManager.LEFT):
#		set_next_state("walk")
#	pass
#
#func _received_input(key, state):
#	if state:
#		if key == InputManager.LIGHT:
#			set_next_state("off_hi_heavy")
#		if key == InputManager.HEAVY:
#			set_next_state("off_kick")
#		if key == "evade":
#			entity.set_animation("stance_def_to_off", 0, 3.0)
			
