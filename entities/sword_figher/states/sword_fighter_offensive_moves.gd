extends "res://entities/sword_figher/states/sword_fighter_state.gd"

# Initialize state here: Set animation, add impulse, etc.
#func _enter_state():
#	entity.set_animation(get_animation_name(), 0, 5.0)

# Inverse of enter_state.
#func _exit_state():
#	pass

#func _process_state(delta):
#	entity.apply_root_motion(delta)
#	entity.apply_drag(delta)
#	pass

#func _animation_blend_started(anim_name):
#	print(anim_name)
#	set_next_state("idle")
#	if anim_name == "off_h_r_heavy":

func _animation_finished(anim_name):
	set_next_state("offensive_stance")

func _flag_changed(flag, state):
	if flag == "is_evade_cancelable" and state:
		if entity.input_listener.is_key_pressed(InputManager.GUARD):
			set_next_state("off_block")
			return
		if entity.input_listener.is_key_pressed(InputManager.UP):
			set_next_state("walk")
		if entity.input_listener.is_key_pressed(InputManager.DOWN):
			set_next_state("walk")
		if entity.input_listener.is_key_pressed(InputManager.LEFT):
			set_next_state("walk")
		if entity.input_listener.is_key_pressed(InputManager.RIGHT):
			set_next_state("walk")
	pass

func _dealt_hit(collided_entity):
	entity.flags.track_target = true

func _received_hit(hit : Hit):
	if hit.grab:
#		set_next_state("receive_throw")
		pass
	else:
		set_next_state("hit_stun")

#func _received_input(key, state):
#	if entity.flags.is_stringable:
#		if state:
#			if key == InputManager.LIGHT:
#				set_next_state("off_hi_light")
#			elif key == InputManager.HEAVY:
#				set_next_state("off_hi_heavy")
#			if key == InputManager.GUARD:
#				if entity.input_listener.is_key_pressed(InputManager.UP):
#					set_next_state("off_kick")
