extends Node

signal changed_visible_collisions()

var visible_collisions = false

func _input(event):
	if event.is_pressed():
		if event.is_action("debug_zoom"):
			if DisplayManager.window_zoom < 4:
				DisplayManager.window_zoom += 1
			else:
				DisplayManager.window_zoom = 1
				
		elif event.is_action("debug_fullscreen"):
# warning-ignore:standalone_ternary
			DisplayManager.set_fullscreen(true) if not DisplayManager.fullscreen else DisplayManager.set_fullscreen(false)
#		
#		elif event.is_action("debug_reset"):
#			for enemy in get_node("/root/Game/Level").get_child(0).enemies:
#				enemy.reset()

		elif event.is_action("debug_visible_collisions"):
			if not visible_collisions:
				visible_collisions = true
			else:
				visible_collisions = false
			emit_signal("changed_visible_collisions")
			
		elif event.is_action("debug_frame_advance"):
			if get_tree().paused:
				get_tree().paused = false
				yield(get_tree(), "physics_frame")
				yield(get_tree(), "physics_frame")
				get_tree().paused = true
			else:
				get_tree().paused = true

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
#	print(rad2deg(1 * PI))
#	MainManager.player1.sp_lvl = 3

#export(NodePath) var sm
#export(NodePath) var sm1
#export(NodePath) var p1
#onready var label = $"Label"
#onready var label1 = $"Label1"
#const json = preload ("res://char/Player/frame_delay.json/")

#func _ready():
#	var dict = { "a" : 10, "b" : 20}
#	var save = File.new()
#	save.open("res://save.json", File.WRITE)
#	save.store_line(dict.to_json())
#	save.close()
	
#	var json = File.new()
#	var jsondict = {}
#	json.open("res://char/player/frame_delay.json", File.READ)
#	jsondict.parse_json(json.get_line())
#	json.close()
#	print(jsondict)

#	set_physics_process(false)
#	set_process(false)
#	pass
	
#var t = 0
#func _process(delta):
#	t += 1
#	if t > 50:
#		print(1/delta)
#		t = 0
#	label.set_text($"/root/Game)
#	pass

#var count = 0
#func _physics_process(delta):
#	count += 1
#	if count > 10:
#		label.set_text(str(1/delta))
#		count = 0
