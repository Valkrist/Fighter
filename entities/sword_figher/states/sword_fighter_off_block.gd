extends "res://entities/sword_figher/states/sword_fighter_offensive_moves.gd"

# Initialize state here: Set animation, add impulse, etc.
func _enter_state():
	entity.flags.track_target = false
	
	if entity.input_listener.is_key_pressed(InputManager.DOWN):
		entity.set_animation("off_block_low", 0, 15.0)
	else:
		entity.set_animation("off_block_hi", 0, 15.0)
#	._enter_state()

# Inverse of enter_state.
#func _exit_state():
#	pass

#func _process_state(delta):
#	entity.apply_root_motion(delta)
#
##func _animation_blend_started(anim_name):
##	print(anim_name)
##	set_next_state("idle")
##	if anim_name == "off_h_r_heavy":
#
func _animation_finished(anim_name):
	pass
#	set_next_state("offensive_stance")
#
#func _flag_changed(flag, state):
##	if flag == "is_cancelable" and state:
##		set_next_state("idle")
##		return
#	if flag == "is_evade_cancelable" and state:
#		if entity.input_listener.is_key_pressed(InputManager.UP):
#			set_next_state("walk")
#		if entity.input_listener.is_key_pressed(InputManager.DOWN):
#			set_next_state("walk")
#		if entity.input_listener.is_key_pressed(InputManager.LEFT):
#			set_next_state("walk")
#		if entity.input_listener.is_key_pressed(InputManager.RIGHT):
#			set_next_state("walk")
#	pass
#
func _received_input(key, state):
	if not state:
		if key == InputManager.GUARD:
			if entity.input_listener.is_key_pressed(InputManager.UP):
				set_next_state("walk")
			elif entity.input_listener.is_key_pressed(InputManager.DOWN):
				set_next_state("walk")
			elif entity.input_listener.is_key_pressed(InputManager.LEFT):
				set_next_state("walk")
			elif entity.input_listener.is_key_pressed(InputManager.RIGHT):
				set_next_state("walk")
			else:
				set_next_state("offensive_stance")
				return
		if key == InputManager.DOWN:
			entity.set_animation("off_block_hi", 0, 10.0)
	else:
		if key == InputManager.DOWN:
			entity.set_animation("off_block_low", 0, 10.0)
##	pass
