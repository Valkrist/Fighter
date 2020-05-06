extends Reference

class_name State

var name = "null" setget set_name
var next_state = null
var next_state_buffer = null
var next_state_buffer_flag = null
var entity : Entity
var state_list

func get_name():
	return name

func set_name(value):
	name = value
#	print(value)

func _get_next_state():
	return next_state

func set_next_state(state):
	next_state = state

func _get_next_state_buffer():
	return next_state_buffer

func process_received_events():
	pass

# Initialize state here: Set animation, add impulse, etc.
func _enter_state():
	pass

# Inverse of enter_state.
func _exit_state():
	pass

func _process_state(delta):
	pass
