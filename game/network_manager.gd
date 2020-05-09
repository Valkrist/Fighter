extends Node

signal animation_changed(anim_name, seek_pos, blend_speed)

const NETWORK_STAGE = preload("res://stages/network_stage.tscn")

var peers = {}
var lobby_scene

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

remotesync func start_game():
	get_tree().root.add_child(NETWORK_STAGE.instance())
	lobby_scene.visible = false

remote func animation_changed(id, anim_name, seek_pos, blend_speed):
	emit_signal("animation_changed", anim_name, seek_pos, blend_speed)
