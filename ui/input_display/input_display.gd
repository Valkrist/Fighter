extends Control

export var listen_to_pad = 0

onready var buttons = {
	InputManager.LIGHT : get_node("Control/UIButton4/Container/Button"),
	InputManager.HEAVY : get_node("Control/UIButton5/Container/Button"),
	InputManager.GUARD : get_node("Control/UIButton6/Container/Button"),
	InputManager.SPECIAL : get_node("Control/UIButton7/Container/Button"),
	InputManager.STANCE : get_node("Control/UIButton8/Container/Button"),
	InputManager.START : get_node("Control/UIButton12/Container/Button"),
	}

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
#	for button in buttons.keys():
#		button_colors[button] = buttons[button].get_parent().modulate

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func received_input(pad, key, state):
	if pad == listen_to_pad:
		if state:
			if buttons.has(key):
				buttons[key].modulate = Color.darkgray
			if stick.has(key):
				direction += dir_keys[key]
				$Control/StickContainer/Stick.position = direction.normalized() * 48
				$Control/StickContainer/StickBase.visible = true
				$Control/StickContainer/StickBase.rotation = atan2(direction.y, direction.x) + PI * 0.5
		else:
			if buttons.has(key):
				buttons[key].modulate = Color.white
			if stick.has(key):
				direction -= dir_keys[key]
				$Control/StickContainer/Stick.position = direction.normalized() * 48
				if direction == Vector2.ZERO:
					$Control/StickContainer/StickBase.visible = false
				$Control/StickContainer/StickBase.rotation = atan2(direction.y, direction.x) + PI * 0.5
