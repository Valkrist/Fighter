extends "res://entities/sword_figher/states/sword_fighter_state.gd"

# Initialize state here: Set animation, add impulse, etc.
func _enter_state():
	if entity.current_stance == entity.Stances.OFFENSIVE:
		entity.set_animation("stance_off_to_def", 0, 3.0)
	
	elif entity.current_stance == entity.Stances.DEFENSIVE:
		entity.set_animation("stance_def_to_off", 0, 3.0)

# Inverse of enter_state.
#func _exit_state():
#	pass

#func _process_state(delta):
#	entity.apply_root_motion(delta)
#	pass

func _animation_finished(anim_name):
	if anim_name == "stance_off_to_def":
		set_next_state("defensive_stance")
		
	elif anim_name == "stance_def_to_off":
		set_next_state("offensive_stance")

func _received_input(key, state):
	pass
