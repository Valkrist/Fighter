extends KinematicBody
class_name Entity

signal hp_changed(new_value)
# warning-ignore:unused_signal
signal transform_changed(new_value)
signal position_changed(new_value)
signal rotation_changed(new_value)
signal animation_changed(anim_name, seek_pos, blend_speed)
signal dealt_hit(hit)
signal requested_camera(entity)

enum Stances {OFFENSIVE, DEFENSIVE, UNIQUE}
const TERMINAL_VELOCITY = -50
const PLAYER_1_MATERIAL = preload("res://entities/sword_figher/sword_fighter_player_1.material")
const PLAYER_2_MATERIAL = preload("res://entities/sword_figher/sword_fighter_player_2.material")

export(NodePath) var target
export var walk_speed = 3
export var default_ground_drag = 10
export var ground_drag = 10
export var default_tracking_speed = 20
export var tracking_speed = 20
export var max_hp = 1000

var player_side = 0
var hp = 1000 setget set_hp
var received_hit : Hit
var has_camera = false setget set_has_camera
var camera_side = 1
var target_point = Vector3.ZERO
var target_rotation = 0.0
var motion_vector = Vector3.ZERO
var velocity = Vector3.ZERO
var on_ground = true
var root_motion = Vector3.ZERO
var animation_ended = false
var old_animation = ""
var animation_slot = 1
var current_stance = Stances.UNIQUE
var throwing_entity = null
var receive_throw_pos = Vector3.ZERO
var receive_throw_rot = 0.0

onready var lock_on_target : Spatial = get_node(target)
onready var input_listener = $InputListener
onready var model = $ModelContainer/sword_fighter
onready var camera_pivot = $CameraPointPivot
onready var camera_point = $CameraPointPivot/Position3D
onready var default_camera_pos = $CameraPointPivot/Position3D.translation
onready var model_container = $ModelContainer
onready var anim_tree = $AnimationTree
onready var anim_player = $ModelContainer/sword_fighter/AnimationPlayer
onready var animation_blender = $AnimationBlender
onready var fsm = $FSM
onready var flags = $AnimationFlags

func set_hp(value):
	hp = clamp(value, 0, max_hp)
	emit_signal("hp_changed", hp)

func set_has_camera(value):
	has_camera = value
	if value:
		input_listener.reverse_left_right = false
#		input_listener.reverse_up_down = false
	else:
		input_listener.reverse_left_right = true
#		input_listener.reverse_up_down = true

func get_direction():
	return model_container.transform.basis.get_euler()

func _ready():
	fsm.setup()
	$AnimationTree.active = true
	emit_signal("ready")
	
func setup(side):
	player_side = side
	if player_side == 1:
		transform = get_node("../Player1Pos").transform
		connect("hp_changed", get_node("../Lifebar"), "_on_sword_fighter_hp_changed")
		$ModelContainer/sword_fighter/Armature/Skeleton/Cube.material_override = PLAYER_1_MATERIAL
		$ModelContainer/sword_fighter/Armature/Skeleton/sword.material_override = PLAYER_1_MATERIAL
	elif player_side == 2:
		transform = get_node("../Player2Pos").transform
		connect("hp_changed", get_node("../Lifebar2"), "_on_sword_fighter_hp_changed")
		$ModelContainer/sword_fighter/Armature/Skeleton/Cube.material_override = PLAYER_2_MATERIAL
		$ModelContainer/sword_fighter/Armature/Skeleton/sword.material_override = PLAYER_2_MATERIAL

func reset():
	self.hp = max_hp
	fsm.setup()
	if throwing_entity != null:
		remove_collision_exception_with(throwing_entity)
	if player_side == 1:
		transform = get_node("../Player1Pos").transform
	else:
		transform = get_node("../Player2Pos").transform
	emit_signal("ready")

func _on_InputListener_received_input(key, state):
	fsm.receive_event("_received_input", [key, state])
#	if state:
#		print(key)

var count = 0

func _physics_process(delta):
	target_point = lock_on_target.global_transform.origin
#	target_point = Vector3(target_point.x, 1.5, target_point.z)
	
	var target_vector = global_transform.origin.direction_to(target_point)
	target_rotation = PI + atan2(target_vector.x, target_vector.z)
	
	camera_point.look_at(target_point + Vector3(0.0, 1.0, 0.0), Vector3.UP)
#	$CameraPointPivot/Position3D.rotation.z = 0
#	$CameraPointPivot/Position3D.rotation.y = 0
#	$CameraPointPivot/Position3D.rotation.x = 0
	
#	if count > 3:
#		print(atan2(target_vector.z, target_vector.x))
#		count = 0
#	count += 1
	var current_rot = camera_pivot.rotation.y
	camera_pivot.rotation.y = lerp_angle(current_rot, target_rotation, delta * 15)
	
#	var start = $ModelContainer/CameraPointPivot.transform.basis.get_euler()
#	var end = Quat(target_vector)
	
#	$ModelContainer/CameraPointPivot.transform.basis = Basis(start.slerp(end, delta))
	
#	var dir_vector = global_transform.origin.direction_to(target_point)
#	var target_transform = $ModelContainer/CameraPointPivot.global_transform.looking_at(dir_vector)
#	var my_dir = transform.basis.get_rotation_quat()
	
#			if (target.length() > 0.001):
#	var q_from = Quat($ModelContainer/CameraPointPivot.transform.basis.orthonormalized())
#	var q_to = Quat($ModelContainer/CameraPointPivot.transform.looking_at(target_point, Vector3(0,1,0)).basis)
#	
			# interpolate current rotation with desired one
	
	
	
#	model.translation = model.get_node("Armature/Skeleton").get_bone_pose(0).origin / 1.65
#	print(model.get_node("Armature/Skeleton").get_bone_pose(0).origin)

#	var y_velocity = velocity.y
#
#	if motion_vector != Vector3.ZERO:
#		pass
#	else:
	
#	root_motion = -model.get_node("Armature/Skeleton").get_bone_pose(0).origin
#	model.get_node("Armature/Skeleton").set_bone_pose(0, Transform.IDENTITY)
	
	if velocity.y > TERMINAL_VELOCITY:
		if not is_on_floor():
			velocity.y -= 9.8 * delta * 20
		else:
			velocity.y -= 9.8 * delta * 0.3
	else:
		velocity.y = TERMINAL_VELOCITY
	
	velocity = move_and_slide(velocity, Vector3.UP, false, 4, 0.785398, true)
#	velocity = move_and_slide_with_snap(velocity, Vector3.DOWN, Vector3.UP, false, 4, 0.785398, true)
#	move_and_slide(velocity, Vector3.UP, false, 4, 0.785398, true)
#	if count > 4:
#		prints(name, velocity)
#		prints(is_on_floor())
#		count = 0
#	count += 1

	fsm._process_current_state(delta, true)
	
#	emit_signal("transform_changed", transform)
	emit_signal("position_changed", transform.origin)

func set_velocity(_velocity):
	velocity = _velocity.rotated(Vector3.UP, model_container.rotation.y)
	
func add_impulse(value : Vector3):
	velocity += value

func apply_tracking(delta):
	var current_rot = model_container.rotation.y
	model_container.rotation.y = lerp_angle(current_rot, target_rotation, delta * tracking_speed)
#	model_container.rotation.y = target_rotation
	emit_signal("rotation_changed", model_container.rotation.y)
	
func apply_drag(delta):
	if velocity.length_squared() < 0.05:
		velocity.x = 0.0
		velocity.z = 0.0
	else:
#		if abs(velocity.x) > 0: 
#		velocity.x -= ground_drag * delta * sign(velocity.x)
#		if abs(velocity.z) > 0: 
#		velocity.z -= ground_drag * delta * sign(velocity.z)
		var negative_vector = velocity.rotated(Vector3.UP, deg2rad(180)).normalized() * ground_drag * delta
		velocity += Vector3(negative_vector.x, 0.0, negative_vector.z)
#	print(velocity)

func apply_root_motion(delta):
	
#	if flags.no_root_motion_to_speed and root_motion.length() < 0.1:
#		old = root_motion
#		print("ASD")
#	else:
#		speed = root_motion - old
#		old = root_motion
	
#	if (root_motion - old).length() < 0.1 or flags.no_root_motion_to_speed:
#		speed = root_motion - old
#	old = root_motion
#	velocity = (speed).rotated(Vector3.UP, model_container.rotation.y) * 40
	var root_motion_speed = -anim_tree.get_root_motion_transform().origin.rotated(Vector3.UP, model_container.rotation.y) * 40
	velocity = Vector3(root_motion_speed.x, velocity.y, root_motion_speed.z)
#	print(-anim_tree.get_root_motion_transform().origin)
	pass

func get_current_animation():
	return $AnimationEvents.assigned_animation

func set_animation(anim_name, seek_pos, blend_speed):
	
	if $AnimationEvents.has_animation(anim_name):
		$AnimationEvents.stop()
		$AnimationEvents.play(anim_name)
#		$AnimationEvents.current_animation = anim_name
	
	if animation_slot == -1:
		anim_tree.tree_root.get_node("animation_1").animation = anim_name
		anim_tree["parameters/animation_1_seek/seek_position"] = seek_pos
	else:
		anim_tree.tree_root.get_node("animation_-1").animation = anim_name
		anim_tree["parameters/animation_-1_seek/seek_position"] = seek_pos

	# Blend animations:

	if animation_blender.is_playing():
		animation_blender.stop(false)
#		print(animation_blender.current_animation_position)

	if animation_slot == 1:
		if blend_speed == -1.0:
			anim_tree["parameters/1_and_-1/blend_amount"] = 1.0
			pass
		else:
			animation_blender.play("blend_animation_1_animation_-1", -1, blend_speed)
#			prints("start blending from slot 0", anim_tree.tree_root.get_node("animation_0").animation,
#			"to", anim_tree.tree_root.get_node("animation_1").animation)
	else:
		if blend_speed == -1.0:
			anim_tree["parameters/1_and_-1/blend_amount"] = 0.0
		else:
			animation_blender.play("blend_animation_1_animation_-1", -1, -blend_speed, true)
#			prints("start blending from slot 1", anim_tree.tree_root.get_node("animation_1").animation,
#			"to", anim_tree.tree_root.get_node("animation_0").animation)

	animation_slot = -animation_slot
	emit_signal("animation_changed", anim_name, seek_pos, blend_speed)

func is_blending():
	return animation_blender.is_playing()

func start_blend_with_space(backwards):
	fsm.receive_event("_animation_blend_started", "asd")
	if not backwards:
		animation_blender.play("blend_animation_and_space", -1, 5.0)
	else:
		animation_blender.play("blend_animation_and_space", -1, -5.0, true)

func _on_AnimationBlender_animation_finished(anim_name):
	pass # Replace with function body.

func blend_ended(side):
	if side == 1:
		prints("ended blend from slot 0", anim_tree.tree_root.get_node("animation_0").animation,
		"to", anim_tree.tree_root.get_node("animation_1").animation)
	else:
		prints("ended blend from slot 1", anim_tree.tree_root.get_node("animation_1").animation,
		"to", anim_tree.tree_root.get_node("animation_0").animation)

func _on_AnimationFlags_flag_changed(flag, value):
	fsm.receive_event("_flag_changed", [flag, value])

func _on_AnimationEvents_animation_finished(anim_name):
	fsm.receive_event("_animation_finished", anim_name)

func request_camera(side):
	if not has_camera:
		set_camera_side(side)
		emit_signal("requested_camera", self)

func set_camera_side(side):
#	if not has_camera:
#		return
		
	camera_side = side
	camera_point.translation.x = default_camera_pos.x * side
	camera_point.look_at(target_point + Vector3(0.0, 1.0, 0.0), Vector3.UP)

func tween_camera_position(position):
	if not has_camera:
		return

	$Tween.interpolate_property(
		$CameraPointPivot/Position3D, "translation",
		camera_point.translation, Vector3(position, camera_point.translation.y, camera_point.translation.z), 1,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	if position != 0:
		camera_side = sign(position)
#	$Tween.interpolate_property(
#		$CameraPointPivot/Position3D, "rotation_degrees",
#		camera_rot, Vector3(camera_rot.x, 15 * sign(position), camera_rot.z), 1,
#		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		
	$Tween.start()

func reset_hitboxes():
	$ModelContainer/Hitbox.active = false
	$ModelContainer/Hitbox2.active = false

func _receive_hit(hit):
	received_hit = hit
	fsm.receive_event("_received_hit", hit)

func _on_Hurtbox_received_hit(hit, hurtbox):
	_receive_hit(hit)

func _on_Hitbox_dealt_hit(hit : Hit, collided_entity):
	fsm.receive_event("_dealt_hit", collided_entity)
	emit_signal("dealt_hit", hit)
	
func receive_throw(pos, rot, _throwing_entity):
	throwing_entity = _throwing_entity
	receive_throw_pos = pos
	receive_throw_rot = rot
	
#	add_collision_exception_with(_throwing_entity)
#	translation = pos
#	model_container.rotation.y = rot
	pass

#func follow_throw_position(delta):
#	if throwing_entity != null:
#		translation = throwing_entity.get_node("ModelContainer/sword_fighter/Armature/Skeleton/ThrowAttachment").global_transform.origin

func _on_RSide_body_entered(body):
	if not body == self and body is KinematicBody:
		if body.get_current_animation() == "run_loop":
			if has_camera:
				body.request_camera(-1)
			else:
				request_camera(-1)

func _on_LSide_body_entered(body):
	if not body == self and body is KinematicBody:
		if body.get_current_animation() == "run_loop":
			if has_camera:
				body.request_camera(1)
			else:
				request_camera(1)
