extends "res://entities/sword_figher/states/sword_fighter_state.gd"

func get_animation_data():
	# Name, seek and blend length 
	return ["offensive_stance", 0.0, 3.0]

# Initialize state here: Set animation, add impulse, etc.
func _enter_state():
	entity.current_stance = entity.Stances.OFFENSIVE
	
	if entity.input_listener.is_key_pressed(InputManager.GUARD):
		set_next_state("off_block")
		return
	if entity.input_listener.is_key_pressed(InputManager.UP) and entity.input_listener.is_key_released(InputManager.DOWN):
		set_next_state("walk")
		return
	elif entity.input_listener.is_key_pressed(InputManager.DOWN) and entity.input_listener.is_key_released(InputManager.UP):
		set_next_state("walk")
		return
	elif entity.input_listener.is_key_pressed(InputManager.LEFT) and entity.input_listener.is_key_released(InputManager.RIGHT):
		set_next_state("walk")
		return
	elif entity.input_listener.is_key_pressed(InputManager.RIGHT) and entity.input_listener.is_key_released(InputManager.LEFT):
		set_next_state("walk")
		return
	._enter_state()

# Inverse of enter_state.
#func _exit_state():
#	pass

#func _animation_finished(anim_name):
#	if anim_name == "stance_off_to_def":
#		set_next_state("defensive_stance")
#	._animation_finished(anim_name)

func _process_state(delta):
#	entity.apply_root_motion(delta)
	._process_state(delta)

#func _received_input(key, state):
#	print(entity.flags.is_stringable)
#	if entity.get_current_animation() != "stance_off_to_def":
#	._received_input(key, state)
		
#		if state:
#			if key == InputManager.LIGHT:
#				set_next_state("off_hi_light")
#			elif key == InputManager.HEAVY:
#				set_next_state("off_hi_heavy")
#			elif key == InputManager.STANCE:
#				entity.set_animation("stance_off_to_def", 0, 3.0)
#			elif key == InputManager.GUARD:
#				if entity.input_listener.is_key_pressed(InputManager.UP):
#					set_next_state("off_kick")
#				else:
#					set_next_state("off_block")
