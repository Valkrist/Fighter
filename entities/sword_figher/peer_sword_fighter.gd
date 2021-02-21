extends KinematicBody
class_name PeerEntity

const PLAYER_1_MATERIAL = preload("res://entities/sword_figher/sword_fighter_player_1.material")
const PLAYER_2_MATERIAL = preload("res://entities/sword_figher/sword_fighter_player_2.material")

var network_interface
var player_side = 1
var animation_slot = 1
var throwing_entity = null
var throw_pos = Vector3.ZERO
var throw_rot = 0.0

onready var model = $ModelContainer/sword_fighter
onready var model_container = $ModelContainer
onready var anim_tree = $AnimationTree
onready var anim_player = $ModelContainer/sword_fighter/AnimationPlayer
onready var animation_blender = $AnimationBlender

func _ready():
	$AnimationTree.active = true

func setup(side):
	player_side = side
	if side == 1:
		$ModelContainer/sword_fighter/Armature/Skeleton/Cube.material_override = PLAYER_1_MATERIAL
		$ModelContainer/sword_fighter/Armature/Skeleton/sword.material_override = PLAYER_1_MATERIAL
	else:
		$ModelContainer/sword_fighter/Armature/Skeleton/Cube.material_override = PLAYER_2_MATERIAL
		$ModelContainer/sword_fighter/Armature/Skeleton/sword.material_override = PLAYER_2_MATERIAL

func reset():
	if throwing_entity != null:
		remove_collision_exception_with(throwing_entity)

func _on_Hurtbox_received_hit(hit, hurtbox):
	var hit_data = {
		"name" : hit.name,
		"damage" : hit.damage,
		"knockback" : hit.knockback,
		"direction" : hit.direction,
		"guard_break" : hit.guard_break,
		"grab" : hit.grab,
		}
	network_interface.rpc("receive_hit_from_peer", NetworkManager.my_id, hit_data)
	pass

func receive_throw(pos, rot, _throwing_entity):
	throwing_entity = _throwing_entity
	throw_pos = pos
	throw_rot = rot
	
	network_interface.rpc("receive_throw_from_peer", pos, rot, _throwing_entity)
	pass

func throw_stared():
	add_collision_exception_with(throwing_entity)
	translation = throw_pos
	model_container.rotation.y = throw_rot

func throw_ended():
	remove_collision_exception_with(throwing_entity)

remote func update_transform(id, new_transform):
	transform = new_transform

remote func update_position(id, new_position):
	transform.origin = new_position

remote func update_rotation(id, new_rotation):
	model_container.rotation.y = new_rotation

remote func update_animation(id, anim_name, seek_pos, blend_speed):
	
	if $AnimationEvents.has_animation(anim_name):
		$AnimationEvents.play(anim_name)
	
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

remote func update_hp(id, new_hp):
	if player_side == 1:
		get_node("../Lifebar")._on_sword_fighter_hp_changed(new_hp)
	else:
		get_node("../Lifebar2")._on_sword_fighter_hp_changed(new_hp)
