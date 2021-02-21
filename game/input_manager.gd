extends Node

enum {RELEASED, PRESSED}
enum {
	UP, DOWN, LEFT, RIGHT, LIGHT, HEAVY, GUARD, SPECIAL, STANCE, FIRE, TAUNT, EVADE, START,
	RIGHT_RIGHT, LEFT_LEFT, UP_UP, DOWN_DOWN,
	THROW,
}

const RETICLE_CONTROL_STRINGS = {0 : "Joystick", 1 : "Mouse", 2 : "D-pad"}

const KEY_TO_DIRECTIONS = {
	UP : Vector2.UP,
	DOWN : Vector2.DOWN,
	LEFT : Vector2.LEFT,
	RIGHT : Vector2.RIGHT,
	}
	
const DIRECTIONS_TO_KEYS = {
	Vector2.UP : UP,
	Vector2.DOWN : DOWN,
	Vector2.LEFT : LEFT,
	Vector2.RIGHT : RIGHT,
	}

onready var pad_0_device = preload("res://settings.tres").pad_0_device
onready var pad_1_device = preload("res://settings.tres").pad_1_device
onready var keyboard_pad = preload("res://settings.tres").keyboard_pad
onready var reticle_control = preload("res://settings.tres").reticle_control

signal key_changed(pad, key, state)

### Virtual Pads ###

var pad_0_state = {
	LIGHT : RELEASED,
	HEAVY : RELEASED,
	GUARD : RELEASED,
	STANCE : RELEASED,
	SPECIAL : RELEASED,
	FIRE : RELEASED,
	TAUNT : RELEASED,
	EVADE : RELEASED,
	START : RELEASED,
	UP : RELEASED,
	DOWN : RELEASED,
	LEFT : RELEASED,
	RIGHT : RELEASED,
	}

var pad_0_stick = Vector2(0.0, 0.0)

var pad_1_state = {
	LIGHT : RELEASED,
	HEAVY : RELEASED,
	GUARD : RELEASED,
	SPECIAL : RELEASED,
	FIRE : RELEASED,
	TAUNT : RELEASED,
	STANCE : RELEASED,
	EVADE : RELEASED,
	START : RELEASED,
	UP : RELEASED,
	DOWN : RELEASED,
	LEFT : RELEASED,
	RIGHT : RELEASED,
	}

var pad_1_stick = Vector2(0.0, 0.0)

onready var pads = {
	0 : pad_0_state,
	1 : pad_1_state,
	}

### Mapping / Device bindings ###

var pad_0_keys_joystick = {
	0 : [GUARD],
	3 : [HEAVY],
	1 : [STANCE],
	2 : [LIGHT],
#	2 : [SPECIAL],
	4 : [EVADE],
	6 : [GUARD, LIGHT],
	5 : [SPECIAL],
	7 : [TAUNT],
	11 : [START],
	12 : [UP],
	13 : [DOWN],
	14 : [LEFT],
	15 : [RIGHT],
	}

var pad_0_stick_joystick = {
	"x_axis" : 0,
	"y_axis" : 1
	}

var pad_1_keys_joystick = {
	0 : [GUARD],
	3 : [HEAVY],
	1 : [STANCE],
	2 : [LIGHT],
#	2 : [SPECIAL],
#	4 : [EVADE],
#	5 : [FIRE],
	4 : [SPECIAL],
	5 : [GUARD, LIGHT],
	7 : [TAUNT],
	11 : [START],
	12 : [UP],
	13 : [DOWN],
	14 : [LEFT],
	15 : [RIGHT],
	}

var pad_1_stick_joystick = {
	"x_axis" : 0,
	"y_axis" : 1
	}

var keys_keyboard = {
	KEY_SPACE : [GUARD],
	KEY_Q : [SPECIAL],
	KEY_SHIFT : [EVADE],
	KEY_TAB : [START],
	KEY_L : [START],
	KEY_W : [UP], 
	KEY_S : [DOWN],
	KEY_A : [LEFT],
	KEY_D : [RIGHT],
	KEY_Y : [LIGHT],
	KEY_G : [GUARD],
	KEY_U : [HEAVY],
	KEY_E : [HEAVY],
	KEY_H : [STANCE],
	KEY_CONTROL : [STANCE],
	KEY_I : [SPECIAL],
#	KEY_CONTROL : [SPECIAL, GUARD],

#	KEY_SPACE : [JUMP],
#	KEY_Q : [SPECIAL],
#	KEY_E : [CROSS, EVADE],
#	KEY_SHIFT : [EVADE],
#	KEY_ENTER : [START],
#	KEY_TAB : [START],
#	KEY_W : [UP],
#	KEY_S : [DOWN],
#	KEY_A : [LEFT],
#	KEY_D : [RIGHT],
#	KEY_R : [RELOAD],
#	KEY_CONTROL : [CROSS],
	}

var keys_mouse = {
	2 : [HEAVY],
	1 : [LIGHT],
	3 : [FIRE],
	}
	
var analog_to_digital_threshold = 0.5
var analog_to_digital = false

onready var pad_mappings = {
	0 : pad_0_keys_joystick,
	1 : pad_1_keys_joystick,
	}

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
#	set_process_input(true)
#	set_physics_process(true) # NOTE: shoud use _process or _fixed_process?

func emit_released_signal():
	for key in pad_0_state:
		if pad_0_state[key] == RELEASED:
			emit_signal("key_changed", 0, key, RELEASED)
	
	for key in pad_1_state:
		if pad_1_state[key] == RELEASED:
			emit_signal("key_changed", 1, key, RELEASED)

func reset_pads():
	for key in pad_0_state:
		pad_0_state[key] = RELEASED
	
	for key in pad_1_state:
		pad_1_state[key] = RELEASED

func set_pad_keys(event, pad, binding):
	if event.pressed:
		pads[pad][binding] = PRESSED
		emit_signal("key_changed", pad, binding, PRESSED)
	else:
		pads[pad][binding] = RELEASED
		emit_signal("key_changed", pad, binding, RELEASED)

func _input(event):
	if event is InputEventJoypadButton:
#		print(event.button_index)
		if event.device == pad_0_device:
			if pad_0_keys_joystick.has(event.button_index):
				for binding in pad_mappings[0][event.button_index]:
					set_pad_keys(event, 0, binding)
		
		if event.device == pad_1_device:
			if pad_1_keys_joystick.has(event.button_index):
				for binding in pad_mappings[1][event.button_index]:
					set_pad_keys(event, 1, binding)
	
	elif event is InputEventKey:
		if !event.is_echo():
#			print(event.scancode)
			if keys_keyboard.has(event.scancode):
				for binding in keys_keyboard[event.scancode]:
					if event.pressed:
						pads[keyboard_pad][binding] = PRESSED
						emit_signal("key_changed", keyboard_pad, binding, PRESSED)
					else:
						pads[keyboard_pad][binding] = RELEASED
						emit_signal("key_changed", keyboard_pad, binding, RELEASED)
				return
	
	elif event is InputEventMouseButton:
		if keys_mouse.has(event.button_index):
			for binding in keys_mouse[event.button_index]:
				if event.pressed:
					pads[keyboard_pad][binding] = PRESSED
					emit_signal("key_changed", keyboard_pad, binding, PRESSED)
				else:
					pads[keyboard_pad][binding] = RELEASED
					emit_signal("key_changed", keyboard_pad, binding, RELEASED)
		
		# Auto set reticle control
#		if reticle_control != 1:
#			reticle_control = 1
		return
	
	elif event is InputEventJoypadMotion:
		if event.device == pad_0_device:
			if event.axis == pad_0_stick_joystick["x_axis"]:
				pad_0_stick.x = event.axis_value
				analog_to_digital_x(0, event.axis_value)
			elif event.axis == pad_0_stick_joystick["y_axis"]:
				pad_0_stick.y = event.axis_value
				analog_to_digital_y(0, event.axis_value)
		if event.device == pad_1_device:
			if event.axis == pad_1_stick_joystick["x_axis"]:
				pad_1_stick.x = event.axis_value
				analog_to_digital_x(1, event.axis_value)
			elif event.axis == pad_1_stick_joystick["y_axis"]:
				pad_1_stick.y = event.axis_value
				analog_to_digital_y(1, event.axis_value)
		
		# Auto set reticle control
#		if reticle_control != 0:
#			reticle_control = 0
		return

func analog_to_digital_x(pad, axis_value):
	if not analog_to_digital:
		return
	if axis_value >= analog_to_digital_threshold and pads[pad][RIGHT] == RELEASED:
		pads[pad][RIGHT] = PRESSED
		emit_signal("key_changed", pad, RIGHT, PRESSED)
	elif axis_value < analog_to_digital_threshold and pads[pad][RIGHT] == PRESSED:
		pads[pad][RIGHT] = RELEASED
		emit_signal("key_changed", pad, RIGHT, RELEASED)
	elif axis_value <= -analog_to_digital_threshold and pads[pad][LEFT] == RELEASED:
		pads[pad][LEFT] = PRESSED
		emit_signal("key_changed", pad, LEFT, PRESSED)
	elif axis_value > -analog_to_digital_threshold and pads[pad][LEFT] == PRESSED:
		pads[pad][LEFT] = RELEASED
		emit_signal("key_changed", pad, LEFT, RELEASED)
	pass

func analog_to_digital_y(pad, axis_value):
	if not analog_to_digital:
		return
	if axis_value >= analog_to_digital_threshold and pads[pad][DOWN] == RELEASED:
		pads[pad][DOWN] = PRESSED
		emit_signal("key_changed", pad, DOWN, PRESSED)
	elif axis_value < analog_to_digital_threshold and pads[pad][DOWN] == PRESSED:
		pads[pad][DOWN] = RELEASED
		emit_signal("key_changed", pad, DOWN, RELEASED)
	elif axis_value <= -analog_to_digital_threshold and pads[pad][UP] == RELEASED:
		pads[pad][UP] = PRESSED
		emit_signal("key_changed", pad, UP, PRESSED)
	elif axis_value > -analog_to_digital_threshold and pads[pad][UP] == PRESSED:
		pads[pad][UP] = RELEASED
		emit_signal("key_changed", pad, UP, RELEASED)
	pass

# warning-ignore:unused_argument
func get_analog_stick(pad, analog_index):
	if pad == 0:
		return pad_0_stick
	elif pad == 1:
		return pad_1_stick

func pressed(key, pad):
	return pads[pad][key] == PRESSED

func released(key, pad):
	return pads[pad][key] == RELEASED

func get_direction(key):
	if KEY_TO_DIRECTIONS.has(key):
		return KEY_TO_DIRECTIONS[key]
	else:
		return null
