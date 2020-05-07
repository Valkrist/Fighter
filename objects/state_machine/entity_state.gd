extends State
class_name EntityState

var received_events

func _init():
	clear_received_events()

func clear_received_events():
	received_events = {
	"_received_input" : [],
	"_received_hit" : [],
	"_received_parry" : [],
	"_dealt_parry" : [],
	"_received_defense" : [],
	"_dealt_hit" : [],
	"_released_from_grapple" : [],
	"_animation_finished" : [],
	"_animation_blend_started" : [],
	"_flag_changed" : [],
	"_hitstop_ended" : [],
	"_touched_surface" : [],
	"_evaded_hit" : [],
	"_concurrent_fsm_state_changed" : [],
	"_received_ai_action" : [],
	}

func process_received_events():
	
	for arg_array in received_events["_received_input"]:
		callv("_received_input", arg_array)
		
	for arg in received_events["_released_from_grapple"]:
		call("_released_from_grapple", arg)
	
	for arg in received_events["_dealt_hit"]:
		call("_dealt_hit", arg)
		
	for arg in received_events["_dealt_parry"]:
		callv("_dealt_parry", arg)
		
	for arg_array in received_events["_received_ai_action"]:
		callv("_received_ai_action", arg_array)
		
	for arg_array in received_events["_flag_changed"]:
		callv("_flag_changed", arg_array)
		
	for arg in received_events["_hitstop_ended"]:
		call("_hitstop_ended")

	for arg in received_events["_concurrent_fsm_state_changed"]:
		call("_concurrent_fsm_state_changed", arg)
	
	for arg in received_events["_evaded_hit"]:
		call("_evaded_hit", arg)
	
	for arg in received_events["_received_parry"]:
		call("_received_parry", arg)
	
	for arg in received_events["_received_defense"]:
		call("_received_defense", arg)
		
	for arg in received_events["_animation_finished"]:
		call("_animation_finished", arg)
		
	for arg in received_events["_animation_blend_started"]:
		call("_animation_blend_started", arg)
		
	for arg in received_events["_touched_surface"]:
		call("_touched_surface", arg)
		
	for arg in received_events["_received_hit"]:
		call("_received_hit", arg)
	
	clear_received_events()

func set_next_state(state):
	next_state = state

func set_next_state_buffered(state, buffer_flag):
	if entity.flags.get(buffer_flag):
		set_next_state(state)
	else:
		next_state_buffer = state
		next_state_buffer_flag = buffer_flag

func get_animation_data():
	# Name, seek and blend length 
	return ["anim_name", 0.0, 1.0]

func _get_combo_list():
	pass

func get_sp_cost():
	return null

func _exit_state():
	entity.flags.reset_all_flags()
	pass

func _received_input(key, state):
	pass

func determine_hit_stop(p_hit):  #TODO: Find a less hacky way to dynamically set hitstop
	if p_hit.hit_stop > 0:
		if entity.crushed and p_hit.knockback.x > 200:
			entity.set_hitstop(3, p_hit.hit_stop * 1.5)
			if p_hit.hit_stop > 0.2:
				MainManager.camera.shake(1, 1)
		else:
			entity.set_hitstop(3, p_hit.hit_stop)
			if p_hit.hit_stop > 0.2:
				MainManager.camera.shake(1, 0.5)

func _received_hit(p_hit):
#	emit_signal("received_hit", p_hit)
#	entity.hit = p_hit
#	determine_hit_stop(p_hit)
	
#	entity.tiredness += p_hit.tiredness
#	if entity.tiredness > entity.tiredness_limit and not entity.exausted:
#		entity.exausted = true
	
#	if not entity.flags.is_defending:
#		entity.hp -= p_hit.damage
#		entity.emit_signal("hp_changed", entity.hp)
#		entity.flash_color(Color.red, 0.05)
#		entity.get_node("Sounds/Damage").play(0.0)
		
#		if entity.hp > 0:
#			if entity.hp * 100 / entity.max_hp < 25:
#				entity.material.set_shader_param("sub_palette_index", 6)
#				entity.flash_red = true
				
#		else:
#			entity.flash_red = false
#			entity.material.set_shader_param("sub_palette_index", 7)
#			$Sounds/Dead.play()

#		if entity.hp < 0:
#			entity.material.set_shader_param("sub_palette_index", 7)
	pass

func _received_parry(parrying_entity):
#	var parry_hit = Hit.new(Hit.INIT_TYPE.PARRY)
#	parry_hit.position = entity.position
#	parry_hit.direction = parrying_entity.facing_direction
#	entity._on_hurtbox_received_hit(parry_hit, entity.get_node("DirectionalObjects/Hurtbox"))
	pass

func _received_defense(defending_entity):
	pass

func _dealt_hit(collided_entity):
	pass

func _dealt_parry(parried_entity, parried_hit):
	pass

func _released_from_grapple(grappling_entity):
	pass

func _animation_finished(anim_name):
	pass

func _animation_blend_started(anim_name):
	pass
	
func _flag_changed(flag, state):
	pass

func _hitstop_ended():
	pass

func _touched_surface(surface):
	pass

func _evaded_hit(hit):
	pass

func _concurrent_fsm_state_changed(state):
	pass

func _received_ai_action(action, parameters):
	if action == "walk":
		set_next_state("walk")
		return
		
	if action == "move_to_target":
		set_next_state("walk")
		return
	
	if action == "wait":
		set_next_state("idle")
		
	if action == "attack":
		set_next_state("attack_" + str(parameters))
		return
	
	if action == "sidestep":
		set_next_state("sidestep")
		return
	
	if action == "defend":
		entity.face_lock_on_target()
		set_next_state("defense")
		return
	
	if action == "move_behind_target":
		entity.face_lock_on_target()
		set_next_state("walk")
	pass
