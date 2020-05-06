extends "res://entities/sword_figher/states/sword_fighter_offensive_moves.gd"

#func get_animation_data():
	# Name, seek and blend length 
#	return ["off_h_r_heavy", 0.0, 5.0]
var direction = 0
var released_up = false
var camera_pos = 2.0

## Initialize state here: Set animation, add impulse, etc.
func _enter_state():
#	camera_pos = entity.camera_point.translation.x
	entity.set_animation("off_run_startup", 0, 10.0)
#	._enter_state()
#
## Inverse of enter_state.
##func _exit_state():
##	pass
#
func _process_state(delta):
	if entity.flags.is_active:
		entity.set_velocity(Vector3(5.0 * direction, 0.0, -9.0))
#		entity.set_velocity(Vector3(0.0, 0.0, -8.0))
	else:
		entity.apply_drag(delta)
#		if entity.velocity.length_squared() < 0.05:
#			set_next_state("offensive_stance")
			
	entity.apply_tracking(delta)
#	entity.get_node("../InterpolatedCamera").speed = lerp(entity.get_node("../InterpolatedCamera").speed, 2, delta)
	
		
#	._process_state(delta)
#	entity.apply_root_motion(delta)
##	pass
#
##func _animation_blend_started(anim_name):
##	print(anim_name)
##	set_next_state("idle")
##	if anim_name == "off_h_r_heavy":
#
func _animation_finished(anim_name):
	if anim_name == "off_run_startup":
		if released_up:
			entity.set_animation("off_run_stop", 0, 10.0)
		else:
			entity.set_animation("run_loop", 0, -1.0)
#			entity.get_node("../InterpolatedCamera").speed = 1
			if entity.input_listener.is_key_pressed(InputManager.RIGHT):
				direction = 1
				entity.tween_camera_position(0.0)
				camera_pos = -2.0
#				entity.tween_camera_position(-2.0)
			elif entity.input_listener.is_key_pressed(InputManager.LEFT):
				direction = -1
				entity.tween_camera_position(0.0)
				camera_pos = 2.0
			else:
				camera_pos = 2.0
#				entity.tween_camera_position(2.0)
	#		entity.set_velocity(Vector3(0.0, 0.0, -20.0))
	elif anim_name == "off_run_stop":
		set_next_state("offensive_stance")
#	set_next_state("offensive_stance")
#	pass
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
#
func _received_input(key, state):
#	if entity.flags.is_stringable:
	if not state:
		if key == InputManager.UP:
			released_up = true
			if entity.get_current_animation() == "run_loop":
				if direction != 0:
					entity.tween_camera_position(camera_pos)
				entity.set_animation("off_run_stop", 0, 10.0)
#				set_next_state("off_hi_fierce")
	._received_input(key, state)
#			if key == InputManager.HEAVY:
#				set_next_state("off_kick")
