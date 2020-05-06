extends "res://objects/collision_volume.gd"

#const EFFECTS = {
#	Hit.VISUAL_EFFECTS.PARRY : preload("res://effects/hit_effect_2/hit_effect_parry.tscn"),
#	Hit.VISUAL_EFFECTS.GUARD_BREAK : preload("res://effects/hit_effect_2/hit_effect_parry.tscn"),
#	Hit.VISUAL_EFFECTS.SHOT : preload("res://effects/hit_effect.tscn"),
#	Hit.VISUAL_EFFECTS.BLUNT : preload("res://effects/hit_effect_2/hit_effect_2.tscn"),
#	Hit.VISUAL_EFFECTS.SLASH : preload("res://effects/hit_effect_sword/hit_effect_sword.tscn"),
#	Hit.VISUAL_EFFECTS.FIRE : preload("res://effects/hit_effect_fire.tscn"),
#	}

export var parrying = false
export var defending = false
export var idling = false
export var spawn_hit_effect = true

#enum HIT_TYPE_INVUL {HORIZONTAL, VERTICAL, NULL}
export(Hit.EVASION_TYPES) var hit_type_invulnerability

var last_hitbox_activation_id = 0
var ignore_hits_from_direction = 0

signal received_hit(hit, hurtbox)
signal evaded_hit(hit)
# warning-ignore:unused_signal
signal dealt_parry(hit)
# warning-ignore:unused_signal
signal dealt_defense(hit)

func set_active(value):
	monitorable = value
	active = value
	.set_active(value)
	pass

func evaded_hit(hit):
	emit_signal("evaded_hit", hit)

func receive_hit(hit):
	emit_signal("received_hit", hit, self)
	
#	if spawn_hit_effect:
#		if hit.visual_effect_position_average:
#			spawn_effect(hit.visual_effect, hit.position, hit.direction)
#		else:
#			spawn_effect(hit.visual_effect, global_position, hit.direction)

#func spawn_effect(effect_type, p_position, direction):
#	if effect_type == null:
#		return
	
#	var effect_node = EFFECTS[effect_type].instance()
#	effect_node.set_position(p_position + Vector2(floor(rand_range(-10, 10)), floor(rand_range(-10, 10))))
#	effect_node.scale.x = direction
#	MainManager.current_level.layers["effects_mid"].add_child(effect_node)
