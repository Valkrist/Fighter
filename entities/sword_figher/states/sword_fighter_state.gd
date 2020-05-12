###########################################################################
# Base class for player states
###########################################################################

extends EntityState

#var frame_count = 0 # Maybe use MainManager.time instead of keeping it's own timer.
var resource_cost_processed = false

#func _get_combo_list():
#	return {
#		"sword" : "sword_1",
#		"up_sword" : "",
#		"down_sword" : "low_1",
#		}

func get_possible_transitions():
	return [
		"off_run",
		"walk",
#		"def_step",
		"offensive_stance",
		"defensive_stance",
		"off_throw_f",
		"off_hi_light",
		"off_hi_heavy",
		"off_hi_fierce",
		"def_hi_light",
		"off_kick",
		"off_block",
		"stance_switch",
		]

func _enter_state():
	var anim_data = get_animation_data()
	entity.set_animation(anim_data[0], anim_data[1], anim_data[2])
#	entity.set_animation(name)
#	process_resource_cost()
#    ._enter_state(entity)

func _process_state(delta):
	if entity.flags.track_target:
		entity.apply_tracking(delta)
	entity.apply_root_motion(delta)
	entity.apply_drag(delta)
#	if entity.hitstop:
#		return
#
#	._process_state(delta)

#func _exit_state():
#	entity.get_node("Sprite2").visible = false
#	entity.get_node("Sprite").visible = true
#	entity.drag.x = entity.default_drag.x
#	entity.set_hurtboxes_active(true)
#	._exit_state()

func _received_hit(hit : Hit):
	if hit.grab:
		set_next_state("receive_throw")
	else:
		set_next_state("hit_stun")
#	if entity.flags.is_defending:
#		return
#
#	._received_hit(hit)
##	entity.emit_signal("damaged", entity.hp)
#	entity.check_death()
#
#	entity.tension -= 200
#
#	if hit.damage == 0:
#		set_next_state("stun")
#	else:
#		set_next_state("damage")
#		MainManager.current_level.camera.shake(1, 1)
#
#func _evaded_hit(hit):
#	entity.tension += 100
#	entity.get_node("DirectionalObjects/EvadeGlow").frame = 0
#	entity.flash_color(Color.deepskyblue, 0.05)
#
#	entity.flags.buffer_input = true
#	entity.flags.is_stringable = true
#	entity.flags.is_command_cancelable = true
#	entity.flags.is_evade_cancelable = true
#
#	entity.get_node("AfterimageSpawner").target_sprite = "../Sprite"
#	entity.get_node("AfterimageSpawner").afterimage_color = Color.royalblue
#	entity.get_node("AfterimageSpawner").enabled = true

func _flag_changed(flag, state):
	if next_state_buffer != null and flag == next_state_buffer_flag:
		set_next_state(next_state_buffer)

#func process_resource_cost():
#	if state_list.RESOURCE_COSTS.has(name):
#		entity.sp -= state_list.RESOURCE_COSTS[name][0]
#		entity.bullets -= state_list.RESOURCE_COSTS[name][1]
	
#	if not resource_cost_processed:
#		if frame_count > entity.input_listener.window_for_multiple_input:
#			if state_list.RESOURCE_COSTS.has(name):
#				entity.sp -= state_list.RESOURCE_COSTS[name][0]
#				entity.bullets -= state_list.RESOURCE_COSTS[name][1]
#			resource_cost_processed = true
#		else:
#			frame_count += 1

func set_next_state(state):
#	if next_state == null:
	if state_list.RESOURCE_COSTS.has(state):
		if entity.sp >= state_list.RESOURCE_COSTS[state][0]:
			if entity.bullets >= state_list.RESOURCE_COSTS[state][1]:
				if entity.tension >= state_list.RESOURCE_COSTS[state][2]:
#					entity.sp -= state_list.RESOURCE_COSTS[state][0]
#					entity.bullets -= state_list.RESOURCE_COSTS[state][1]
					.set_next_state(state)
		else:
			return
	else:
		.set_next_state(state)

func set_next_state_buffered(state, buffer_flag):
#	if next_state_buffer == null:
	if entity.flags.get(buffer_flag) and !entity.hitstop:
		set_next_state(state)
	else:
		next_state_buffer = state
		next_state_buffer_flag = buffer_flag

func _received_input(key, state):
	var test = test_transition_by_input(key, state, get_possible_transitions())
	
	if test.flag != null:
		if entity.flags.get(test.flag):
			set_next_state(test.state)
	else:
		set_next_state(test.state)

func test_transition_by_input(key : int, key_state : int, valid_transitions : Array):
	# Pass valid transitions into the array in order of lowest to highest priority.
	
	if key_state == InputManager.PRESSED:
		match key as int:
			InputManager.LIGHT:
				for t in valid_transitions:
					match t as String :
						"off_hi_light":
							return {"state" : t, "flag" : "is_stringable"}
						"def_hi_light":
							return {"state" : t, "flag" : "is_stringable"}
							
			InputManager.HEAVY:
				for t in valid_transitions:
					match t as String :
						"off_hi_heavy":
							return {"state" : t, "flag" : "is_stringable"}
							
			InputManager.STANCE:
				for t in valid_transitions:
					match t as String :
						"stance_switch":
							return {"state" : t, "flag" : "is_stringable"}
							
			InputManager.GUARD:
				for t in valid_transitions:
					match t as String:
						"off_kick":
							if entity.input_listener.is_key_pressed(InputManager.UP):
								return {"state" : t, "flag" : "is_stringable"}
						"off_block":
							return {"state" : t, "flag" : "is_evade_cancelable"}
							
			InputManager.RIGHT_RIGHT, InputManager.LEFT_LEFT:
				for t in valid_transitions:
					match t as String:
						"def_step":
							return {"state" : t, "flag" : "is_evade_cancelable"}
						"walk":
							return {"state" : "walk", "flag" : "is_stringable"}
							
			InputManager.UP_UP:
				for t in valid_transitions:
					match t as String:
						"off_run":
							return {"state" : t, "flag" : "is_evade_cancelable"}
						"def_step":
							return {"state" : t, "flag" : "is_evade_cancelable"}
						"walk":
							return {"state" : "walk", "flag" : "is_stringable"}
							
			InputManager.DOWN_DOWN:
				for t in valid_transitions:
					match t as String:
						"def_step":
							return {"state" : t, "flag" : "is_evade_cancelable"}
						"walk":
							return {"state" : "walk", "flag" : "is_stringable"}
							
			InputManager.LEFT:
				if valid_transitions.has("walk"):
					if entity.input_listener.is_key_released(InputManager.RIGHT):
						return {"state" : "walk", "flag" : "is_stringable"}
			InputManager.RIGHT:
				if valid_transitions.has("walk"):
					if entity.input_listener.is_key_released(InputManager.LEFT):
						return {"state" : "walk", "flag" : "is_stringable"}
			InputManager.UP:
				if valid_transitions.has("walk"):
					if entity.input_listener.is_key_released(InputManager.DOWN):
						return {"state" : "walk", "flag" : "is_stringable"}
			InputManager.DOWN:
				if valid_transitions.has("walk"):
					if entity.input_listener.is_key_released(InputManager.UP):
						return {"state" : "walk", "flag" : "is_stringable"}
						
			InputManager.THROW:
				if valid_transitions.has("off_throw_f"):
					return {"state" : "off_throw_f", "flag" : "is_stringable"}
				
#			"cross":
#				for t in valid_transitions:
#					match t as String :
#						"cross_drive":
#							return {"state" : t, "flag" : null}
#
#			"jump":
#				for t in valid_transitions:
#					match t as String:
#						"jump":
#							if entity.on_ground or entity.has_air_jump:
#								return {"state" : t, "flag" : "is_evade_cancelable"}
#						"long_jump":
#							return {"state" : t, "flag" : "is_evade_cancelable"}
#						"dive_kick":
#							if entity.input_listener.is_key_pressed(InputManager.DOWN):
#								return {"state" : t, "flag" : "is_command_cancelable"}
#			"reload":
#				if valid_transitions.has("reload"):
#					return {"state" : "reload", "flag" : "is_command_cancelable"}
#			"fire":
##				if valid_transitions.has("aim"):
##						return {"state" : "aim", "flag" : "is_command_cancelable"}
#				if valid_transitions.has("geyser"):
#					if entity.input_listener.is_key_pressed(InputManager.DOWN):
#						return {"state" : "geyser", "flag" : "is_command_cancelable"}
#			"right_tetsuzanko", "left_tetsuzanko":
#				if valid_transitions.has("tetsuzanko"):
#					return {"state" : "tetsuzanko", "flag" : "is_command_cancelable"}
#			"sword+kick":
#				if valid_transitions.has("spin_attack"):
#					return {"state" : "spin_attack", "flag" : null}
#			"right_qcf_kick", "left_qcf_kick":
#				if valid_transitions.has("wave"):
#					if not entity.input_listener.is_key_pressed("fire"):
#						return {"state" : "wave", "flag" : "is_command_cancelable"}
#			"sword_held":
#				if valid_transitions.has("blur"):
#					return {"state" : "blur", "flag" : "is_command_cancelable"}
#			"right_qcf_weapon", "left_qcf_weapon":
#				if valid_transitions.has("blur"):
#					return {"state" : "blur", "flag" : "is_command_cancelable"}
#			"special+jump":
#				if valid_transitions.has("eruption"):
#					return {"state" : "eruption", "flag" : null}
#			"special+sword":
#				if valid_transitions.has("bomb_grab"):
#					return {"state" : "bomb_grab", "flag" : null}
#			"special+jump":
#				if valid_transitions.has("eruption"):
#					return {"state" : "eruption", "flag" : null}
#			"special+sword":
#				if valid_transitions.has("bomb_grab"):
#					return {"state" : "bomb_grab", "flag" : null}
#			"right_qcf_fire", "left_qcf_fire":
#				if valid_transitions.has("power_slash"):
#					return {"state" : "power_slash", "flag" : "is_command_cancelable"}
#			"right_dp", "left_dp":
#				if valid_transitions.has("weapon_dp"):
#					if entity.on_ground or entity.has_air_jump:
#						return {"state" : "weapon_dp", "flag" : "is_evade_cancelable"}

	return {"state" : null , "flag" : null}
