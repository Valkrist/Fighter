extends Node

const BASE_RESOLUTION = Vector2(1280, 720)
const MAX_ZOOM = 4

var zoom = 1 setget set_zoom
var window_zoom = 1 setget set_window_zoom
var fullscreen = false setget set_fullscreen

func _ready():
	zoom = preload("res://settings.tres").zoom
	self.window_zoom = preload("res://settings.tres").zoom
	self.fullscreen = preload("res://settings.tres").fullscreen
	if preload("res://settings.tres").center_window:
		OS.center_window()

func set_zoom(value):
#	if zoom <= MAX_ZOOM:
	zoom = value
#	if not fullscreen:
#		set_window_zoom(zoom)

func set_fullscreen(value):
	fullscreen = value
	OS.set_window_fullscreen(fullscreen)
	if fullscreen:
		zoom = OS.window_size.x / BASE_RESOLUTION.x
	else:
		set_window_zoom(window_zoom)

func set_window_zoom(value):
	window_zoom = value
	zoom = value
	OS.window_size = BASE_RESOLUTION * value
