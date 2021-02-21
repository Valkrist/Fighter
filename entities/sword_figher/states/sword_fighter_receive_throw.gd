extends "res://entities/sword_figher/states/sword_fighter_offensive_moves.gd"

func get_animation_data():
	# Name, seek and blend length 
	return ["receive_off_throw_f", 0.0, 10.0]

# Initialize state here: Set animation, add impulse, etc.
func _enter_state():
	entity.velocity = Vector3.ZERO
	entity.hp -= entity.received_hit.damage
	._enter_state()
	
	yield(entity.get_tree(), "physics_frame")
	yield(entity.get_tree(), "physics_frame")
	entity.translation = entity.receive_throw_pos
	entity.model_container.rotation.y = entity.receive_throw_rot
	entity.add_collision_exception_with(entity.throwing_entity)

# Inverse of enter_state.
func _exit_state():
	entity.remove_collision_exception_with(entity.throwing_entity)
#	pass

func _process_state(delta):
#	entity.apply_drag(delta)
#	entity.follow_throw_position(delta)
	entity.apply_root_motion(delta)
	pass
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
