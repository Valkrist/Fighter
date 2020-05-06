extends "res://entities/sword_figher/states/sword_fighter_offensive_moves.gd"

func get_animation_data():
	# Name, seek and blend length 
	return ["off_hi_fierce", 0.0, 5.0]

## Initialize state here: Set animation, add impulse, etc.
#func _enter_state():
#	entity.set_animation("off_hi_fierce", 0, 5.0)
#	._enter_state()
#
## Inverse of enter_state.
##func _exit_state():
##	pass
#
#func _process_state(delta):
#	entity.apply_root_motion(delta)
##	pass
#
##func _animation_blend_started(anim_name):
##	print(anim_name)
##	set_next_state("idle")
##	if anim_name == "off_h_r_heavy":
#
#func _animation_finished(anim_name):
#	set_next_state("offensive_stance")
#
#func _flag_changed(flag, state):
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
##func _received_input(key, state):
##	pass
