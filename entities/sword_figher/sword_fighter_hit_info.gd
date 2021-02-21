extends Resource

const HITS = {
	"off_hi_r_light" : {
		"damage" : 30, "knockback" : Vector2(0, -5), "is_directional" : true,
#		"tiredness" : 2, "hit_stop" : 0.25, "sp_gain" : 10,
#		"guard_break" : true, "pick_up" : true, "launcher" :  true,
#		"type" : Hit.HIT_TYPE.SWORD, "visual_effect" : Hit.VISUAL_EFFECTS.SLASH,
		},
	"off_hi_r_heavy" : {
		"damage" : 100, "knockback" : Vector2(0, -8), "is_directional" : true,
#		"tiredness" : 2, "hit_stop" : 0.25, "sp_gain" : 10,
#		"guard_break" : true, "pick_up" : true, "launcher" :  true,
#		"type" : Hit.HIT_TYPE.SWORD, "visual_effect" : Hit.VISUAL_EFFECTS.SLASH
		},
	"def_hi_light" : {
		"damage" : 40, "knockback" : Vector2(0, -5), "is_directional" : true,
#		"tiredness" : 2, "hit_stop" : 0.25, "sp_gain" : 10,
#		"guard_break" : true, "pick_up" : true, "launcher" :  true,
#		"type" : Hit.HIT_TYPE.SWORD, "visual_effect" : Hit.VISUAL_EFFECTS.SLASH,
		},
	"off_kick" : {
		"damage" : 10, "knockback" : Vector2(0, -12), "is_directional" : true,
		"guard_break" : true,
#		"tiredness" : 2, "hit_stop" : 0.25, "sp_gain" : 10,
#		"pick_up" : true, "launcher" :  true,
#		"type" : Hit.HIT_TYPE.SWORD, "visual_effect" : Hit.VISUAL_EFFECTS.SLASH,
		},
	"off_throw_f_startup" : {
		"grab" : true, "damage" : 125,
#		"knockback" : Vector2(0, -12), "is_directional" : true,
#		"tiredness" : 2, "hit_stop" : 0.25, "sp_gain" : 10,
#		"guard_break" : true, "pick_up" : true, "launcher" :  true,
#		"type" : Hit.HIT_TYPE.SWORD, "visual_effect" : Hit.VISUAL_EFFECTS.SLASH,
		},
	}
