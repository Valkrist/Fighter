extends Reference
class_name Hit

###################################################
# Class containing hit data to pass around entities
###################################################

# Hit parameters: How much damage does it deal, how much knockback it causes, does it break guard?, etc...
var name : String = "default"
var damage : int = 0
var tiredness: int = 0
var knockback : Vector2 = Vector2.ZERO
var direction : int = 1
var position : Vector2 = Vector2.ZERO
var stun : float = 0.4
var hit_stop : float = 0.0
var guard_break : bool = false
var directional : bool = true
var one_way : bool = false
var launcher : bool = false
var turn_around : bool = false
var stuns : bool = true
var hyper_armor_break : bool = false
var pick_up : bool = false
var bounce : bool = false
var crush : bool = false
var grab : bool = false
var sp_gain = 0
var source

enum HIT_TYPE {NONE, SHOT, KICK, SWORD, SPECIAL}
var type = HIT_TYPE.NONE

enum EVASION_TYPES {NONE, HORIZONTAL, VERTICAL, BOTH}
var evasion_type = EVASION_TYPES.NONE

enum VISUAL_EFFECTS {SLASH, BLUNT, FIRE, SHOT, PARRY, GUARD_BREAK, DP, HYPER_ARMOR}
var visual_effect = VISUAL_EFFECTS.BLUNT
var visual_effect_position_average = true

enum INIT_TYPE {DEFAULT, WALL, PARRY}

func _init(_type):
	if _type == INIT_TYPE.WALL:
		damage = 5
		hit_stop = 0.2
	elif _type == INIT_TYPE.PARRY:
		damage = 20
		tiredness = 75
		knockback = Vector2(100, -100)
		visual_effect = VISUAL_EFFECTS.PARRY
