extends Node

signal simulated_input(pad, key, state)

var enabled = false

export var pad = 0

export var up = false setget set_up
export var down = false setget set_down
export var left = false setget set_left
export var right = false setget set_right
export var light = false setget set_light
export var heavy = false setget set_heavy

func _ready():
	enabled = true

func set_up(value):
	if enabled:
		up = value
		emit_signal("simulated_input", pad, InputManager.UP, int(value))
func set_down(value):
	if enabled:
		down = value
		emit_signal("simulated_input", pad, InputManager.DOWN, int(value))
func set_left(value):
	if enabled:
		left = value
		emit_signal("simulated_input", pad, InputManager.LEFT, int(value))
func set_right(value):
	if enabled:
		right = value
		emit_signal("simulated_input", pad, InputManager.RIGHT, int(value))
func set_light(value):
	if enabled:
		light = value
		emit_signal("simulated_input", pad, InputManager.LIGHT, int(value))
func set_heavy(value):
	if enabled:
		heavy = value
		emit_signal("simulated_input", pad, InputManager.HEAVY, int(value))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
