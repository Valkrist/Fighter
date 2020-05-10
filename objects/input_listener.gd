extends Node

export var enabled = false
export(PoolIntArray) var listen_to_pads

export var reverse_left_right = false
export var reverse_up_down = false

export var remember_last_input_direction = false
var last_input_direction = 0

var last_multiple_input = null
var last_multiple_input_combination = null

export var key_hold_window = 60
var held_keys = {
	InputManager.LIGHT : 0,
}

export var input_buffer_size = 5
var input_buffer = [[0,0],[0,0],[0,0],[0,0],[0,0]]

export var window_for_multiple_input = 3
var multiple_inputs = {
	"jumpspecial" : "special+jump",
	"specialjump" : "special+jump",
	"specialfire" : "special+fire",
	"firespecial" : "special+fire",
	"specialsword" : "special+sword",
	"swordspecial" : "special+sword",
#	"swordkick" : "sword+kick",
#	"swordkick" : InputManager.STANCE,
#	"kicksword" : InputManager.STANCE,
	"swordjump" : InputManager.STANCE,
	"jumpsword" : InputManager.STANCE,
	}

export var window_for_input_chain = 15
var input_chains ={
	InputManager.RIGHT_RIGHT : [InputManager.RIGHT, InputManager.RIGHT],
	InputManager.LEFT_LEFT : [InputManager.LEFT, InputManager.LEFT],
	InputManager.UP_UP : [InputManager.UP, InputManager.UP],
	InputManager.DOWN_DOWN : [InputManager.DOWN, InputManager.DOWN],
#	"right_dp" : [InputManager.RIGHT, InputManager.DOWN, InputManager.LIGHT],
#	"left_dp" : [InputManager.LEFT, InputManager.DOWN, InputManager.LIGHT],
#	"right_qcf_weapon" : [InputManager.DOWN, InputManager.RIGHT, InputManager.LIGHT],
#	"left_qcf_weapon" : [InputManager.DOWN, InputManager.LEFT, InputManager.LIGHT],
#	"right_qcf_fire" : [InputManager.DOWN, InputManager.RIGHT, "fire"],
#	"left_qcf_fire" : [InputManager.DOWN, InputManager.LEFT, "fire"],
#	"right_qcf_kick" : [InputManager.DOWN, InputManager.RIGHT, InputManager.HEAVY],
#	"left_qcf_kick" : [InputManager.DOWN, InputManager.LEFT, InputManager.HEAVY],
#	"upup" : [InputManager.UP, InputManager.UP],
#	"right_bomb_evade" : [InputManager.LEFT, InputManager.RIGHT, "special"],
#	"left_bomb_evade" : [InputManager.RIGHT, InputManager.LEFT, "special"],
#	"right_gap_closer" : [InputManager.RIGHT_RIGHT, InputManager.LIGHT],
#	"left_gap_closer" : [InputManager.LEFT_LEFT, InputManager.LIGHT],
	}

export var simulate_input = false

signal received_input(key, state)

func _ready():
	InputManager.connect("key_changed", self, "_received_input")
	get_node("../InputSimulator").connect("simulated_input", self, "_received_input")
#	InputManager.connect("multiple_input_pressed", self, "_received_multiple_input")
	set_physics_process(false)

func _physics_process(delta):
	for key in held_keys:
		held_keys[key] += 1

func _received_input (pad, key, state):
	if enabled and not get_tree().paused:
		for n in listen_to_pads:
			if n == pad:
				# Press a direction on d-pad, wasd, etc.
				var dir = InputManager.get_direction(key)
				if dir != null:
					
					dir = get_reverse(dir)
					
					emit_signal("received_input", InputManager.DIRECTIONS_TO_KEYS[dir], state)
					
					if state == InputManager.PRESSED:
						add_to_input_buffer(InputManager.DIRECTIONS_TO_KEYS[dir])
						check_input_chains(InputManager.DIRECTIONS_TO_KEYS[dir])
					
						if remember_last_input_direction:
							last_input_direction = InputManager.DIRECTIONS_TO_KEYS[dir]
								
				else:
					emit_signal("received_input", key, state)
					
					if state == InputManager.PRESSED:
						add_to_input_buffer(key)
						check_input_chains(key)
				
#				if state == InputManager.RELEASED:
#					if held_keys.has(key):
#						if held_keys[key] > key_hold_window:
#							emit_signal("received_input", key + "_held", InputManager.PRESSED)
#						held_keys[key] = 0
#						set_physics_process(false)
						
#					if last_multiple_input != null:
#						if last_multiple_input_combination.has(key):
#							emit_signal("received_input", last_multiple_input, InputManager.RELEASED)
#							last_multiple_input = null
#							last_multiple_input_combination = null

func _received_multiple_input(pad, key, key_combination):
	if enabled and not get_tree().paused:
		for n in listen_to_pads:
			if n == pad:
				emit_signal("received_input", key, InputManager.PRESSED)
				last_multiple_input = key
				last_multiple_input_combination = key_combination

func add_to_input_buffer(key):
	if key == InputManager.START:
		return
	
	input_buffer.push_front([key, MainManager.time])
	if input_buffer.size() > input_buffer_size: 
		input_buffer.pop_back()
		
#	check_multiple_input(key)

func check_multiple_input(key):
	if input_buffer[0][1] - input_buffer[1][1] <= window_for_multiple_input:
		var key_string = str(input_buffer[0][0] + input_buffer[1][0])
		if multiple_inputs.has(key_string):
			emit_signal("received_input", multiple_inputs[key_string], InputManager.PRESSED)
			last_multiple_input = multiple_inputs[key_string]
			last_multiple_input_combination = [input_buffer[1][0], input_buffer[0][0]]

func check_input_chains(key):
	if key == InputManager.STANCE or key == InputManager.START:
		return
	
	for c in input_chains.keys():
		
		# check if the current input matches the last key in any of the chains
		if input_chains[c][input_chains[c].size() - 1] == key:
			
			# if it does start checking from the penultimate value in array
			var c_index = input_chains[c].size() - 2
			
			# index for input buffer
			var b_index = 1
			
			# Iterate through keys in the chain in reverse order, and check if they match
			# the inputs stored in the buffer in forward order.
			while c_index > - 1:
			
				# if the input doesn't match, stop checking this chain
				if input_chains[c][c_index] != input_buffer[b_index][0]:
					break
				# if the time interval between this input and the previous is too big stop checking this chain
				if input_buffer[b_index - 1][1] - input_buffer[b_index][1] > window_for_input_chain:
					break
				# if input and time are ok, advance in the chain and buffer.
				c_index -= 1
				b_index += 1
			
			if c_index == -1:
				# The beginning of the chain is reached, a chain has been completed.
				# Add input_chain to the buffer so it cannot be used as first input for another chain.
				add_to_input_buffer(c)
				emit_signal("received_input", c, InputManager.PRESSED)

func get_reverse(dir):
	if reverse_left_right:
		dir.x = -dir.x
	if reverse_up_down:
		dir.y = -dir.y
	return dir

func is_key_pressed(key):
	if enabled:
		for n in listen_to_pads:
			if InputManager.get_direction(key) != null:
				return InputManager.pressed(InputManager.DIRECTIONS_TO_KEYS[get_reverse(InputManager.KEY_TO_DIRECTIONS[key])], n)
			else:
				return InputManager.pressed(key, n)
	else:
		return false

func is_key_released(key):
	if enabled:
		for n in listen_to_pads:
			if InputManager.get_direction(key) != null:
				return InputManager.released(InputManager.DIRECTIONS_TO_KEYS[get_reverse(InputManager.KEY_TO_DIRECTIONS[key])], n)
			else:
				return InputManager.released(key, n)
	else:
		return false

func get_analog_stick(analog_index):
	if enabled:
		if listen_to_pads[0] == 0:
			return InputManager.pad_0_stick
		if listen_to_pads[0] == 1:
			return InputManager.pad_1_stick

#func get_buffered_input(pad, key, time):
#	# Returns true as soon as it finds a correct input in the buffer
#	var i = buffer[pad].size() - 1
#	while i >= 0:
#		if buffer[pad][i][0] == key and buffer[pad][i][1] > time:
#			return true
#		else:
#			i -= 1

#func first_in_buffer(input, pad):
#	# no regards to WHEN the input was added
#	if buffer[pad][0][0] == input:
#			return true
