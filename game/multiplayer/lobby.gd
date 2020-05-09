extends Control

const DEFAULT_PORT = 4561 #Don't use under 1024

onready var label = $Label

func _ready():
	# Connect all the callbacks related to networking.
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	NetworkManager.lobby_scene = self

#### Network callbacks from SceneTree ####

# Callback from SceneTree.
func _player_connected(_id):
	label.text = str(_id, " connected.")
	rpc("register_peer", $MyName.text)
	pass

func _player_disconnected(_id):
	NetworkManager.peers.erase(_id)
	update_peer_list()
	if get_tree().is_network_server():
		label.text = str(_id, " Client disconnected.")
	else:
		label.text = "Server disconnected."
	pass

# Callback from SceneTree, only for clients (not server).
func _connected_ok():
	label.text = "Connected to server."
	pass # We don't need this function.

# Callback from SceneTree, only for clients (not server).
func _connected_fail():
	label.text = "Couldn't connect to server."
	get_tree().network_peer = null # Remove peer.
	$Host.visible = true
	$Join.visible = true
	$Disconnect.visible = false
	$MyName.editable = true
	pass

func _server_disconnected():
	NetworkManager.peers.clear()
	update_peer_list()
	label.text = "Server disconnected."
	$Host.visible = true
	$Join.visible = true
	$Disconnect.visible = false
	$MyName.editable = true
	pass

remote func register_peer(name):
	var id = get_tree().get_rpc_sender_id()
	NetworkManager.peers[id] = name
	update_peer_list()

func update_peer_list():
	$Peers.text = str(NetworkManager.peers)

func _on_Host_pressed():
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_NONE)
	var err = host.create_server(DEFAULT_PORT, 1) # Maximum of 1 peer, since it's a 2-player game.
	if err != OK:
		# Is another server running?
		label.text = "Can't host, address in use."
		return
	
	get_tree().network_peer = host
	$Host.visible = false
	$Join.visible = false
	$Disconnect.visible = true
	$MyName.editable = false
	label.text = "Waitin' fo playa'..."
	pass

func _on_Join_pressed():
	var ip = $Adress.get_text()
	if not ip.is_valid_ip_address():
		label.text = "IP address is invalid."
		return
	
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_NONE)
	host.create_client(ip, DEFAULT_PORT)
	get_tree().network_peer = host
	
	$Host.visible = false
	$Join.visible = false
	$Disconnect.visible = true
	$MyName.editable = false
	label.text = "Waitin' fo serva'..."
	pass

func _on_Disconnect_pressed():
	if get_tree().has_network_peer():
		get_tree().network_peer.close_connection()
		get_tree().network_peer = null
		NetworkManager.peers.clear()
		
		$Host.visible = true
		$Join.visible = true
		$Disconnect.visible = false
		$MyName.editable = true
		update_peer_list()
		label.text = "Disconnected."
	else:
		label.text = "No connections active."
	pass # Replace with function body.

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
	label.text = str("Received ping from ", NetworkManager.peers[id])
	rpc_id(id, "ping_back", get_tree().network_peer.get_unique_id())

remote func ping_back(id):
	label.text = str(NetworkManager.peers[id], " Pinged back.")

func _on_StartGame_pressed():
#	if get_tree().network_peer.get_instance_id() == 1:
	NetworkManager.rpc("start_game")
	pass # Replace with function body.
