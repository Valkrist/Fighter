extends Node

export var idling = false setget set_idling
export var hyper_armor = false setget set_hyper_armor
export var mirage = false setget set_mirage
export var mirage_play_from_start = false
export var speed_up = false setget set_speed_up
export var is_defending = false setget set_defending
export var is_active = false setget set_active
export var is_cancelable = false setget set_cancelable
export var is_evade_cancelable = false setget set_evade_cancelable
export var is_command_cancelable = false setget set_command_cancelable
export var reload_cancelable = false setget set_reload_cancelable
export var is_stringable = false setget set_stringable
export var is_alt_stringable = false setget set_alt_stringable
export var animation_end = false setget set_animation_end
export var buffer_input = false
export var gravity = true setget set_gravity
export var no_root_motion_to_speed = false
export var track_target = true

signal flag_changed(flag, value)

func reset_all_flags():
	idling = false
	hyper_armor = false
	is_defending = false
	is_cancelable = false
	is_evade_cancelable = false
	is_command_cancelable = false
	reload_cancelable = false
	is_active = false
	is_stringable = false
	is_alt_stringable = false
	animation_end = false
	buffer_input = false
	gravity = true
	no_root_motion_to_speed = false
	track_target = true
#	if speed_up:
		# emit signal only if it was true
#		self.speed_up = false

func reset_flags(flags_to_reset = []):
	for flag in flags_to_reset:
		set(flag, false)

func set_flag(flag, value):
	set(flag, value)
	emit_signal("flag_changed", flag, value)

func set_speed_up(value):
	speed_up = value
	emit_signal("flag_changed", "speed_up", value)

func set_mirage(value):
	mirage = value

func set_hyper_armor(value):
	hyper_armor = value

func set_idling(value):
	idling = value
#	emit_signal("flag_changed", "idling", value)

func set_defending(value):
	is_defending = value
	emit_signal("flag_changed", "is_defending", value)

func set_cancelable(value):
	is_cancelable = value
	emit_signal("flag_changed", "is_cancelable", value)

func set_evade_cancelable(value):
	is_evade_cancelable = value
	emit_signal("flag_changed", "is_evade_cancelable", value)
	
func set_command_cancelable(value):
	is_command_cancelable = value
	emit_signal("flag_changed", "is_command_cancelable", value)

func set_reload_cancelable(value):
	reload_cancelable = value
	emit_signal("flag_changed", "reload_cancelable", value)
	
func set_active(value):
	is_active = value
	emit_signal("flag_changed", "is_active", value)

func set_stringable(value):
	is_stringable = value
	emit_signal("flag_changed", "is_stringable", value)

func set_alt_stringable(value):
	is_alt_stringable = value
	emit_signal("flag_changed", "is_alt_stringable", value)

func set_animation_end(value):
	animation_end = value
	emit_signal("flag_changed", "animation_ended", value)

func set_gravity(value):
	gravity = value
	emit_signal("flag_changed", "gravity", value)
