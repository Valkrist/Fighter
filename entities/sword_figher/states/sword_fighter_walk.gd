extends "res://entities/sword_figher/states/sword_fighter_state.gd"

const DIRECTION_ANIMS = {
	Vector2.UP : "off_walk_forward",
	Vector2.DOWN : "off_walk_back",
	Vector2.LEFT : "off_walk_left",
	Vector2.RIGHT : "off_walk_right",
	Vector2(-1, 1) : "off_walk_back",
	Vector2(1, 1) : "off_walk_back",
	Vector2(1, -1) : "off_walk_forward",
	Vector2(-1, -1) : "off_walk_forward",
	Vector2.ZERO : "",
}

var direction = Vector2.ZERO
var old_direction = Vector2.ZERO

# Initialize state here: Set animation, add impulse, etc.
func _enter_state():
	add_direction()
	old_direction = direction
	entity.set_animation(DIRECTION_ANIMS[direction], -1, 10.0)
	pass

# Inverse of enter_state.
#func _exit_state():
#	pass

func _process_state(delta):
	direction = Vector2.ZERO
	add_direction()
	
	if direction == Vector2.ZERO:
		if entity.current_stance == entity.Stances.OFFENSIVE:
			set_next_state("offensive_stance")
		elif entity.current_stance == entity.Stances.DEFENSIVE:
			set_next_state("defensive_stance")
		return
		
	elif old_direction != direction:
		entity.set_animation(DIRECTION_ANIMS[direction], 0, 6.0)
		old_direction = direction
	
	entity.anim_tree["parameters/walk_blend/blend_position"] = direction #* blend_amount
#	entity.motion_vector = Vector3(direction.x, 0, direction.y).normalized()
	entity.motion_vector = Vector3(direction.x, 0, direction.y)
	
	entity.apply_tracking(delta)
	entity.apply_root_motion(delta)

func add_direction():
	if entity.input_listener.is_key_pressed(InputManager.UP):
		direction += Vector2.UP
	if entity.input_listener.is_key_pressed(InputManager.DOWN):
		direction += Vector2.DOWN
	if entity.input_listener.is_key_pressed(InputManager.LEFT):
		direction += Vector2.LEFT
	if entity.input_listener.is_key_pressed(InputManager.RIGHT):
		direction += Vector2.RIGHT

#func _received_input(key, state):
#	if key == InputManager.LIGHT:
#		set_next_state("off_hi_light")
#	elif key == InputManager.HEAVY:
#		set_next_state("off_hi_heavy")
#	elif key == InputManager.GUARD:
#		if entity.input_listener.is_key_pressed(InputManager.UP):
#			set_next_state("off_kick")
#		else:
#			set_next_state("off_block")
