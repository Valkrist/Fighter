extends "res://entities/sword_figher/states/sword_fighter_offensive_moves.gd"

func get_animation_data():
	# Name, seek and blend length 
	return ["off_block_break", 0.0, 20.0]

# Initialize state here: Set animation, add impulse, etc.
func _enter_state():
	entity.hp -= entity.received_hit.damage
#	entity.velocity = Vector3.ZERO
#	var knockback_vector = entity.received_hit.knockback.rotated(-entity.received_hit.direction.y)
#	entity.add_impulse(Vector3(knockback_vector.x, 0, knockback_vector.y))
#	entity.ground_drag = 30
#	entity.set_animation("off_kick", 0, 6.0)
	._enter_state()

# Inverse of enter_state.
#func _exit_state():
#	entity.ground_drag = entity.default_ground_drag
#	pass

func _process_state(delta):
	entity.apply_drag(delta)
	pass
#	entity.apply_root_motion(delta)
#
##func _animation_blend_started(anim_name):
##	print(anim_name)
##	set_next_state("idle")
##	if anim_name == "off_h_r_heavy":
#
func _animation_finished(anim_name):
	if entity.current_stance == entity.Stances.OFFENSIVE:
		set_next_state("offensive_stance")
	elif entity.current_stance == entity.Stances.DEFENSIVE:
		set_next_state("defensive_stance")
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
##func _received_input(key, state):
##	pass
