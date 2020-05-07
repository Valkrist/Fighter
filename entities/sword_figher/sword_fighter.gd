extends KinematicBody
class_name Entity

enum Stances {OFFENSIVE, DEFENSIVE, UNIQUE}
const TERMINAL_VELOCITY = -50

export(NodePath) var target
export var walk_speed = 3
export var default_ground_drag = 10
export var ground_drag = 10
export var default_tracking_speed = 20
export var tracking_speed = 20

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

onready var lock_on_target = get_node(target)
onready var input_listener = $InputListener
onready var model = $ModelContainer/sword_fighter
onready var camera_pivot = $CameraPointPivot
onready var camera_point = $CameraPointPivot/Position3D
onready var model_container = $ModelContainer
onready var anim_tree = $AnimationTree
onready var anim_player = $ModelContainer/sword_fighter/AnimationPlayer
onready var anim_state_machine = $AnimationTree.get("parameters/StateMachine/playback")
onready var fsm = $FSM
onready var flags = $AnimationFlags

func _ready():
	fsm.setup()
	$AnimationTree.active = true
	
#	Engine.time_scale = 0.25
	
	# HACK: Add one second to all animations that don't loop so that function calls at the end
	# of the animation are only processed once. AnimationPlayers that are contolled by an
	# AnimationTree will not emit signals and repeat the last frames of the animation while blending
	# (engine bug?).
#	for anim_name in anim_player.get_animation_list():
#		if not anim_player.get_animation(anim_name).loop:
#			anim_player.get_animation(anim_name).length += 1.0
	
#	lock_on_target = get_node(target)
#	pass # Replace with function body.
#	print(anim_tree.tree_root.get_node("attack_anim").animation)
#	anim_tree.tree_root.get_node("attack_anim").animation = "off_hi_r_light"
#	print(anim_tree.tree_root.get_node("walk_blend").get_blend_point_count())

func _on_InputListener_received_input(key, state):
	fsm.receive_event("_received_input", [key, state])
#	if state:
#		print(key)

var count = 0

func _physics_process(delta):
#	if $ModelContainer/sword_fighter/Armature/Skeleton/BoneAttachment/SwordHitbox.active:
#		print($ModelContainer/sword_fighter/Armature/Skeleton/BoneAttachment/SwordHitbox.get_overlapping_areas())
	
	target_point = lock_on_target.global_transform.origin
#	target_point = Vector3(target_point.x, 1.5, target_point.z)
	
	var target_vector = global_transform.origin.direction_to(target_point)
	target_rotation = PI + atan2(target_vector.x, target_vector.z)
	
	$CameraPointPivot/Position3D.look_at(target_point + Vector3(0.0, 1.0, 0.0), Vector3.UP)
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
	
	
	fsm._process_current_state(delta, true)
	
#	model.translation = model.get_node("Armature/Skeleton").get_bone_pose(0).origin / 1.65
#	print(model.get_node("Armature/Skeleton").get_bone_pose(0).origin)

#	var y_velocity = velocity.y
#
#	if motion_vector != Vector3.ZERO:
#		pass
#	else:
	
#	root_motion = -model.get_node("Armature/Skeleton").get_bone_pose(0).origin
#	model.get_node("Armature/Skeleton").set_bone_pose(0, Transform.IDENTITY)
	
	
#
#	velocity.y = y_velocity
	
#	if velocity.y > TERMINAL_VELOCITY:
#		velocity.y -= 9.8 * delta
#	else:
#		velocity.y = TERMINAL_VELOCITY
		
	velocity = move_and_slide(velocity, Vector3.UP, false, 4, 0.785398, true)
#	move_and_slide(velocity, Vector3.UP, false, 4, 0.785398, true)

#	$AnimationEvents.advance(delta)
#	$AnimationTree.advance(delta)

func set_velocity(_velocity):
	velocity = _velocity.rotated(Vector3.UP, model_container.rotation.y)

func apply_tracking(delta):
	var current_rot = model_container.rotation.y
	model_container.rotation.y = lerp_angle(current_rot, target_rotation, delta * tracking_speed)
#	model_container.rotation.y = target_rotation
	pass

func apply_drag(delta):
	if velocity.length_squared() < 0.05:
		velocity.x = 0.0
		velocity.z = 0.0
	else:
#		if abs(velocity.x) > 0: 
#		velocity.x -= ground_drag * delta * sign(velocity.x)
#		if abs(velocity.z) > 0: 
#		velocity.z -= ground_drag * delta * sign(velocity.z)
		velocity += velocity.rotated(Vector3.UP, deg2rad(180)).normalized() * ground_drag * delta
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
	
	velocity = -anim_tree.get_root_motion_transform().origin.rotated(Vector3.UP, model_container.rotation.y) * 40
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

	if $AnimationBlender.is_playing():
		$AnimationBlender.stop(false)
#		print($AnimationBlender.current_animation_position)

	if animation_slot == 1:
		if blend_speed == -1.0:
			anim_tree["parameters/1_and_-1/blend_amount"] = 1.0
			pass
		else:
			$AnimationBlender.play("blend_animation_1_animation_-1", -1, blend_speed)
#			prints("start blending from slot 0", anim_tree.tree_root.get_node("animation_0").animation,
#			"to", anim_tree.tree_root.get_node("animation_1").animation)
	else:
		if blend_speed == -1.0:
			anim_tree["parameters/1_and_-1/blend_amount"] = 0.0
		else:
			$AnimationBlender.play("blend_animation_1_animation_-1", -1, -blend_speed, true)
#			prints("start blending from slot 1", anim_tree.tree_root.get_node("animation_1").animation,
#			"to", anim_tree.tree_root.get_node("animation_0").animation)

	animation_slot = -animation_slot

func is_blending():
	return $AnimationBlender.is_playing()

func start_blend_with_space(backwards):
	fsm.receive_event("_animation_blend_started", "asd")
	if not backwards:
		$AnimationBlender.play("blend_animation_and_space", -1, 5.0)
	else:
		$AnimationBlender.play("blend_animation_and_space", -1, -5.0, true)

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

func tween_camera_position(position):
	var camera_pos = camera_pivot.get_node("Position3D").translation
#	var camera_rot = camera_pivot.get_node("Position3D").rotation_degrees
	$Tween.interpolate_property(
		$CameraPointPivot/Position3D, "translation",
		camera_pos, Vector3(position, camera_pos.y, camera_pos.z), 1,
		Tween.TRANS_QUAD, Tween.EASE_OUT)
#	$Tween.interpolate_property(
#		$CameraPointPivot/Position3D, "rotation_degrees",
#		camera_rot, Vector3(camera_rot.x, 15 * sign(position), camera_rot.z), 1,
#		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		
	$Tween.start()

func _on_Hurtbox_received_hit(hit, hurtbox):
	fsm.receive_event("_received_hit", hit)

func _on_Hitbox_dealt_hit(hit, collided_entity):
	fsm.receive_event("_dealt_hit", collided_entity) 
	pass # Replace with function body.
