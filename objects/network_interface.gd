extends Node

export var enabled = true

var player_entity
var peer_entity

func _ready():
	if enabled and get_tree().has_network_peer():
		player_entity = get_node("../SwordFighter")
		peer_entity = get_node("../PeerSwordFighter")
		peer_entity.network_interface = self
		
		if get_tree().network_peer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
			NetworkManager.connect("peer_disconnected", self, "peer_disconnected")
			NetworkManager.connect("server_disconnected", self, "server_disconnected")
			
			player_entity.connect("ready", self, "player_ready")
			player_entity.connect("hp_changed", self, "player_entity_hp_changed")
			player_entity.connect("transform_changed", self, "player_entity_transform_changed")
			player_entity.connect("position_changed", self, "player_entity_position_changed")
			player_entity.connect("rotation_changed", self, "player_entity_rotation_changed")
			player_entity.connect("animation_changed", self, "player_entity_animation_changed")
#			player_entity.connect("dealt_hit", self, "player_entity_dealt_hit")
			
			if get_tree().is_network_server():
				player_entity.setup(1)
				peer_entity.setup(2)
				get_node("../PlayerName1").text = NetworkManager.my_info["name"]
				get_node("../PlayerName2").text = NetworkManager.peers[NetworkManager.peers.keys()[0]]["name"]
			else:
				player_entity.setup(2)
				peer_entity.setup(1)
				get_node("../PlayerName1").text = NetworkManager.peers[NetworkManager.peers.keys()[0]]["name"]
				get_node("../PlayerName2").text = NetworkManager.my_info["name"]
	
func peer_disconnected(id):
	enabled = false
	
func server_disconnected():
	enabled = false

func player_entity_hp_changed(new_value):
	if enabled:
		peer_entity.rpc_unreliable("update_hp", NetworkManager.my_id, new_value)
		
		if new_value == 0:
			rpc("round_end", NetworkManager.peers[NetworkManager.peers.keys()[0]]["name"])

func player_entity_transform_changed(new_value):
	if enabled:
		peer_entity.rpc_unreliable("update_transform", NetworkManager.my_id, new_value)

func player_entity_position_changed(new_value):
	if enabled:
		peer_entity.rpc_unreliable("update_position", NetworkManager.my_id, new_value)

func player_entity_rotation_changed(new_value):
	if enabled:
		peer_entity.rpc_unreliable("update_rotation", NetworkManager.my_id, new_value)
	
func player_entity_animation_changed(anim_name, seek_pos, blend_speed):
	if enabled:
		peer_entity.rpc("update_animation", NetworkManager.my_id, anim_name, seek_pos, blend_speed)

#func player_entity_dealt_hit(hit):
#	if enabled:
#		var hit_data = {
#			"name" : hit.name,
#			"damage" : hit.damage,
#			"knockback" : hit.knockback,
#			"direction" : hit.direction,
#			"grab" : hit.grab,
#			}
#		rpc("receive_hit_from_peer", NetworkManager.my_id, hit_data)

remote func receive_hit_from_peer(id, hit_data):
	var new_hit = Hit.new(Hit.INIT_TYPE.DEFAULT)
	for key in hit_data:
		new_hit.set(key, hit_data[key])
	player_entity._receive_hit(new_hit)

remote func receive_throw_from_peer(pos, rot, _throwing_entity):
	player_entity.receive_throw(pos, rot, peer_entity)
	pass

remotesync func player_ready():
	get_tree().paused = false

remotesync func round_end(winner):
	get_node("../RoundEnd").visible = true
	get_node("../RoundEnd/Name").text = winner
	get_node("../RoundEnd/Timer").start()
	get_tree().paused = true
	pass

remotesync func reset():
	get_node("../RoundEnd").visible = false
	player_entity.reset()
	peer_entity.reset()

func _on_Timer_timeout():
	rpc("reset")
