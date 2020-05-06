extends State

var received_events

func _init():
	clear_received_events()

func clear_received_events():
	received_events = {
	"_coordinator_event" : [],
	"_reached_target_position" : [],
	"_target_in_range" : [],
	"_timer_timeout" : [],
	"_base_fsm_state_changed" : [],
	"_received_hit" : [],
	}

func process_received_events():
	for arg in received_events["_coordinator_event"]:
		call("_coordinator_event", arg)
		
	for arg in received_events["_reached_target_position"]:
		call("_reached_target_position", arg)
		
	for arg_array in received_events["_target_in_range"]:
		callv("_target_in_range", arg_array)
		
	for arg in received_events["_timer_timeout"]:
		call("_timer_timeout", arg)
		
	for arg in received_events["_base_fsm_state_changed"]:
		call("_base_fsm_state_changed", arg)
		
	for arg in received_events["_received_hit"]:
		call("_received_hit", arg)
	
	clear_received_events()

func set_name(value):
	name = value
#	prints(entity.name, value)

func _exit_state():
	entity.ai.stop_all_timers()

func _coordinator_event(event):
	pass

func _reached_target_position(position):
	pass

func _base_fsm_state_changed(new_state):
	pass

func _target_in_range(target, area):
	pass
	
func _timer_timeout(name):
	pass

func _received_hit(hit):
	pass

func _overlapping_obstacle(area):
	pass

func _finished_action(action):
	pass
