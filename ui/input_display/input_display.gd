extends Control

export var listen_to_pad = 0

var buttons = [
	InputManager.LIGHT,
	InputManager.HEAVY,
	InputManager.GUARD,
	InputManager.SPECIAL,
	InputManager.STANCE,
	InputManager.START,
	]

var stick = [
	InputManager.UP,
	InputManager.DOWN,
	InputManager.LEFT,
	InputManager.RIGHT,
	]

var dir_keys = {
	InputManager.UP: Vector2.UP,
	InputManager.DOWN: Vector2.DOWN,
	InputManager.LEFT: Vector2.LEFT,
	InputManager.RIGHT: Vector2.RIGHT,
}

var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	InputManager.connect("key_changed", self, "received_input")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func received_input(pad, key, state):
	if pad == listen_to_pad:
		if state:
			if buttons.has(key):
				$Control.get_node(str(key)).modulate = Color.darkgray
			if stick.has(key):
				direction += dir_keys[key]
				$Control/StickContainer/Stick.position = direction * 32
		else:
			if buttons.has(key):
				$Control.get_node(str(key)).modulate = Color.white
			if stick.has(key):
				direction -= dir_keys[key]
				$Control/StickContainer/Stick.position = direction * 32
