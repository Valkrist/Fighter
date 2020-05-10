extends Control

const STAGE = preload("res://stages/stage.tscn")

onready var label = $Label

func _ready():
	# Connect all the callbacks related to networking.
	NetworkManager.connect("peer_connected", self, "_player_connected")
	NetworkManager.connect("peer_disconnected", self, "_player_disconnected")
	NetworkManager.connect("connection_failed", self, "_connected_fail")
	NetworkManager.connect("connected_to_server", self, "_connected_ok")
	NetworkManager.connect("server_disconnected", self, "_server_disconnected")
	NetworkManager.connect("peer_registered", self, "update_peer_list")
	
#	get_tree().connect("network_peer_connected", self, "_player_connected")
#	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
#	get_tree().connect("connected_to_server", self, "_connected_ok")
#	get_tree().connect("connection_failed", self, "_connected_fail")
#	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	NetworkManager.lobby_scene = self

#### Network callbacks from SceneTree ####

func _player_connected(_id):
	if get_tree().is_network_server():
		label.text = str(_id, " Client connected.")
		$StartNetGame.disabled = false
	else:
		label.text = "Connected to server."
	$Ping.disabled = false

func _player_disconnected(_id):
	update_peer_list()
	if get_tree().is_network_server():
		label.text = str(_id, " Client disconnected.")
		if NetworkManager.peers.size() == 0:
			$StartNetGame.disabled = true
	else:
		# Assuming there are only two people:
		label.text = "Server disconnected."
		$Ping.disabled = true

func _connected_ok():
	label.text = "Connected to server. Waiting for host to start game."
	pass

func _connected_fail():
	label.text = "Couldn't connect to server."
	get_tree().network_peer = null # Remove peer.
	$Host.visible = true
	$Join.visible = true
	$Disconnect.visible = false
	$MyName.editable = true
	$Ping.disabled = true

func _server_disconnected():
	update_peer_list()
	label.text = "Server disconnected."
	$Host.visible = true
	$Join.visible = true
	$Disconnect.visible = false
	$MyName.editable = true
	$Ping.disabled = true
	$StartSingleGame.disabled = false

func update_peer_list():
	$Peers.text = str(NetworkManager.peers)

func _on_Host_pressed():
	NetworkManager.my_info["name"] = $MyName.text
	NetworkManager.host_game()
	
	$Host.visible = false
	$Join.visible = false
	$Disconnect.visible = true
	$MyName.editable = false
	$StartSingleGame.disabled = true
	label.text = "Waitin' fo playa'..."

func _on_Join_pressed():
	if not $Adress.text.is_valid_ip_address():
		label.text = "Ip address is invalid."
	else:
		NetworkManager.my_info["name"] = $MyName.text
		NetworkManager.join_game($Adress.text)
		
		$Host.visible = false
		$Join.visible = false
		$Disconnect.visible = true
		$MyName.editable = false
		$StartSingleGame.disabled = true
		label.text = "Waitin' fo serva'..."

func _on_Disconnect_pressed():
	if get_tree().has_network_peer():
		NetworkManager.disconnect_network()
		$Host.visible = true
		$Join.visible = true
		$Disconnect.visible = false
		$MyName.editable = true
		$Ping.disabled = true
		$StartSingleGame.disabled = false
		update_peer_list()
		label.text = "Disconnected."
	else:
		label.text = "No connections active."

func _on_Ping_pressed():
	if get_tree().has_network_peer():
		var status = get_tree().network_peer.get_connection_status()
		if status == NetworkedMultiplayerPeer.CONNECTION_CONNECTED and NetworkManager.peers.size() > 0:
			rpc("ping", get_tree().network_peer.get_unique_id())
		else:
			label.text = "No peers to ping to."
	else:
		label.text = "No connections active."
	pass # Replace with function body.

remote func ping(id):
	label.text = str("Received ping from ", NetworkManager.peers[id]["name"])
	rpc_id(id, "ping_back", get_tree().network_peer.get_unique_id())

remote func ping_back(id):
	label.text = str(NetworkManager.peers[id]["name"], " Pinged back.")

func _on_StartNetGame_pressed():
	if get_tree().has_network_peer():
		if NetworkManager.peers.size() == 0:
			label.text = "No peers to start game with."
		else:
			NetworkManager.rpc("start_game")
	else:
		label.text = "No connections active."

func _on_StartSingleGame_pressed():
	NetworkManager.disconnect_network()
	visible = false
	get_tree().root.add_child(STAGE.instance())
