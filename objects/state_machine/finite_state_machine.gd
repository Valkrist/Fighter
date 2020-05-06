extends Node

export(GDScript) var state_list_script

onready var entity = owner

var StateList
var CurrentState
var next_state
var forced_next_state  = null

var ready_to_process = false
var process_events = false

signal state_changed(new_state)

### Setup ###

func setup():
	StateList = state_list_script
	CurrentState = StateList.STATES[StateList.INITIAL_STATE].new()
	CurrentState.entity = entity
	
	# Call this method deferred because other nodes won't be instanced yet.
	call_deferred("enter_initial_state")

func enter_initial_state():
	CurrentState.name = StateList.INITIAL_STATE
	CurrentState.entity = entity
	CurrentState.state_list = StateList
	CurrentState._enter_state()
	ready_to_process = true

func reset():
	CurrentState._exit_state()
	CurrentState = StateList.STATES[StateList.INITIAL_STATE].new()
	enter_initial_state()
	emit_signal("state_changed", CurrentState.name)
	next_state = null

### Received events ###

# NOTE: States don't necessarily use events. Should this be removed from the fsm and
# entirely handled by the states themselves?

func receive_event(type, args):
	process_events = true
	CurrentState.received_events[type].append(args)

### Process Current State (called every frame by the entity) ###

func _process_current_state(delta, process_state):
	if ready_to_process:
		
		if forced_next_state != null:
			next_state = forced_next_state
			forced_next_state = null
		else:
			# Process events and check if state must be changed afterwards
			if process_events:
				CurrentState.process_received_events()
			
			next_state = CurrentState._get_next_state()
		
		# Change to a different state
		if next_state != null:
			CurrentState._exit_state()
			
			if StateList.STATES.has(next_state):
				CurrentState = StateList.STATES[next_state].new()
				CurrentState.entity = entity
				CurrentState.name = next_state
				CurrentState.state_list = StateList
				CurrentState._enter_state()
			else:
				print("ERROR Undefined State: " + next_state + "\n" + "Tried to access from: " + CurrentState.name)
				CurrentState = StateList.STATES[StateList.INITIAL_STATE].new()
				enter_initial_state()
				
			emit_signal("state_changed", CurrentState.name)
		
		# Run state update
		if process_state:
			CurrentState._process_state(delta)
