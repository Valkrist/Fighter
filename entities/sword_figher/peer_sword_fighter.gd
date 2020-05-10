extends Spatial
class_name PeerEntity

const PLAYER_1_MATERIAL = preload("res://entities/sword_figher/sword_fighter_player_1.material")
const PLAYER_2_MATERIAL = preload("res://entities/sword_figher/sword_fighter_player_2.material")

var animation_slot = 1

onready var model = $ModelContainer/sword_fighter
onready var model_container = $ModelContainer
onready var anim_tree = $AnimationTree
onready var anim_player = $ModelContainer/sword_fighter/AnimationPlayer
onready var animation_blender = $AnimationBlender

func _ready():
	$AnimationTree.active = true
	NetworkManager.connect("peer_transform_changed", self, "update_transform")
	NetworkManager.connect("peer_animation_changed", self, "update_animation")
	NetworkManager.connect("peer_rotation_changed", self, "update_rotation")
	NetworkManager.connect("peer_hp_changed", self, "update_hp")
	
	if get_tree().has_network_peer():
		if get_tree().is_network_server():
			$ModelContainer/sword_fighter/Armature/Skeleton/Cube.material_override = PLAYER_2_MATERIAL
			$ModelContainer/sword_fighter/Armature/Skeleton/sword.material_override = PLAYER_2_MATERIAL
			get_node("../PlayerName2").text = NetworkManager.peers[NetworkManager.peers.keys()[0]]["name"]
		else:
			$ModelContainer/sword_fighter/Armature/Skeleton/Cube.material_override = PLAYER_1_MATERIAL
			$ModelContainer/sword_fighter/Armature/Skeleton/sword.material_override = PLAYER_1_MATERIAL
			get_node("../PlayerName1").text = NetworkManager.peers[1]["name"]

func update_transform(id, new_transform):
	transform = new_transform

func update_rotation(id, new_rotation):
	model_container.rotation.y = new_rotation

func update_animation(id, anim_name, seek_pos, blend_speed):
	
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

func update_hp(id, new_hp):
	if get_tree().is_network_server():
		get_node("../Lifebar2")._on_sword_fighter_hp_changed(new_hp)
	else:
		get_node("../Lifebar")._on_sword_fighter_hp_changed(new_hp)

func _on_Hurtbox_received_hit(hit, hurtbox):
#	fsm.receive_event("_received_hit", hit)
	pass
