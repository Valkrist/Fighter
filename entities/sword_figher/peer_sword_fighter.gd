extends Spatial

var animation_slot = 1

onready var model = $ModelContainer/sword_fighter
onready var model_container = $ModelContainer
onready var anim_tree = $AnimationTree
onready var anim_player = $ModelContainer/sword_fighter/AnimationPlayer

func _ready():
	$AnimationTree.active = true
	NetworkManager.connect("animation_changed", self, "set_animation")

func set_animation(anim_name, seek_pos, blend_speed):
	
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

func _on_Hurtbox_received_hit(hit, hurtbox):
#	fsm.receive_event("_received_hit", hit)
	pass
