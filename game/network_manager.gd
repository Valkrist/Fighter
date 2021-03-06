extends Node

signal peer_connected(id)
signal peer_disconnected(id)
signal server_disconnected()
signal connected_to_server()
signal connection_failed()
signal server_creation_failed()
signal ip_address_invalid(ip)
signal peer_registered()

const DEFAULT_PORT = 4561 #Don't use under 1024
const NETWORK_STAGE = preload("res://stages/network_stage.tscn")

var my_id = 1
var peers = {}
var my_info = {
	"name" : "Anonymous"
}

var lobby_scene

func get_my_id():
	if get_tree().has_network_peer():
		return get_tree().get_network_unique_id()

func _ready():
	get_tree().connect("network_peer_connected", self, "_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_network_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		disconnect_network()

func _network_peer_connected(_id):
	rpc("register_peer", my_info)
	emit_signal("peer_connected", _id)

func _network_peer_disconnected(_id):
	peers.erase(_id)
	emit_signal("peer_disconnected", _id)
	disconnect_network()

# Callback from SceneTree, only for clients (not server).
func _connected_to_server():
	emit_signal("connected_to_server")
	pass # We don't need this function.

# Callback from SceneTree, only for clients (not server).
func _connection_failed():
	peers.clear()
	emit_signal("connection_failed")
	get_tree().network_peer.close_connection()
#	disconnect_network()

func _server_disconnected():
	peers.clear()
	emit_signal("server_disconnected")
	get_tree().network_peer.close_connection()
#	disconnect_network()

func host_game(port):
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_NONE)
	var err = host.create_server(port, 1) # Maximum of 1 peer, since it's a 2-player game.
	if err != OK:
		emit_signal("server_creation_failed")
	else:
		get_tree().network_peer = host
		my_id = host.get_unique_id()

func join_game(ip, port):
#	var ip = $Adress.get_text()
	if not ip.is_valid_ip_address() or port < 0 or port > 65535:
		emit_signal("ip_address_invalid", ip)
	else:
		var host = NetworkedMultiplayerENet.new()
		host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_NONE)
		host.create_client(ip, port)
		get_tree().network_peer = host
		my_id = host.get_unique_id()

func disconnect_network():
	if get_tree().has_network_peer() and get_tree().network_peer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		get_tree().network_peer.close_connection()
		peers.clear()
#		call_deferred("delete_network_peer")

func delete_network_peer():
	get_tree().network_peer = null

remote func register_peer(peer_info):
	var id = get_tree().get_rpc_sender_id()
	peers[id] = peer_info
	emit_signal("peer_registered")

remotesync func start_game():
#	lobby_scene.visible = false
	get_tree().paused = true
	lobby_scene.queue_free()
	get_tree().root.add_child(NETWORK_STAGE.instance())
