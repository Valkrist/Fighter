extends "res://objects/collision_volume.gd"

export(GDScript) var hit_info
export(String) var hit_name = null
export var clear_hit_name = false

var one_way_direction = 0
var last_collided_entity

var overlapping_objects = []

signal dealt_hit(hit, collided_entity)
signal missed_hit(hit, collided_entity)

var f = 0

func set_active(value):
#	monitoring = value

	.set_active(value)
	
	if value:
		set_physics_process(true)
		$MeshInstance.visible = true
		pass
	else:
		f = 0
		set_physics_process(false)
		$MeshInstance.visible = false
		one_way_direction = 0
		if clear_hit_name:
			hit_name = null
			
	last_collided_entity = null

func _ready():
	set_physics_process(false)
	$MeshInstance.visible = false
#	print(owner.name)
#	print(ProjectSettings.get_setting("layer_names/2d_physics/layer_1"))
#	$Area2D.set_collision_layer_bit(, true)
#	connect("area_entered", $"..", "_on_Area2D_area_entered", [self])

func _physics_process(delta):
#	f += 1
#	prints(name, overlapping_objects, f)
	if get_overlapping_areas().size() != 0:
		if last_collided_entity == null:
#			last_collided_entity = get_overlapping_areas()[0].entity
			for area in get_overlapping_areas():
				build_hit(area)
			
#		prints(name, f)

func hit():
	set_active(true)
	# yield two frames to let the physics engine catch up and register collisions
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	set_active(false)

func hit_named(_hit_name):
	hit_name = _hit_name
	hit()

func receive_hit(hit):
	owner.hit = hit

func build_hit(area):
	var collided_entity = area.get_node("..").owner
	# avoid hitting self and avoid hittin the same entity twice
	if collided_entity == entity or last_collided_entity == collided_entity:
		return
	
	last_collided_entity = collided_entity
	
	# Build hit
	var new_hit = Hit.new(Hit.INIT_TYPE.DEFAULT)
	if hit_name != null:
		new_hit.name = hit_name
	
#		if hit_info.HITS.has(hit_name):
		for key in hit_info.HITS[hit_name]:
			new_hit.set(key, hit_info.HITS[hit_name][key])
		
		if new_hit.directional:
			new_hit.direction = owner.get_direction()
#		else:
#			new_hit.direction = int(sign(area.global_position.x - global_position.x))
		
	var collided_hurtbox = area
		
#	if collided_hurtbox.ignore_hits_from_direction != 0:
#		if new_hit.one_way:
#			new_hit.direction = -sign(owner.velocity.x)
#			if collided_hurtbox.ignore_hits_from_direction == new_hit.direction:
#				return
	
#	new_hit.position = global_transform.origin
	new_hit.source = entity
	
	# Check hit
	if collided_hurtbox.hit_type_invulnerability != Hit.EVASION_TYPES.NONE:
		if new_hit.evasion_type == Hit.EVASION_TYPES.BOTH or new_hit.evasion_type == collided_hurtbox.hit_type_invulnerability:
			collided_hurtbox.evaded_hit(new_hit)
			emit_signal("missed_hit", new_hit, collided_entity)
			return
			
	collided_hurtbox.receive_hit(new_hit)
	emit_signal("dealt_hit", new_hit, collided_entity)


func _on_Hitbox_area_entered(area):
#	print("ASD")
#	overlapping_objects.append(area)
	pass # Replace with function body.


func _on_Hitbox_area_exited(area):
#	overlapping_objects.erase(area)
#	print("zxc")
	pass # Replace with function body.
