extends Resource

const INITIAL_STATE = "offensive_stance"

const RESOURCE_COSTS = {
#	"state" : [sp, bullets, tension]
#	"cross_drive" : [100, 0, 0],
}

const STATES = {
	"offensive_stance" : preload("res://entities/sword_figher/states/sword_fighter_offensive_stance.gd"),
	"defensive_stance" : preload("res://entities/sword_figher/states/sword_fighter_defensive_stance.gd"),
	"off_hi_light" : preload("res://entities/sword_figher/states/sword_fighter_off_hi_light.gd"),
	"off_hi_heavy" : preload("res://entities/sword_figher/states/sword_fighter_off_hi_heavy.gd"),
	"off_hi_fierce" : preload("res://entities/sword_figher/states/sword_fighter_off_hi_fierce.gd"),
	"off_kick" : preload("res://entities/sword_figher/states/sword_fighter_off_kick.gd"),
	"off_block" : preload("res://entities/sword_figher/states/sword_fighter_off_block.gd"),
	"off_run" : preload("res://entities/sword_figher/states/sword_fighter_off_run.gd"),
	"def_hi_light" : preload("res://entities/sword_figher/states/sword_fighter_def_hi_light.gd"),
	"stance_switch" : preload("res://entities/sword_figher/states/sword_fighter_stance_switch.gd"),
	"walk" : preload("res://entities/sword_figher/states/sword_fighter_walk.gd"),
	"def_step" : preload("res://entities/sword_figher/states/sword_fighter_def_step.gd"),
	}
